#!/usr/bin/env lua
-- Run from ~/.config/hypr: lua tests/menus.lua
print("START: Elephant/Walker menu regression test")

local utf8 = require("utf8")
local script = arg[0] or "tests/menus.lua"
local root = script:match("^(.*)/tests/menus.lua$") or "."
local provider_names = {
  "main",
  "capture",
  "install",
  "install-ai",
  "install-editor",
  "install-font",
  "install-gaming",
  "install-terminal",
  "learn",
  "remove",
  "screenshot",
  "setup",
  "setup-config",
  "share",
  "style",
  "system",
  "update",
  "update-restart",
  "dynamic/themes",
  "dynamic/fonts",
  "dynamic/wallpapers",
  "dynamic/screenrecord",
}

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function stream(output)
  local lines = {}
  for line in output:gmatch("[^\n]+") do
    lines[#lines + 1] = line
  end
  local index = 0
  return {
    read = function(_, pattern)
      assert(pattern == "*l")
      index = index + 1
      return lines[index]
    end,
    lines = function()
      return function()
        index = index + 1
        return lines[index]
      end
    end,
    close = function() end,
  }
end

local function load_provider(name, home, popen)
  local env = setmetatable({
    io = { popen = popen },
    os = {
      getenv = function(variable)
        return variable == "HOME" and home or nil
      end,
    },
  }, { __index = _G })
  local path = root .. "/elephant/menus/" .. name .. ".lua"
  local chunk = assert(loadfile(path, "t", env), "cannot load " .. path)
  assert(pcall(chunk))
  return env
end

local function has_private_use(text)
  for _, codepoint in utf8.codes(text) do
    if codepoint >= 0xE000 and codepoint <= 0xF8FF
      or codepoint >= 0xF0000 and codepoint <= 0xFFFFD
      or codepoint >= 0x100000 and codepoint <= 0x10FFFD then
      return true
    end
  end
  return false
end

local function assert_icon(icon, where)
  assert(type(icon) == "string" and icon ~= "", where .. " has no icon")
  assert(not has_private_use(icon), where .. " uses a private-use icon")
end

local function inspect_value(value, where)
  if type(value) == "string" then
    assert(not value:lower():find("omarchy", 1, true), where .. " references Omarchy")
  elseif type(value) == "table" then
    if value.Icon ~= nil then
      assert_icon(value.Icon, where .. ".Icon")
    end
    if value.Actions ~= nil then
      local count = 0
      for action, command in pairs(value.Actions) do
        count = count + 1
        assert(type(action) == "string" and type(command) == "string" and command ~= "",
          where .. " has an invalid action")
      end
      assert(count > 0, where .. " has no actions")
    end
    for key, child in pairs(value) do
      inspect_value(child, where .. "." .. tostring(key))
    end
  end
end

local function assert_menu_references(value, where, names)
  if type(value) == "string" then
    for reference in value:gmatch("menus:([%w_-]+)") do
      assert(names[reference], where .. " references missing menu " .. reference)
    end
  elseif type(value) == "table" then
    for key, child in pairs(value) do
      assert_menu_references(child, where .. "." .. tostring(key), names)
    end
  end
end

local function assert_entries(provider, entries)
  assert(type(entries) == "table", provider.Name .. " did not return entries")
  for index, entry in ipairs(entries) do
    assert(type(entry) == "table", provider.Name .. " has an invalid entry")
    assert_icon(entry.Icon, provider.Name .. " entry " .. index)
    assert(type(entry.Actions) == "table" and next(entry.Actions),
      provider.Name .. " entry " .. index .. " has no actions")
    inspect_value(entry, provider.Name .. " entry " .. index)
  end
end

local function empty_popen()
  return stream("")
end

local providers = {}
local provider_names_by_name = {}
local home = "/home/test/.pi/agent/tmp/menu home/o'ne/$(literal)"
for _, name in ipairs(provider_names) do
  local provider = load_provider(name, home, empty_popen)
  assert(type(provider.Name) == "string", name .. " has no Name")
  assert(not provider_names_by_name[provider.Name], "duplicate provider Name: " .. provider.Name)
  provider_names_by_name[provider.Name] = true
  providers[#providers + 1] = provider
  assert_icon(provider.Icon, provider.Name .. ".Icon")
  assert_entries(provider, provider.GetEntries())
  inspect_value(provider, provider.Name)
  assert(not provider.Parent or provider_names_by_name[provider.Parent] or provider.Parent == "menu",
    provider.Name .. " has an invalid Parent")
end
for _, provider in ipairs(providers) do
  if provider.Parent then
    assert(provider_names_by_name[provider.Parent], provider.Name .. " has an invalid Parent")
  end
  assert_menu_references(provider.GetEntries(), provider.Name, provider_names_by_name)
end
print("PASS: 22 providers have unique names, valid links, actions, and icons")

local install_ai
for _, provider in ipairs(providers) do
  if provider.Name == "install-ai" then
    install_ai = provider
  end
end
local ai_actions = {}
for _, entry in ipairs(install_ai.GetEntries()) do
  ai_actions[entry.Text] = entry.Actions.install
end
assert(ai_actions["Cursor CLI"]:find("yay -S --noconfirm cursor-cli", 1, true), "Cursor CLI backend is incorrect")
assert(ai_actions["LM Studio"]:find("yay -S --noconfirm lmstudio-bin", 1, true), "LM Studio backend is incorrect")
assert(ai_actions.Crush:find("yay -S --noconfirm crush-bin", 1, true), "Crush backend is incorrect")
for command, package in pairs({ ["nvidia-smi"] = "ollama-cuda", rocminfo = "ollama-rocm", none = "ollama" }) do
  local provider = load_provider("install-ai", home, function(query)
    return stream(query:find("command -v " .. command .. " ", 1, true) and "/usr/bin/mock" or "")
  end)
  for _, entry in ipairs(provider.GetEntries()) do
    if entry.Text == "Ollama" then
      assert(entry.Actions.install:find(package .. '"', 1, true), "Ollama GPU selection regressed")
    end
  end
end
print("PASS: AI provider uses the requested repository/AUR packages")

local theme_root = home .. "/.config/hypr/themes"
local theme_paths = {
  theme_root .. "/space theme",
  theme_root .. "/o'ne $(theme)",
  theme_root .. "/plain",
}
local theme_preview = theme_paths[1] .. "/preview.png"
local theme_background = theme_paths[3] .. "/backgrounds/bg.jpeg"
local theme_calls = {}
local theme_outputs = {
  "space theme",
  "space theme\no'ne $(theme)\nplain",
  theme_preview,
  "",
  "",
  "",
  theme_background,
}
local function theme_popen(command)
  theme_calls[#theme_calls + 1] = command
  return stream(theme_outputs[#theme_calls] or "")
end
local themes = load_provider("dynamic/themes", home, theme_popen)
local theme_entries = themes.GetEntries()
assert_entries(themes, theme_entries)
assert(#theme_entries == 3, "themes must include entries without previews")
assert(theme_entries[1].state and theme_entries[1].state[1] == "current", "current theme not marked")
assert(theme_entries[1].Preview == theme_preview and theme_entries[1].PreviewType == "file",
  "theme preview missing")
assert(theme_entries[2].Preview == nil and theme_entries[2].PreviewType == nil,
  "theme without preview has preview metadata")
assert(theme_entries[2].Actions.activate == "theme-set " .. shell_quote("o'ne $(theme)"),
  "theme name was not shell-quoted")
assert(theme_calls[1]:find("readlink -- " .. shell_quote(theme_root .. "/current/theme"), 1, true),
  "theme current path was not quoted")
assert(theme_calls[2] == shell_quote(home .. "/.config/hypr/bin/theme-set") .. " --list",
  "theme menu must use the switcher's quoted --list command")
print("PASS: themes handle current state, missing previews, and shell-special names")

local font_name = "Font ' One $()"
local font_calls = 0
local function font_popen()
  font_calls = font_calls + 1
  return stream(font_calls == 1 and font_name or font_name .. "\nOther Font")
end
local fonts = load_provider("dynamic/fonts", home, font_popen)
local font_entries = fonts.GetEntries()
assert_entries(fonts, font_entries)
assert(#font_entries == 2 and font_entries[1].Value == font_name, "font values were not preserved")
assert(font_entries[1].state and font_entries[1].state[1] == "current", "current font not marked")
assert(font_entries[1].Actions.activate == "font-set " .. shell_quote(font_name),
  "font name was not shell-quoted")
local empty_fonts = load_provider("dynamic/fonts", home, empty_popen).GetEntries()
assert(#empty_fonts == 0, "empty font list must return no entries")
print("PASS: fonts use per-entry quoted actions and empty lists stay empty")

local backgrounds_dir = home .. "/.config/hypr/themes/current/theme/backgrounds"
local background_paths = {
  backgrounds_dir .. "/wall paper.png",
  backgrounds_dir .. "/o'ne/$.jpg",
}
local wallpaper_calls = {}
local function wallpaper_popen(command)
  wallpaper_calls[#wallpaper_calls + 1] = command
  return stream(#wallpaper_calls == 1
    and background_paths[2]
    or table.concat(background_paths, "\n"))
end
local wallpapers = load_provider("dynamic/wallpapers", home, wallpaper_popen)
local wallpaper_entries = wallpapers.GetEntries()
assert_entries(wallpapers, wallpaper_entries)
assert(#wallpaper_entries == 2, "wallpapers did not preserve all paths")
assert(wallpaper_entries[2].state and wallpaper_entries[2].state[1] == "current",
  "current wallpaper not marked")
assert(wallpaper_entries[2].Preview == background_paths[2], "wallpaper preview missing")
assert(wallpaper_entries[2].Actions.activate == "theme-bg-set " .. shell_quote(background_paths[2]),
  "wallpaper path was not shell-quoted")
assert(wallpaper_calls[1]:find("readlink -- " .. shell_quote(home .. "/.config/hypr/themes/current/background"), 1, true),
  "wallpaper current path was not quoted")
assert(wallpaper_calls[2]:find(shell_quote(backgrounds_dir), 1, true), "background directory was not quoted")
local empty_wallpapers = load_provider("dynamic/wallpapers", home, empty_popen).GetEntries()
assert(#empty_wallpapers == 0, "empty wallpaper list must return no entries")
print("PASS: wallpapers preserve current state, previews, and quoted paths")

local recording = load_provider("dynamic/screenrecord", home, function()
  return stream("1234")
end).GetEntries()
assert(#recording == 1 and recording[1].Icon == "media-playback-stop"
  and recording[1].Actions.activate == "cmd-screenrecord --stop-recording",
  "recording state must expose only stop")
local not_recording = load_provider("dynamic/screenrecord", home, empty_popen).GetEntries()
assert(#not_recording == 4 and not_recording[1].Icon == "camera-photo",
  "idle recording menu is incomplete")
print("PASS: recording detection exposes safe stop/start entries")
print("PASS: no menu actions or real shell commands were executed")

--
-- Dynamic Theme Menu for Elephant/Walker
--
Name = "themes"
NamePretty = "Themes"
HideFromProviderlist = true
Cache = false
Parent = "style"
Icon = "preferences-desktop-theme"

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

-- The main function elephant will call
function GetEntries()
  local entries = {}
  local theme_dir = os.getenv("HOME") .. "/.config/hypr/themes"

  -- Currently active theme (basename of the current/theme symlink)
  local current_theme = ""
  local current_handle = io.popen(
    "readlink -- " .. shell_quote(theme_dir .. "/current/theme") .. " 2>/dev/null"
  )
  if current_handle then
    current_theme = current_handle:read("*l") or ""
    current_theme = current_theme:match("([^/]+)$") or current_theme
    current_handle:close()
  end

  -- Use the switcher's validation rules for the list as well.
  local list_cmd = shell_quote(os.getenv("HOME") .. "/.config/hypr/bin/theme-set") .. " --list"

  local handle = io.popen(list_cmd)
  if not handle then
    return entries
  end

  for theme_name in handle:lines() do
    local theme_path = theme_dir .. "/" .. theme_name

    if theme_name ~= "" then
      -- find preview image
      local find_preview_cmd = "find -L -- "
        .. shell_quote(theme_path)
        .. " -maxdepth 1 -type f \\( -name 'preview.png' -o -name 'preview.jpg' \\) 2>/dev/null | head -n 1"
      local preview_handle = io.popen(find_preview_cmd)
      local preview_path = nil

      if preview_handle then
        preview_path = preview_handle:read("*l")
        preview_handle:close()
      end

      -- If no preview found, use first image from backgrounds folder
      if not preview_path or preview_path == "" then
        local bg_cmd = "find -L -- "
          .. shell_quote(theme_path .. "/backgrounds")
          .. " -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \\) 2>/dev/null | head -n 1"
        local bg_handle = io.popen(bg_cmd)
        if bg_handle then
          preview_path = bg_handle:read("*l")
          bg_handle:close()
        end
      end

      local is_current = (theme_name == current_theme)
      local display_name = theme_name:gsub("_", " "):gsub("%-", " ")
      display_name = display_name:gsub("(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
      end)
      display_name = (is_current and "* " or "") .. display_name .. "  "

      local entry = {
        Text = display_name,
        Icon = "preferences-desktop-theme",
        state = is_current and { "current" } or nil,
        Actions = {
          activate = "theme-set " .. shell_quote(theme_name),
        },
      }
      if preview_path and preview_path ~= "" then
        entry.Preview = preview_path
        entry.PreviewType = "file"
      end
      table.insert(entries, entry)
    end
  end

  handle:close()
  return entries
end

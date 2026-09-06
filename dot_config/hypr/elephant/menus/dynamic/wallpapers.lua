--
-- Dynamic Wallpaper Menu for Elephant/Walker
-- Lists the backgrounds of the current theme with image previews.
-- Selection is applied by theme-bg-set (same mechanism as theme-bg-next).
--
Name = "wallpapers"
NamePretty = "Wallpapers"
HideFromProviderlist = true
Cache = false
Parent = "style"
Icon = "preferences-desktop-wallpaper"

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

function GetEntries()
  local entries = {}
  local home = os.getenv("HOME")
  local backgrounds_dir = home .. "/.config/hypr/themes/current/theme/backgrounds"
  local current_link = home .. "/.config/hypr/themes/current/background"

  local current_bg = ""
  local current_handle = io.popen("readlink -- " .. shell_quote(current_link) .. " 2>/dev/null")
  if current_handle then
    current_bg = current_handle:read("*l") or ""
    current_handle:close()
  end

  local handle = io.popen(
    "find -L -- "
      .. shell_quote(backgrounds_dir)
      .. " -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) 2>/dev/null | sort"
  )
  if not handle then
    return entries
  end

  for path in handle:lines() do
    local name = path:match(".*/(.+)$")
    if name then
      local is_current = (path == current_bg)
      table.insert(entries, {
        Text = (is_current and "* " or "") .. name,
        Icon = "preferences-desktop-wallpaper",
        Value = path,
        Preview = path,
        PreviewType = "file",
        state = is_current and { "current" } or nil,
        Actions = { activate = "theme-bg-set " .. shell_quote(path) },
      })
    end
  end

  handle:close()

  return entries
end

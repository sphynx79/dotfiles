--
-- Dynamic Font Menu for Elephant/Walker
--
Name = "fonts"
NamePretty = "Fonts"
HideFromProviderlist = true
Cache = false
Parent = "style"
Icon = "preferences-desktop-font"

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

function GetEntries()
  local entries = {}

  local current_font = ""
  local current_handle = io.popen("font-current 2>/dev/null")
  if current_handle then
    current_font = current_handle:read("*l") or ""
    current_handle:close()
  end

  local handle = io.popen("font-list 2>/dev/null")
  if not handle then
    return entries
  end

  for font_name in handle:lines() do
    if font_name ~= "" then
      local is_current = (font_name == current_font)
      table.insert(entries, {
        Text = (is_current and "* " or "") .. font_name,
        Icon = "preferences-desktop-font",
        Value = font_name,
        state = is_current and { "current" } or nil,
        Actions = { activate = "font-set " .. shell_quote(font_name) },
      })
    end
  end

  handle:close()

  return entries
end

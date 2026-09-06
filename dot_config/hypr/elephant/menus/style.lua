Name = "style"
NamePretty = "Style"
FixedOrder = true
HideFromProviderlist = true
Icon = "preferences-desktop-theme"
Parent = "menu"

function GetEntries()
  local home = os.getenv("HOME")
  return {
    { Text = "Theme",           Icon = "preferences-desktop-theme",       Actions = { open = "walker -t menus -m menus:themes -N" } },
    { Text = "Font",            Icon = "preferences-desktop-font",        Actions = { open = "walker -t menus -m menus:fonts -N" } },
    { Text = "Wallpaper",       Icon = "preferences-desktop-wallpaper",   Actions = { open = "walker -t menus -m menus:wallpapers -N" } },
    { Text = "Next background", Icon = "preferences-desktop-wallpaper",   Actions = { activate = "theme-bg-next" } },
    { Text = "Hyprland",        Icon = "text-x-generic",                  Actions = { activate = "launch-editor " .. home .. "/.config/hypr/hyprland.lua" } },
    { Text = "Edit screensaver text", Icon = "preferences-desktop-screensaver", Actions = { activate = "launch-editor " .. home .. "/.config/hypr/screensaver.txt" } },
  }
end

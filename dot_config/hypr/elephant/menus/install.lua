Name = "install"
NamePretty = "Install"
FixedOrder = true
HideFromProviderlist = true
Icon = "system-software-install"
Parent = "menu"

function GetEntries()
  local home = os.getenv("HOME")
  return {
    { Text = "Package",     Icon = "system-software-install",     Actions = { activate = "xdg-terminal-exec --app-id=org.hyprarch.terminal -e pkg-install" } },
    { Text = "AUR",         Icon = "system-software-install",     Actions = { activate = "xdg-terminal-exec --app-id=org.hyprarch.terminal -e pkg-aur-install" } },
    { Text = "Web App",     Icon = "web-browser",                 Actions = { activate = "launch-floating-terminal-with-presentation webapp-install" } },
    { Text = "TUI",         Icon = "utilities-terminal",          Actions = { activate = "launch-floating-terminal-with-presentation tui-install" } },
    { Text = "Editor",      Icon = "text-x-generic",              Actions = { open = "walker -t menus -m menus:install-editor -N" } },
    { Text = "Terminal",    Icon = "utilities-terminal",          Actions = { open = "walker -t menus -m menus:install-terminal -N" } },
    { Text = "AI",          Icon = "utilities-terminal",          Actions = { open = "walker -t menus -m menus:install-ai -N" } },
    { Text = "Gaming",      Icon = "applications-games",          Actions = { open = "walker -t menus -m menus:install-gaming -N" } },
    { Text = "Install font", Icon = "preferences-desktop-font",    Actions = { open = "walker -t menus -m menus:install-font -N" } },
    { Text = "Backgrounds", Icon = "preferences-desktop-wallpaper", Actions = { activate = "dolphin " .. home .. "/.config/hypr/themes/current/theme/backgrounds" } },
  }
end

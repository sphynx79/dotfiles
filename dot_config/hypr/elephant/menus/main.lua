Name = "menu"
NamePretty = "Go"
FixedOrder = true
HideFromProviderlist = true
Icon = "applications-system"

function GetEntries()
  return {
    { Text = "Apps",    Icon = "applications-system",      Actions = { open = "launch-menu-apps" } },
    { Text = "Learn",   Icon = "help-contents",            Actions = { open = "walker -t menus -m menus:learn -N" } },
    { Text = "Capture", Icon = "camera-photo",              Actions = { open = "walker -t menus -m menus:capture -N" } },
    { Text = "Share",   Icon = "folder",                   Actions = { open = "walker -t menus -m menus:share -N" } },
    { Text = "Style",   Icon = "preferences-desktop-theme", Actions = { open = "walker -t menus -m menus:style -N" } },
    { Text = "Setup",   Icon = "preferences-system",        Actions = { open = "walker -t menus -m menus:setup -N" } },
    { Text = "Install", Icon = "system-software-install",   Actions = { open = "walker -t menus -m menus:install -N" } },
    { Text = "Remove",  Icon = "user-trash",                Actions = { open = "walker -t menus -m menus:remove -N" } },
    { Text = "Update",  Icon = "system-software-update",    Actions = { open = "walker -t menus -m menus:update -N" } },
    { Text = "About",   Icon = "help-about",                Actions = { activate = "launch-floating-terminal-with-presentation fastfetch" } },
    { Text = "System",  Icon = "applications-system",      Actions = { open = "walker -t menus -m menus:system -N" } },
  }
end

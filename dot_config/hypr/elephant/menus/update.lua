Name = "update"
NamePretty = "Update"
FixedOrder = true
HideFromProviderlist = true
Icon = "system-software-update"
Parent = "menu"

function GetEntries()
  return {
    { Text = "System packages", Icon = "system-software-update", Actions = { activate = "launch-floating-terminal-with-presentation 'yay -Syu'" } },
    { Text = "Restart",         Icon = "system-reboot",           Actions = { open = "walker -t menus -m menus:update-restart -N" } },
  }
end

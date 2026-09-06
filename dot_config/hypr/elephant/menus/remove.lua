Name = "remove"
NamePretty = "Remove"
FixedOrder = true
HideFromProviderlist = true
Icon = "user-trash"
Parent = "menu"

function GetEntries()
  return {
    { Text = "Remove package", Icon = "system-software-install", Actions = { activate = "xdg-terminal-exec --app-id=org.hyprarch.terminal -e pkg-remove" } },
    { Text = "Remove web app", Icon = "web-browser",             Actions = { activate = "launch-floating-terminal-with-presentation webapp-remove" } },
  }
end

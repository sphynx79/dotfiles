Name = "share"
NamePretty = "Share"
FixedOrder = true
HideFromProviderlist = true
Icon = "folder"
Parent = "menu"

function GetEntries()
  return {
    { Text = "Clipboard", Icon = "edit-paste", Actions = { activate = "cmd-share clipboard" } },
    { Text = "File",      Icon = "folder",     Actions = { activate = "xdg-terminal-exec --app-id=org.hyprarch.terminal -e bash -c 'cmd-share file'" } },
    { Text = "Folder",    Icon = "folder",     Actions = { activate = "xdg-terminal-exec --app-id=org.hyprarch.terminal -e bash -c 'cmd-share folder'" } },
  }
end

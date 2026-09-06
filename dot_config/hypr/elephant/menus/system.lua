Name = "system"
NamePretty = "System"
FixedOrder = true
HideFromProviderlist = true
Icon = "applications-system"
Parent = "menu"

function GetEntries()
  return {
    { Text = "Lock",        Icon = "system-lock-screen",          Actions = { activate = "lock-screen" } },
    { Text = "Suspend",     Icon = "system-suspend",              Actions = { activate = "cmd-suspend" } },
    { Text = "Screensaver", Icon = "preferences-desktop-screensaver", Actions = { activate = "launch-screensaver force" } },
    { Text = "Reboot",      Icon = "system-reboot",               Actions = { activate = "cmd-reboot" } },
    { Text = "Shutdown",    Icon = "system-shutdown",             Actions = { activate = "cmd-shutdown" } },
  }
end

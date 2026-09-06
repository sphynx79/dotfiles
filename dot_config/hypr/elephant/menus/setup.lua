Name = "setup"
NamePretty = "Setup"
FixedOrder = true
HideFromProviderlist = true
Icon = "preferences-system"
Parent = "menu"

function GetEntries()
  local home = os.getenv("HOME")
  return {
    { Text = "Audio",     Icon = "audio-volume-high", Actions = { activate = "pavucontrol" } },
    { Text = "Wifi",      Icon = "network-wireless",  Actions = { activate = "launch-tui nmtui" } },
    { Text = "Bluetooth", Icon = "bluetooth",         Actions = { activate = "blueman-manager" } },
    { Text = "Defaults",  Icon = "preferences-system", Actions = { activate = "launch-editor " .. home .. "/.config/uwsm/env" } },
    { Text = "Config",    Icon = "text-x-generic",    Actions = { open = "walker -t menus -m menus:setup-config -N" } },
  }
end

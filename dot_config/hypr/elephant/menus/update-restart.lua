Name = "update-restart"
NamePretty = "Restart"
FixedOrder = true
HideFromProviderlist = true
Icon = "system-reboot"
Parent = "update"

function GetEntries()
  return {
    { Text = "Restart Walker",    Icon = "utilities-system-monitor", Actions = { activate = "restart-walker" } },
    { Text = "Restart Waybar",    Icon = "utilities-system-monitor", Actions = { activate = "reload-app waybar" } },
    { Text = "Restart Hypridle",  Icon = "preferences-desktop-screensaver", Actions = { activate = "pkill -x hypridle; setsid app2unit.sh -t service hypridle" } },
    { Text = "Restart audio",     Icon = "audio-volume-high",       Actions = { activate = "systemctl --user restart wireplumber pipewire pipewire-pulse" } },
    { Text = "Restart Wi-Fi",     Icon = "network-wireless",        Actions = { activate = "launch-floating-terminal-with-presentation 'sudo systemctl restart NetworkManager'" } },
    { Text = "Restart Bluetooth", Icon = "bluetooth",               Actions = { activate = "bluetoothctl power off && sleep 1 && bluetoothctl power on" } },
  }
end

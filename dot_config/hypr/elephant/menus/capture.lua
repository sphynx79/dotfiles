Name = "capture"
NamePretty = "Capture"
FixedOrder = true
HideFromProviderlist = true
Icon = "camera-photo"
Parent = "menu"

function GetEntries()
  return {
    { Text = "Screenshot",   Icon = "camera-photo",        Actions = { open = "walker -t menus -m menus:screenshot -N" } },
    { Text = "Screenrecord", Icon = "media-playback-stop", Actions = { open = "walker -t menus -m menus:screenrecord -N" } },
    { Text = "Color",        Icon = "color-picker",        Actions = { activate = "pkill hyprpicker || hyprpicker -a" } },
  }
end

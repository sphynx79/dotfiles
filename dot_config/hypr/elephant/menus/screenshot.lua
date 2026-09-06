Name = "screenshot"
NamePretty = "Screenshot"
FixedOrder = true
HideFromProviderlist = true
Icon = "camera-photo"
Parent = "capture"

function GetEntries()
  return {
    { Text = "Area (Edit)",               Icon = "camera-photo", Actions = { activate = "cmd-screenshot s" } },
    { Text = "Area + Freeze (Edit)",      Icon = "camera-photo", Actions = { activate = "cmd-screenshot sf" } },
    { Text = "Area + Freeze (Save Only)", Icon = "camera-photo", Actions = { activate = "cmd-screenshot sn" } },
    { Text = "Current Monitor",           Icon = "camera-photo", Actions = { activate = "cmd-screenshot m" } },
    { Text = "All Monitors",              Icon = "camera-photo", Actions = { activate = "cmd-screenshot p" } },
    { Text = "OCR (Text to Clipboard)",   Icon = "camera-photo", Actions = { activate = "cmd-screenshot sc" } },
  }
end

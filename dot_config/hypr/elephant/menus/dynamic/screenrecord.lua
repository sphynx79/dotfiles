--
-- Dynamic Screenrecord Menu for Elephant/Walker
-- Shows only "Stop recording" while gpu-screen-recorder is running.
--
Name = "screenrecord"
NamePretty = "Screenrecord"
FixedOrder = true
HideFromProviderlist = true
Icon = "camera-photo"
Cache = false
Parent = "capture"

local function is_recording()
  local handle = io.popen("pgrep -f '^gpu-screen-recorder' 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*l")
  handle:close()
  return result ~= nil and result ~= ""
end

function GetEntries()
  if is_recording() then
    return {
      { Text = "Stop recording", Icon = "media-playback-stop", Actions = { activate = "cmd-screenrecord --stop-recording" } },
    }
  end

  return {
    { Text = "Video only",                                Icon = "camera-photo", Actions = { activate = "cmd-screenrecord" } },
    { Text = "With desktop audio",                        Icon = "camera-photo", Actions = { activate = "cmd-screenrecord --with-desktop-audio" } },
    { Text = "With desktop + microphone audio",           Icon = "camera-photo", Actions = { activate = "cmd-screenrecord --with-desktop-audio --with-microphone-audio" } },
    { Text = "With desktop + microphone audio + webcam",  Icon = "camera-photo", Actions = { activate = "cmd-screenrecord --with-desktop-audio --with-microphone-audio --with-webcam" } },
  }
end

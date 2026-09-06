Name = "setup-config"
NamePretty = "Config"
FixedOrder = true
HideFromProviderlist = true
Icon = "text-x-generic"
Parent = "setup"

function GetEntries()
  local home = os.getenv("HOME")
  return {
    { Text = "Hyprland", Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.config/hypr/hyprland.lua" } },
    { Text = "Hypridle", Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.config/hypr/hypridle.conf" } },
    { Text = "Hyprlock", Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.config/hypr/hyprlock.conf" } },
    { Text = "Walker",   Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.config/walker/config.toml" } },
    { Text = "Waybar",   Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.config/waybar/config.jsonc" } },
    { Text = "XCompose", Icon = "text-x-generic", Actions = { activate = "launch-editor " .. home .. "/.XCompose" } },
  }
end

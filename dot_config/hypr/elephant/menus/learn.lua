Name = "learn"
NamePretty = "Learn"
FixedOrder = true
HideFromProviderlist = true
Icon = "help-contents"
Parent = "menu"

function GetEntries()
  return {
    { Text = "Keybindings", Icon = "help-contents", Actions = { activate = "keybinds_walker" } },
    { Text = "Hyprland",    Icon = "help-contents", Actions = { activate = "launch-webapp 'https://wiki.hypr.land/'" } },
    { Text = "Arch",        Icon = "help-contents", Actions = { activate = "launch-webapp 'https://wiki.archlinux.org/title/Main_page'" } },
    { Text = "Neovim",      Icon = "help-contents", Actions = { activate = "launch-webapp 'https://www.lazyvim.org/keymaps'" } },
    { Text = "Bash",        Icon = "help-contents", Actions = { activate = "launch-webapp 'https://devhints.io/bash'" } },
  }
end

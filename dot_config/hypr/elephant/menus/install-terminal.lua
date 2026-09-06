Name = "install-terminal"
NamePretty = "Install Terminal"
FixedOrder = true
HideFromProviderlist = true
Icon = "utilities-terminal"
Parent = "install"

local function repo(name, pkg)
  return "launch-floating-terminal-with-presentation \"echo 'Installing " .. name .. "...'; sudo pacman -S --noconfirm " .. pkg .. "\""
end

function GetEntries()
  return {
    { Text = "Alacritty", Icon = "utilities-terminal", Actions = { install = repo("Alacritty", "alacritty") } },
    { Text = "Ghostty",   Icon = "utilities-terminal", Actions = { install = repo("Ghostty", "ghostty") } },
    { Text = "Kitty",     Icon = "utilities-terminal", Actions = { install = repo("Kitty", "kitty") } },
  }
end

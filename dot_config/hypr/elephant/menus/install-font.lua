Name = "install-font"
NamePretty = "Install Font"
FixedOrder = true
HideFromProviderlist = true
Icon = "preferences-desktop-font"
Parent = "install"

local function font(name, pkg, family)
  return "launch-floating-terminal-with-presentation \"echo 'Installing " .. name .. "...'; sudo pacman -S --noconfirm --needed " .. pkg .. " && sleep 2 && font-set '" .. family .. "'\""
end

function GetEntries()
  return {
    { Text = "Meslo LG Mono",       Icon = "preferences-desktop-font", Actions = { install = font("Meslo LG Mono", "ttf-meslo-nerd", "MesloLGL Nerd Font") } },
    { Text = "Fira Code",           Icon = "preferences-desktop-font", Actions = { install = font("Fira Code", "ttf-firacode-nerd", "FiraCode Nerd Font") } },
    { Text = "Victor Code",         Icon = "preferences-desktop-font", Actions = { install = font("Victor Code", "ttf-victor-mono-nerd", "VictorMono Nerd Font") } },
    { Text = "Bistream Vera Mono",  Icon = "preferences-desktop-font", Actions = { install = font("Bistream Vera Code", "ttf-bitstream-vera-mono-nerd", "BitstromWera Nerd Font") } },
    { Text = "Iosevka",             Icon = "preferences-desktop-font", Actions = { install = font("Iosevka", "ttf-iosevka-nerd", "Iosevka Nerd Font Mono") } },
  }
end

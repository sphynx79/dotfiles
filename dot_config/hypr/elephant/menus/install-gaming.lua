Name = "install-gaming"
NamePretty = "Install Gaming"
FixedOrder = true
HideFromProviderlist = true
Icon = "applications-games"
Parent = "install"

function GetEntries()
  return {
    { Text = "Steam",     Icon = "applications-games", Actions = { install = "launch-floating-terminal-with-presentation \"echo 'Installing Steam...'; sudo pacman -S --noconfirm steam\"" } },
    { Text = "RetroArch", Icon = "applications-games", Actions = { install = "launch-floating-terminal-with-presentation \"echo 'Installing RetroArch from AUR...'; yay -S --noconfirm retroarch retroarch-assets libretro libretro-fbneo && setsid gtk-launch com.libretro.RetroArch.desktop\"" } },
    { Text = "Minecraft", Icon = "applications-games", Actions = { install = "launch-floating-terminal-with-presentation \"echo 'Installing Minecraft from AUR...'; yay -S --noconfirm minecraft-launcher && setsid gtk-launch minecraft-launcher\"" } },
  }
end

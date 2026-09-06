Name = "install-editor"
NamePretty = "Install Editor"
FixedOrder = true
HideFromProviderlist = true
Icon = "text-x-generic"
Parent = "install"

local function aur(name, pkg, launch)
  local cmd = "echo 'Installing " .. name .. "...'; yay -S --noconfirm " .. pkg
  if launch then
    cmd = cmd .. " && setsid gtk-launch " .. launch
  end
  return "launch-floating-terminal-with-presentation \"" .. cmd .. "\""
end

local function repo(name, pkg, after)
  local cmd = "echo 'Installing " .. name .. "...'; sudo pacman -S --noconfirm " .. pkg
  if after then
    cmd = cmd .. " && " .. after
  end
  return "launch-floating-terminal-with-presentation \"" .. cmd .. "\""
end

function GetEntries()
  return {
    { Text = "VSCode",       Icon = "visual-studio-code", Actions = { install = aur("VSCode", "visual-studio-code-bin") } },
    { Text = "Cursor",       Icon = "cursor",            Actions = { install = aur("Cursor", "cursor-bin", "cursor") } },
    { Text = "Zed",          Icon = "dev.zed.Zed",       Actions = { install = repo("Zed", "zed", "setsid gtk-launch dev.zed.Zed") } },
    { Text = "Sublime Text", Icon = "sublime_text",      Actions = { install = aur("Sublime Text", "sublime-text-4", "sublime_text") } },
    { Text = "Helix",        Icon = "helix",             Actions = { install = repo("Helix", "helix") } },
    { Text = "Emacs",        Icon = "emacs",             Actions = { install = repo("Emacs", "emacs-wayland", "systemctl --user enable --now emacs.service") } },
  }
end

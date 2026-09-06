Name = "install-ai"
NamePretty = "Install AI"
FixedOrder = true
HideFromProviderlist = true
Icon = "utilities-terminal"
Parent = "install"

local function repo(name, pkg, manager)
  manager = manager or "sudo pacman"
  return "launch-floating-terminal-with-presentation \"echo 'Installing " .. name .. "...'; " .. manager .. " -S --noconfirm " .. pkg .. "\""
end

local function has_cmd(cmd)
  local handle = io.popen("command -v " .. cmd .. " 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*l")
  handle:close()
  return result ~= nil and result ~= ""
end

function GetEntries()
  local ollama_pkg = "ollama"
  if has_cmd("nvidia-smi") then
    ollama_pkg = "ollama-cuda"
  elseif has_cmd("rocminfo") then
    ollama_pkg = "ollama-rocm"
  end

  return {
    { Text = "Claude Code",  Icon = "utilities-terminal", Actions = { install = repo("Claude Code", "claude-code") } },
    { Text = "Cursor CLI",   Icon = "utilities-terminal", Actions = { install = repo("Cursor CLI", "cursor-cli", "yay") } },
    { Text = "Gemini",       Icon = "utilities-terminal", Actions = { install = repo("Gemini", "gemini-cli") } },
    { Text = "OpenAI Codex", Icon = "utilities-terminal", Actions = { install = "launch-floating-terminal-with-presentation \"echo 'Installing OpenAI Codex...'; yay -S --noconfirm openai-codex-bin\"" } },
    { Text = "LM Studio",    Icon = "utilities-terminal", Actions = { install = repo("LM Studio", "lmstudio-bin", "yay") } },
    { Text = "Ollama",       Icon = "utilities-terminal", Actions = { install = repo("Ollama", ollama_pkg) } },
    { Text = "Crush",        Icon = "utilities-terminal", Actions = { install = repo("Crush", "crush-bin", "yay") } },
    { Text = "opencode",     Icon = "utilities-terminal", Actions = { install = repo("opencode", "opencode") } },
  }
end

-- Run from ~/.config/hypr: lua tests/gtk-theme-startup.lua
-- Only evaluate startup registration; never execute shell commands or load plugins.
print("START: GTK theme startup/reload regression test")
local file = assert(io.open("hyprland.lua"))
local source = file:read("*a")
file:close()
local prefix = assert(source:match("^(.-)%-%- GENERAL %{%{%{"))
local commands, events = {}, {}
local config = assert(load(prefix, "@hyprland.lua", "t", {
    os = { getenv = os.getenv },
    hl = {
        env = function() end,
        exec_cmd = function(command) commands[#commands + 1] = command end,
        on = function(event, callback) events[event] = callback end,
    },
}))

for _ = 1, 2 do
    commands, events = {}, {}
    config()
    for _, command in ipairs(commands) do
        assert(not command:find("dconf", 1, true), "Reload must not write or reset dconf")
        assert(not command:find("gsettings", 1, true), "Reload must not write GTK preferences")
        assert(not command:find("theme-set-gnome", 1, true), "Theme application must be startup-only")
    end
end
print("PASS: initial evaluation and reload do not overwrite GTK preferences")

commands = {}
assert(events["hyprland.start"], "Missing startup callback")()
local startup = table.concat(commands, "\n")
local _, theme_calls = startup:gsub("theme%-set%-gnome", "")
assert(theme_calls == 1, "Startup must apply the selected theme exactly once")
assert(not startup:find("dconf", 1, true), "Startup must not reset/load the global dconf database")
for _, setting in ipairs({
    "org.gnome.desktop.interface cursor-size 24",
    'org.gnome.desktop.interface font-name "Cantarell 10"',
    'org.gnome.desktop.interface document-font-name "Cantarell 10"',
    'org.gnome.desktop.interface monospace-font-name "CaskaydiaCove Nerd Font Mono 9"',
    "org.gnome.desktop.interface font-antialiasing rgba",
    "org.gnome.desktop.interface font-hinting slight",
    "org.gnome.desktop.default-applications.terminal exec kitty",
    'org.gnome.desktop.wm.preferences button-layout "\'\'"',
}) do
    assert(startup:find("gsettings set " .. setting, 1, true), "Lost fixed preference: " .. setting)
end
for _, key in ipairs({ "gtk-theme", "icon-theme", "color-scheme" }) do
    assert(not startup:find("gsettings set org.gnome.desktop.interface " .. key, 1, true),
        "Theme values must come from theme-set-gnome: " .. key)
end
print("PASS: startup applies current theme and preserves fixed preferences")
print("PASS: no real settings or applications changed")

# Run: kitty +runpy 'exec(open("tests/kitty-theme.py").read())'
from pathlib import Path

from kitty.colors import parse_colors
from kitty.config import load_config
from kitty.options.types import defaults

print("START: Kitty current-theme restore regression")
config = Path.home() / ".config/kitty/kitty.conf"
bad_lines = []
options = load_config(str(config), accumulate_bad_lines=bad_lines)
assert not bad_lines, bad_lines
actions = options.alias_map.resolve_aliases("restore_theme")
assert len(actions) == 1 and actions[0].func == "set_colors"
args = actions[0].args
assert args[:2] == ("--all", "--configured") and "--reset" not in args
colors, _ = parse_colors(args[2:])
for key, value in colors.items():
    configured = getattr(options, key)
    assert value == (int(configured) if configured is not None else None), key
prefs = config.with_name("userprefs.conf").read_text()
assert "set_colors --reset" not in prefs
assert "restore_theme" in prefs
print("PASS: native config parser and restore action match current configured colors")

themes = Path.home() / ".config/hypr/themes"
for theme in ("my-theme", "catppuccin", "catppuccin-latte", "everforest"):
    palette = str(themes / theme / "kitty.conf")
    theme_colors, _ = parse_colors((palette,))
    restored, _ = parse_colors((*args[2:-1], palette))
    for key in ("active_tab_background", "tab_bar_background"):
        default = getattr(defaults, key)
        expected = theme_colors.get(key, int(default) if default is not None else None)
        assert restored[key] == expected, (theme, key)
    assert all(restored[key] == value for key, value in theme_colors.items())
    print(f"PASS: {theme}: palette and modal highlight restore")
print("PASS: no running Kitty windows modified by this test")

#! /usr/bin/env python3
import importlib.util
import os
import subprocess
import sys
import tempfile
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
HINT = ROOT / "bin" / "keybinds.hint.py"
WRAPPER = ROOT / "bin" / "keybinds_walker"


def load_hint():
    spec = importlib.util.spec_from_file_location("keybinds_hint", HINT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_rendering():
    hint = load_hint()
    binds = [
        {
            "dispatcher": "submap",
            "arg": "native-group",
            "keycode": 0,
            "key": "n",
            "modmask": 64,
            "has_description": True,
            "description": "[Groups] enter native group",
        },
        {
            "dispatcher": "movefocus",
            "arg": "l",
            "submap": "native-group",
            "keycode": 0,
            "key": "l",
            "modmask": 0,
            "has_description": True,
            "description": "move right",
        },
        {
            "dispatcher": "__lua",
            "arg": "lua-root",
            "keycode": 0,
            "key": "r",
            "modmask": 0,
            "has_description": False,
        },
        {
            "dispatcher": "__lua",
            "arg": "lua-member",
            "submap": "lua-group",
            "keycode": 0,
            "key": "m",
            "modmask": 0,
            "has_description": False,
        },
        {
            "dispatcher": "exec",
            "arg": "undocumented",
            "keycode": 0,
            "key": "u",
            "modmask": 0,
            "has_description": False,
        },
        {
            "dispatcher": "__lua",
            "arg": "mouse-action",
            "keycode": 0,
            "key": "mouse:272",
            "modmask": 64,
            "mouse": True,
            "has_description": False,
        },
        {
            "dispatcher": "exec",
            "arg": "catch-all",
            "keycode": 0,
            "key": "c",
            "modmask": 0,
            "catchall": True,
            "has_description": True,
            "description": "catch-all",
        },
        {
            "dispatcher": "submap",
            "arg": "reset",
            "keycode": 0,
            "key": "escape",
            "modmask": 0,
            "has_description": True,
            "description": "reset",
        },
    ]

    hint.expand_meta_data(binds)
    rendered = hint.generate_rofi(binds)

    assert "SUPER + n + l" in rendered
    assert binds[1]["description"] == "[native-group] move right"
    assert "[native-group] move right" in rendered
    assert "[lua-group] Lua action (no description)" in rendered
    assert "u" in rendered and "execute undocumented" in rendered
    assert "SUPER + mouse:272" in rendered
    assert "catch-all" not in rendered
    assert "escape" not in rendered


def write_executable(path, content):
    path.write_text(content)
    path.chmod(0o755)


def test_wrapper_is_fresh_and_reports_errors():
    source = WRAPPER.read_text()
    assert "cache_file" not in source
    assert "keybinds_hint.rofi" not in source
    assert "2>/dev/null" not in source
    assert 'raw_output=$("$script_path" --format rofi) || exit "$?"' in source

    scratch = Path.home() / ".pi" / "agent" / "tmp"
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="keybinds-", dir=scratch) as directory:
        fixture = Path(directory)
        hint = fixture / ".config" / "hypr" / "bin" / "keybinds.hint.py"
        hint.parent.mkdir(parents=True)
        write_executable(
            hint,
            "#!/bin/sh\n"
            "if [ \"$KEYBIND_TEST_FAIL\" ]; then\n"
            "  printf '%s\\n' 'hint failed' >&2\n"
            "  exit 23\n"
            "fi\n"
            "printf '%s ::: action\\n' \"$KEYBIND_TEST_OUTPUT\"\n",
        )
        walker_dir = fixture / "bin"
        walker_dir.mkdir()
        write_executable(walker_dir / "walker", "#!/bin/sh\ncat\n")

        environment = os.environ | {
            "HOME": str(fixture),
            "PATH": f"{walker_dir}:{os.environ['PATH']}",
        }
        first = subprocess.run(
            [WRAPPER],
            env=environment | {"KEYBIND_TEST_OUTPUT": "first"},
            capture_output=True,
            text=True,
            check=True,
        )
        second = subprocess.run(
            [WRAPPER],
            env=environment | {"KEYBIND_TEST_OUTPUT": "second"},
            capture_output=True,
            text=True,
            check=True,
        )
        assert "first" in first.stdout
        assert "second" in second.stdout
        assert "first" not in second.stdout
        failed = subprocess.run(
            [WRAPPER],
            env=environment | {"KEYBIND_TEST_FAIL": "1"},
            capture_output=True,
            text=True,
            check=False,
        )
        assert failed.returncode == 23
        assert "hint failed" in failed.stderr


if __name__ == "__main__":
    print("START: keybindings regression tests")
    print("CHECKPOINT: Lua descriptions, submaps, mouse and catchall")
    test_rendering()
    print("CHECKPOINT: fresh wrapper data and errors, no real Walker launched")
    test_wrapper_is_fresh_and_reports_errors()
    print("PASS keybindings")

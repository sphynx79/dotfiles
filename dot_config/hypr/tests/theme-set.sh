#!/usr/bin/env bash
set -euo pipefail

script="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../bin" && pwd)/theme-set"
mkdir -p "$HOME/.pi/agent/tmp"
scratch="$(mktemp -d "$HOME/.pi/agent/tmp/theme-set-test.XXXXXX")"
exec > >(tee "$scratch/test.log") 2>&1
trap 'echo "FAIL: theme-set test (exit $?), log: $scratch/test.log"' ERR
echo "START: theme-set regression test, scratch: $scratch"

export HOME="$scratch/home"
export DEBUG=0
export CALL_LOG="$scratch/calls"
export FAIL_AT=""
themes="$HOME/.config/hypr/themes"
mkdir -p "$themes/current" "$HOME/.config/qt6ct" "$scratch/bin"
for theme in old new missing-qt missing-kvantum; do
	mkdir -p "$themes/$theme/kvantum"
	[[ "$theme" == missing-qt ]] || printf '[Appearance]\nstyle=kvantum\n' >"$themes/$theme/qt6ct.conf"
	[[ "$theme" == missing-kvantum ]] || printf '[General]\ntheme=%s\n' "$theme" >"$themes/$theme/kvantum/kvantum.kvconfig"
done
ln -s "$themes/old" "$themes/current/theme"
ln -s "$themes/current/theme/qt6ct.conf" "$HOME/.config/qt6ct/qt6ct.conf"
ln -s "$themes/current/theme/kvantum" "$HOME/.config/Kvantum"

cat >"$scratch/bin/stub" <<'EOF'
#!/usr/bin/env bash
entry="${0##*/} $*"
printf '%s\n' "$entry" >>"$CALL_LOG"
if [[ "$entry" == "$FAIL_AT" || "${FAIL_ALL:-0}" == 1 ]]; then
	exit 7
fi
if [[ "${0##*/}" == touch ]]; then
	exec /usr/bin/touch "$@"
fi
exit 0
EOF
chmod +x "$scratch/bin/stub"
for command in theme-bg-next reload-app restart-terminal hyprctl swaync-client \
	theme-set-gnome theme-set-obsidian theme-set-neovim restart-app touch notify-send; do
	ln -s stub "$scratch/bin/$command"
done
export PATH="$scratch/bin:$PATH"

echo "CHECK: shared list excludes containers and incomplete themes, not themes without previews"
mkdir -p "$themes/DA_MODIFICARE/backgrounds"
printf 'preview\n' >"$themes/missing-qt/preview.png"
[[ "$(bash "$script" --list)" == $'new\nold' ]]
if bash "$script" >"$scratch/usage" 2>&1; then
	echo "FAIL: missing theme argument accepted"
	exit 1
fi
grep -qx '  - new' "$scratch/usage"
grep -qx '  - old' "$scratch/usage"
if grep -Eq 'DA_MODIFICARE|missing-qt|missing-kvantum' "$scratch/usage"; then
	echo "FAIL: usage lists an invalid theme"
	exit 1
fi
[[ "$(readlink "$themes/current/theme")" == "$themes/old" ]]
[[ ! -e "$CALL_LOG" ]]

for theme in missing-qt missing-kvantum; do
	echo "CHECK: reject $theme before changing the active theme"
	if bash "$script" "$theme" >"$scratch/error" 2>&1; then
		echo "FAIL: accepted incomplete theme $theme"
		exit 1
	fi
	grep -q 'Missing or unreadable theme config:' "$scratch/error"
	[[ "$(readlink "$themes/current/theme")" == "$themes/old" ]]
	[[ ! -e "$CALL_LOG" ]]
done

echo "CHECK: valid switch preserves links and notifies qt6ct"
touch -t 200001010000 "$HOME/.config/qt6ct"
before="$(stat -c %Y "$HOME/.config/qt6ct")"
bash "$script" new
[[ "$(readlink "$themes/current/theme")" == "$themes/new" ]]
[[ -L "$HOME/.config/qt6ct/qt6ct.conf" && -L "$HOME/.config/Kvantum" ]]
grep -q '^theme=new$' "$HOME/.config/Kvantum/kvantum.kvconfig"
[[ "$(stat -c %Y "$HOME/.config/qt6ct")" -gt "$before" ]]
[[ "$(grep -c '^restart-app ' "$CALL_LOG")" == 2 ]]
[[ "$(grep -c '^notify-send ' "$CALL_LOG")" == 0 ]]

echo "CHECK: listed basenames with spaces, apostrophes and shell characters remain selectable"
for theme in "space theme" "o'ne \$(theme)" "Mixed Case" "semi;colon"; do
	mkdir -p "$themes/$theme/kvantum"
	printf '[Appearance]\nstyle=kvantum\n' >"$themes/$theme/qt6ct.conf"
	printf '[General]\ntheme=%s\n' "$theme" >"$themes/$theme/kvantum/kvantum.kvconfig"
	bash "$script" --list | grep -Fx -- "$theme" >/dev/null
	bash "$script" "$theme"
	[[ "$(readlink "$themes/current/theme")" == "$themes/$theme" ]]
done
bash "$script" NEW
[[ "$(readlink "$themes/current/theme")" == "$themes/new" ]]
for theme in current ../old . ..; do
	if bash "$script" "$theme" >"$scratch/invalid-name" 2>&1; then
		echo "FAIL: accepted reserved or traversal name: $theme"
		exit 1
	fi
	[[ "$(readlink "$themes/current/theme")" == "$themes/new" ]]
done

for failure in "hyprctl reload" "swaync-client --skip-wait -R" \
	"swaync-client --skip-wait -rs" "touch $HOME/.config/qt6ct" \
	"theme-bg-next " "reload-app waybar" "restart-terminal " "reload-app btop" \
	"theme-set-gnome " "theme-set-obsidian " "theme-set-neovim $themes/new" \
	"restart-app dolphin" "restart-app krusader"; do
	echo "CHECK: continue after failure: $failure"
	: >"$CALL_LOG"
	FAIL_AT="$failure" bash "$script" new >"$scratch/update.log" 2>&1
	grep -Fq "Warning: theme update failed: ${failure% }" "$scratch/update.log"
	grep -qx 'restart-app krusader' "$CALL_LOG"
	grep -qx 'swaync-client --skip-wait -R' "$CALL_LOG"
	grep -qx 'swaync-client --skip-wait -rs' "$CALL_LOG"
	[[ "$(grep -c '^notify-send ' "$CALL_LOG")" == 1 ]]
done

echo "CHECK: all updates and warning notification can fail without aborting"
: >"$CALL_LOG"
FAIL_ALL=1 bash "$script" new >"$scratch/update.log" 2>&1
[[ "$(grep -c '^Warning: theme update failed:' "$scratch/update.log")" == 13 ]]
grep -qx 'restart-app krusader' "$CALL_LOG"
grep -q '^notify-send ' "$CALL_LOG"
echo "PASS: blocking validation, best-effort updates and non-waiting SwayNC calls verified"

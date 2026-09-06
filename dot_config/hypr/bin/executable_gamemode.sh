#!/bin/bash

# TODO: Add persistent mode
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

# Hyprland performance
if [ "$HYPRGAMEMODE" = "true" ]; then
        hyprctl -q eval '
        hl.config({
            animations = { enabled = false },
            decoration = {
                shadow = { enabled = false },
                blur = { xray = true, enabled = false },
                rounding = 0,
                active_opacity = 1,
                inactive_opacity = 1,
                fullscreen_opacity = 1,
            },
            general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
        })
        hl.layer_rule({ match = { namespace = "waybar" }, no_anim = true })
        hl.layer_rule({ match = { namespace = "swaync-notification-window" }, no_anim = true })
        hl.layer_rule({ match = { namespace = "swww-daemon" }, no_anim = true })
        hl.layer_rule({ match = { namespace = "rofi" }, no_anim = true })
        hl.window_rule({ match = { class = "(.*)" }, opaque = true }) -- ensure all windows are opaque
        '
        exit
else
        hyprctl reload config-only -q
fi

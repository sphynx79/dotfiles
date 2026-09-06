-- Colori del tema (versione Lua di hyprland.conf, per Hyprland >= 0.55)

hl.config({
    general = {
        col = {
            active_border   = { colors = { "rgba(dc8a78ff)", "rgba(8839efff)" }, angle = 45 },
            inactive_border = { colors = { "rgba(7287fdcc)", "rgba(179299cc)" }, angle = 45 },
        },
    },

    group = {
        col = {
            border_active          = { colors = { "rgba(dc8a78ff)", "rgba(8839efff)" }, angle = 45 },
            border_inactive        = { colors = { "rgba(7287fdcc)", "rgba(179299cc)" }, angle = 45 },
            border_locked_active   = { colors = { "rgba(dc8a78ff)", "rgba(8839efff)" }, angle = 45 },
            border_locked_inactive = { colors = { "rgba(7287fdcc)", "rgba(179299cc)" }, angle = 45 },
        },
    },
})

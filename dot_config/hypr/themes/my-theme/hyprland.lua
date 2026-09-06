-- vim: set sw=4 ts=4 sts=4 et tw=120 foldmarker={{{,}}} foldmethod=marker nospell:
-- Colori del tema (versione Lua di hyprland.conf, per Hyprland >= 0.55)

hl.config({
    general = {
        col = {
            active_border         = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
            inactive_border       = { colors = { "rgba(7d838d80)", "rgba(4c566a50)" }, angle = 45 },
            nogroup_border_active = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
            nogroup_border        = { colors = { "rgba(7d838d80)", "rgba(4c566a50)" }, angle = 45 },
        },
    },

    group = {
        col = {
            -- Border color for active windows
            border_active   = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
            -- Border color for inactive windows
            border_inactive = "rgba(3C3C3Caa)",
        },

        groupbar = {
            col = {
                active          = { colors = { "rgba(434c5ee6)", "rgba(4c566ae6)" }, angle = 45 },
                inactive        = "rgba(4c566a80)",
                locked_active   = "rgba(bf616aff)",
                locked_inactive = "rgba(5e81acaa)",
            },
            text_color          = "rgba(77ABCBCC)",
            text_color_inactive = "rgba(d8dee980)",
        },
    },
})

-- vim: set sw=4 ts=4 sts=4 et tw=120 foldmarker={{{,}}} foldmethod=marker nospell:
-- Colori del tema (versione Lua di hyprland.conf, per Hyprland >= 0.55)

hl.config({
    general = {
        col = {
            active_border         = { colors = { "rgba(a7c080ff)", "rgba(83c092ff)" }, angle = 45 },
            inactive_border       = { colors = { "rgba(4f585e80)", "rgba(3d484d50)" }, angle = 45 },
            nogroup_border_active = { colors = { "rgba(a7c080ff)", "rgba(83c092ff)" }, angle = 45 },
            nogroup_border        = { colors = { "rgba(4f585e80)", "rgba(3d484d50)" }, angle = 45 },
        },
    },

    group = {
        col = {
            -- Border color for active windows
            border_active   = { colors = { "rgba(a7c080ff)", "rgba(83c092ff)" }, angle = 45 },
            -- Border color for inactive windows
            border_inactive = "rgba(3d484daa)",
        },

        groupbar = {
            col = {
                active          = { colors = { "rgba(3d484de6)", "rgba(475258e6)" }, angle = 45 },
                inactive        = "rgba(343f4480)",
                locked_active   = "rgba(e67e80ff)",
                locked_inactive = "rgba(7fbbb3aa)",
            },
            text_color          = "rgba(d3c6aacc)",
            text_color_inactive = "rgba(9da9a080)",
        },
    },
})

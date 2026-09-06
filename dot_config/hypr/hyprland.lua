-- vim: set sw=4 ts=4 sts=4 et tw=120 foldmarker={{{,}}} foldmethod=marker nospell:
-- Configurazione Hyprland in Lua (Hyprland >= 0.55)
-- Migrata da hyprland.conf (hyprlang). Il vecchio file resta come fallback:
-- per tornare indietro basta rinominare/eliminare questo file e riavviare Hyprland.

-- VARIABLES {{{

    local HOME    = os.getenv("HOME")
    local CONFIG  = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")
    local RUNTIME = os.getenv("XDG_RUNTIME_DIR") or "/tmp"

    local scrPath = CONFIG .. "/hypr/bin" -- set scripts path
    -- Set your personal hyprland configuration here

    -- Main modifier
    local mainMod = "SUPER" -- windows key

    -- Assign apps
    local TERMINAL   = "kitty"
    local EDITOR     = "nvim"
    local EXPLORER   = "doublecmd"
    local BROWSER    = "vivaldi"
    local LOCKSCREEN = "hyprlock"

    -- // █▀▀ ▀█▀ █▄▀
    -- // █▄█ ░█░ █░█
    local GTK_THEME    = "Nordic-Blue"
    local ICON_THEME   = "Papirus-Dark"
    local COLOR_SCHEME = "prefer-dark"

    -- // █▀▀ █░█ █▀█ █▀ █▀█ █▀█
    -- // █▄▄ █▄█ █▀▄ ▄█ █▄█ █▀▄
    local CURSOR_THEME = "nitrux_cursors"
    local CURSOR_SIZE  = 28

    -- // █▀▀ █▀█ █▄░█ ▀█▀
    -- // █▀░ █▄█ █░▀█ ░█░
    local FONT                   = "Cantarell"
    local FONT_STYLE             = "Regular"
    local FONT_SIZE              = 10
    local DOCUMENT_FONT          = "Cantarell"
    local DOCUMENT_FONT_SIZE     = 10
    local MONOSPACE_FONT         = "CaskaydiaCove Nerd Font Mono"
    local MONOSPACE_FONT_SIZE    = 9
    local NOTIFICATION_FONT      = "Mononoki Nerd Font Mono"
    local BAR_FONT               = "JetBrainsMono Nerd Font"
    local MENU_FONT              = "JetBrainsMono Nerd Font" --? Use the same font as the main font
    local FONT_ANTIALIASING      = "rgba"
    local FONT_HINTING           = "slight"

    local active_opacity   = 0.94
    local inactive_opacity = 0.82
-- }}}

-- ENV {{{
    -- XDG Specifications - https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
    hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
    hl.env("XDG_SESSION_TYPE", "wayland")
    hl.env("XDG_SESSION_DESKTOP", "Hyprland")

    -- Qt Variables
    hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")        -- (From the Qt documentation) enables automatic scaling, based on the monitor's pixel density
    hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1") -- Disables window decorations on Qt applications
    hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")            -- Tells Qt based applications to pick your theme from qt5ct, use with Kvantum.

    -- Toolkit Backend Variables
    hl.env("GDK_BACKEND", "wayland,x11,*")     -- GTK: Use wayland if available. If not: try x11, then any other GDK backend.
    hl.env("QT_QPA_PLATFORM", "wayland;xcb")   -- Tell Qt applications to use the Wayland backend, and fall back to x11 if Wayland is unavailable
    hl.env("SDL_VIDEODRIVER", "wayland")       -- Run SDL2 applications on Wayland
    hl.env("CLUTTER_BACKEND", "wayland")       -- Force Clutter applications to try and use the Wayland backend

    -- Wayland-ENV
    hl.env("MOZ_ENABLE_WAYLAND", "1")
    hl.env("GDK_SCALE", "1")                          -- Set GDK scale to 1 // For Xwayland on HiDPI
    hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")    -- For Electron apps on Wayland

    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia") -- Disable this if you have issues with screensharing
    hl.env("GBM_BACKEND", "nvidia-drm")
    hl.env("EGL_PLATFORM", "wayland")
    hl.env("NVD_BACKEND", "direct")
    hl.env("PROTON_ENABLE_NGX_UPDATER", "1")
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GL_GSYNC_ALLOWED", "1")
    hl.env("__GL_MaxFramesAllowed", "1")
    hl.env("__GL_VRR_ALLOWED", "1")
    hl.env("GDK_DPI_SCALE", "0.9")
    hl.env("SCALE_FACTOR", "1")
    hl.env("ELECTRON_SCALE_FACTOR", "1")
    hl.env("ELECTRON_FORCE_DEVICE_SCALE_FACTOR", "1")
    hl.env("_JAVA_OPTIONS", "-Dsun.java2d.uiScale=1 -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true")
    -- hl.env("AQ_NO_MODIFIERS", "1")
    -- hl.env("__NV_DISABLE_EXPLICIT_SYNC", "1")

    -- XDG-ENV
    hl.env("XDG_RUNTIME_DIR", RUNTIME)
    hl.env("XDG_CONFIG_HOME", HOME .. "/.config")
    hl.env("XDG_CACHE_HOME", HOME .. "/.cache")
    hl.env("XDG_DATA_HOME", HOME .. "/.local/share")
    hl.env("XDG_STATE_HOME", HOME .. "/.local/state")

    -- PATH per gli script locali
    hl.env("PATH", HOME .. "/.local/bin:" .. scrPath .. ":" .. (os.getenv("PATH") or ""))

-- }}}

-- LAUNCHER {{{
    local list_variables = "WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CONFIG_HOME QT_QPA_PLATFORMTHEME"

    -- Tipo di slice per uwsm
    -- a: app-graphical.slice (predefinita) - Per le applicazioni grafiche generiche.
    -- b: background-graphical.slice - Per le applicazioni grafiche in background.
    -- s: session-graphical.slice - Per le applicazioni che sono considerate parte integrante della sessione stessa
    hl.on("hyprland.start", function()
        -- Preferenze fisse solo all'avvio, senza resettare il database dconf.
        hl.exec_cmd([[
            gsettings set org.gnome.desktop.interface cursor-size 24
            gsettings set org.gnome.desktop.interface font-name "Cantarell 10"
            gsettings set org.gnome.desktop.interface document-font-name "Cantarell 10"
            gsettings set org.gnome.desktop.interface monospace-font-name "CaskaydiaCove Nerd Font Mono 9"
            gsettings set org.gnome.desktop.interface font-antialiasing rgba
            gsettings set org.gnome.desktop.interface font-hinting slight
            gsettings set org.gnome.desktop.default-applications.terminal exec kitty
            gsettings set org.gnome.desktop.wm.preferences button-layout "''"
        ]])
        -- Tema GTK dal tema selezionato; theme-set lo riapplica durante i cambi.
        hl.exec_cmd('"' .. scrPath .. '/theme-set-gnome"')
        hl.exec_cmd(scrPath .. "/resetxdgportal")                               -- reset XDPH for screenshare
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")      --? Might fail so we hardcode the variables below
        hl.exec_cmd("dbus-update-activation-environment --systemd " .. list_variables) -- for XDPH
        hl.exec_cmd("systemctl --user import-environment " .. list_variables)  -- for XDPH ( redundant with the first one )
        hl.exec_cmd("app2unit.sh -t service " .. scrPath .. "/polkitkdeauth")  -- authentication dialogue for GUI apps
        hl.exec_cmd("app2unit.sh -t service waybar")                           -- launch the system bar
        -- TODO: Ho provato a usare questo ma non funziona per cui lo ho semplifciato ma provare a usare qusto
        hl.exec_cmd("app2unit.sh -t service blueman-applet")                   -- systray app for Bluetooth
        hl.exec_cmd("app2unit.sh -t service udiskie --automount --smart-tray") -- front-end that allows to manage removable media
        -- TODO: vedere se sostituirlo con dust, HYDE usa dust
        hl.exec_cmd("app2unit.sh -t service swaync")                           -- start notification demon
        hl.exec_cmd("app2unit.sh -t service nm-applet --indicator")            -- systray app for Network/Wifi
        hl.exec_cmd("app2unit.sh -t service wl-paste --type text --watch cliphist store")  -- clipboard store text data
        hl.exec_cmd("app2unit.sh -t service wl-paste --type image --watch cliphist store") -- clipboard store image data
        hl.exec_cmd("app2unit.sh -t service wl-clip-persist --clipboard regular")          -- wl-clip-persist (daemon)
        -- TODO: Semplificare la gestione wallpaper
        hl.exec_cmd("app2unit.sh -t service swaybg -i ~/.config/hypr/themes/current/background -m fill") -- start wallpaper daemon

        hl.exec_cmd("app2unit.sh -t service hypridle") -- idle daemon
        hl.exec_cmd("app2unit.sh -t service ~/.local/share/mise/shims/pypr")

        hl.exec_cmd("app2unit.sh -t service cairo-dock --wayland --opengl")

        hl.exec_cmd("hyprctl setcursor " .. CURSOR_THEME .. " " .. CURSOR_SIZE) --? Set cursor theme and size

        hl.exec_cmd("systemctl --user start elephant.service")
        hl.exec_cmd("app2unit.sh -t service walker --gapplication-service")

        -- hl.exec_cmd("kando")

        hl.exec_cmd("app2unit.sh -t service jamesdsp --tray")
    end)

    -- A ogni reload (come il vecchio `exec =`)
-- }}}

-- GENERAL {{{
    hl.config({
        general = {
            layout      = "dwindle",
            gaps_in     = 2,
            gaps_out    = 4,
            border_size = 2,
            col = {
                active_border          = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
                inactive_border        = { colors = { "rgba(7d838d80)", "rgba(4c566a50)" }, angle = 45 },
                nogroup_border_active  = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
                nogroup_border         = { colors = { "rgba(7d838d80)", "rgba(4c566a50)" }, angle = 45 },
            },
            resize_on_border = true,
            -- Non spostare il focus su un'altra finestra se in quella direzione non ce n'e' nessuna
            no_focus_fallback = true,
            snap = {
                enabled      = true,
                window_gap   = 20,
                monitor_gap  = 20,
                respect_gaps = true,
            },
        },
    })
-- }}}

-- GROUP {{{
    hl.config({
        group = {
            col = {
                -- Border color for active windows
                border_active   = { colors = { "rgba(78c6ebff)", "rgba(8289a380)" }, angle = 45 },
                -- Border color for inactive windows
                border_inactive = "rgba(3C3C3Caa)",
            },
            auto_group = false,
            -- 1 Ragruppa quando faccio il drag sopra la finestra
            -- 2 Ragruppa quando faccio il drag nella barra del gruppo
            drag_into_group = 2,
            -- Disabilita il group di un group in ultro group con trascnamento sulla finestra
            merge_groups_on_drag = false,
            -- Abilita il group di un group in ultro group con trascnamento nella barra del gruppo
            merge_groups_on_groupbar = true,

            groupbar = {
                enabled              = true,
                -- 0.56: niente groupbar quando il gruppo ha una sola finestra
                disable_when_only    = true,
                gradients            = true,
                render_titles        = true,
                blur                 = true,
                font_family          = "Cantarell",
                height               = 18,
                font_size            = 12,
                font_weight_inactive = "normal",
                font_weight_active   = "bold",
                indicator_gap        = 0,
                indicator_height     = 0,
                rounding             = 0,
                keep_upper_gap       = false,
                scrolling            = true,
                gaps_out             = 1,
                gaps_in              = 3,

                -- Nord Theme Colors
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
-- }}}

-- MONITOR {{{
    -- HDR on/off: stato scritto da bin/hdr-set (menu waybar del widget hyprsunset),
    -- riletto qui a ogni reload. off = dcip3 (SDR wide gamut), on = hdr.
    local hdr_state_file = io.open((os.getenv("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/hypr/hdr", "r")
    local hdr_on = false
    if hdr_state_file then
        hdr_on = hdr_state_file:read("*l") == "on"
        hdr_state_file:close()
    end

    hl.monitor({
        output              = "DP-1",
        mode                = "5120x1440@240",
        position            = "0x0",
        scale               = 1.25,
        bitdepth            = 10,
        sdrbrightness       = 1.0,
        sdrsaturation       = 1.0,
        supports_wide_color = 1,
        supports_hdr        = 1,
        sdr_min_luminance   = 0.005,
        sdr_max_luminance   = 200,
        min_luminance       = 0.001,
        max_luminance       = 1000,
        max_avg_luminance   = 200,
        cm                  = hdr_on and "hdr" or "dcip3",
    })
-- }}}

-- ANIMATIONS {{{
    hl.config({ animations = { enabled = true } })

    hl.curve("wind",   { type = "bezier", points = { { 0.05, 0.9 },  { 0.1, 1.05 } } })
    hl.curve("winIn",  { type = "bezier", points = { { 0.1, 1.1 },   { 0.1, 1.1 } } })
    hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 },  { 0, 1 } } })
    hl.curve("liner",  { type = "bezier", points = { { 1, 1 },       { 1, 1 } } })

    hl.animation({ leaf = "windows",     enabled = true, speed = 6,  bezier = "wind",    style = "slide" })
    hl.animation({ leaf = "windowsIn",   enabled = true, speed = 6,  bezier = "winIn",   style = "slide top" })
    hl.animation({ leaf = "windowsOut",  enabled = true, speed = 5,  bezier = "winOut",  style = "slide bottom" })
    hl.animation({ leaf = "windowsMove", enabled = true, speed = 5,  bezier = "wind",    style = "slide" })
    hl.animation({ leaf = "border",      enabled = true, speed = 1,  bezier = "liner" })
    hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner",   style = "once" })
    hl.animation({ leaf = "fade",        enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "wind" })
-- }}}

-- DECORATIONS {{{
    hl.config({
        decoration = {
            rounding           = 2,
            dim_special        = 0.3,
            active_opacity     = active_opacity,
            inactive_opacity   = inactive_opacity,
            fullscreen_opacity = 1,

            blur = {
                enabled           = true,
                special           = true,
                size              = 8,
                passes            = 4,
                new_optimizations = true,
                ignore_opacity    = true,
                xray              = false,
                popups            = true,
                vibrancy          = 0.5,
                brightness        = 0.80,
            },

            shadow = {
                enabled        = false,
                scale          = 1,
                render_power   = 4,
                range          = 30,
                color          = "rgba(0,0,0,0.60)",
                color_inactive = "rgba(0,0,0,0.33)",
            },
        },
    })
-- }}}

-- INPUT {{{
    hl.config({
        input = {
            kb_layout           = "us",
            kb_variant          = "",
            follow_mouse        = 2,
            -- follow_mouse_threshold = 500,
            special_fallthrough = true,
            focus_on_close      = 1,
            kb_options          = "compose:rctrl,fkeys:basic_13-24",

            scroll_factor       = 0.8,
            accel_profile       = "custom",
            scroll_points       = "0.2144477506 0.000 0.307 0.615 1.077 1.539 2.002 2.505 3.208 3.910 4.613 5.315 6.018 6.720 7.423 8.125 8.828 9.530 10.233 10.935 12.387",

            sensitivity         = -0.3,
            force_no_accel      = false,
            numlock_by_default  = true,
            repeat_rate         = 40,
            repeat_delay        = 300,

            touchpad = {
                natural_scroll = false,
            },
        },
    })

    -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
    hl.gesture({ fingers = 3, direction = "pinchin",    action = "float", mode = "tile" })
    hl.gesture({ fingers = 3, direction = "pinchout",   action = "float", mode = "float" })
-- }}}

-- CURSOR {{{
    hl.config({
        cursor = {
            use_cpu_buffer      = true,
            no_hardware_cursors = false,
            no_warps            = true,
            persistent_warps    = true,
            -- Minimo del range VRR del monitor (Philips 49M2C8900: 48-240 Hz)
            min_refresh_rate    = 48,
        },
    })
-- }}}

-- LAYOUT {{{
    -- Layout custom a tre zone (browser | centro/gruppo | dolphin) per l'ultrawide.
    -- File separato: registra "lua:threezone" e ritorna i workspace configurati
    -- in three-zone.conf (condiviso con center-group-daemon e center-window-switcher).
    -- require (0.56, path assoluti): scope isolato, un errore runtime nel file
    -- non blocca il resto di hyprland.lua (con dofile lo bloccava).
    local three_zone = require(CONFIG .. "/hypr/layouts/three-zone")
    if type(three_zone) == "table" then
        for ws in three_zone.workspaces:gmatch("%S+") do
            hl.workspace_rule({ workspace = ws, layout = three_zone.name })
        end
    end

    hl.config({
        layout = {
            -- era { 16, 9 }: WindowTarget la applica SOPRA qualsiasi layout quando
            -- il target tiled e' uno solo, e romperebbe le zone fisse di threezone
            -- (finestra singola ridotta a 16:9 e centrata sull'intero monitor)
            single_window_aspect_ratio           = { 0, 0 },
            single_window_aspect_ratio_tolerance = 0.1,
        },

        dwindle = {
            preserve_split         = true,
            force_split            = 2,
            smart_split            = false,
            use_active_for_splits  = false,
            default_split_ratio    = 1.23606,
            split_width_multiplier = 1.3,
        },

        master = {
            orientation = "left",
            -- imposta la scala delle finestre speciali (le finestre speciali sono buone, dai un'occhiata . . .)
            -- special_scale_factor = 2,
            -- mfact è la larghezza della finestra principale, o 'master factor'
            -- mfact = 0.30,
            new_status    = "slave",
            new_on_active = "right",
        },

        scrolling = {
            column_width = 0.5,
            follow_focus = true,
            direction    = "right",
        },
    })
-- }}}

-- MISC {{{
    -- TODO: ho messo i font fisso, ma vedererlo come mettere e gestirlo con una cartella theme
    hl.config({
        misc = {
            vrr                        = 3, -- VRR only game and video fullscreen
            disable_hyprland_logo      = true,
            disable_splash_rendering   = true,
            force_default_wallpaper    = 0,
            font_family                = "Cantarell",
            -- focus_on_activate = true,
            allow_session_lock_restore = true,
            anr_missed_pings           = 5,
        },

        xwayland = {
            force_zero_scaling = true,
        },

        render = {
            direct_scanout = true,
            -- QD-OLED tarato su gamma 2.2: evita ombre grigiastre della curva sRGB
            cm_sdr_eotf    = "gamma22",
        },
    })
-- }}}

-- KEYBINDINGS {{{
    -- Quake mode {{{
        hl.bind("CTRL + grave",         hl.dsp.exec_cmd("pypr-client toggle term"),     { description = "[Quake] kitty" })
        hl.bind(mainMod .. " + grave",  hl.dsp.exec_cmd("pypr-client toggle obsidian"), { description = "[Quake] obsidian" })
        hl.bind("ALT + grave",          hl.dsp.exec_cmd("pypr-client toggle chat-gpt"), { description = "[Quake] chat-gpt" })
        hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.exec_cmd("pypr-client toggle dolphin"), { description = "[Quake] dolphin" })
    -- }}}

    -- Launcher {{{
        hl.bind(mainMod .. " + CTRL + T", hl.dsp.exec_cmd("app2unit.sh " .. TERMINAL .. " -1 --instance-group kitty"), { description = "[Launchers|Apps] terminal emulator" })
        hl.bind(mainMod .. " + CTRL + E", hl.dsp.exec_cmd("app2unit.sh " .. EXPLORER), { description = "[Launchers|Apps] file explorer" })
        hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("app2unit.sh kitty -1 --instance-group " .. EDITOR .. " --class kitty-" .. EDITOR .. " -e " .. EDITOR), { description = "[Launchers|Apps] text editor" })
        hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("app2unit.sh " .. BROWSER), { description = "[Launchers|Apps] web browser" })
        hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("kitty -1 --instance-group btop --class btop -e btop"), { description = "[Launchers|Apps] system monitor" })
        hl.bind(mainMod .. " + CTRL + O", hl.dsp.exec_cmd("/usr/bin/shelly-ui"), { description = "[Launchers|Apps] pacman gui" })
        hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("app2unit.sh ~/.local/bin/llmmenu"), { description = "[Launchers|Apps] llm" })

        -- Special Key used with Nuphy Keyboard
        hl.bind("F13", hl.dsp.exec_cmd("app2unit.sh " .. BROWSER), { description = "[Launchers|Nuphy Keyboard] web browser" })
        hl.bind("F14", hl.dsp.exec_cmd("app2unit.sh " .. EXPLORER), { description = "[Launchers|Nuphy Keyboard] file explorer" })
        hl.bind("F15", hl.dsp.exec_cmd("app2unit.sh " .. TERMINAL .. " -1 --instance-group kitty"), { description = "[Launchers|Nuphy Keyboard] terminal emulator" })
        hl.bind("F16", hl.dsp.exec_cmd("app2unit.sh kitty -1 --instance-group " .. EDITOR .. " --class kitty-" .. EDITOR .. " -e " .. EDITOR), { description = "[Launchers|Nuphy Keyboard] text editor" })
        hl.bind("F17", hl.dsp.exec_cmd("/usr/bin/shelly-ui"), { description = "[Launchers|Nuphy Keyboard] octopi pacman gui" })
        hl.bind("F18", hl.dsp.exec_cmd("kitty -1 --class btop -e btop"), { description = "[Launchers|Nuphy Keyboard] system monitor" })
        hl.bind("F19", hl.dsp.exec_cmd("app2unit.sh ~/.local/bin/llmmenu"), { description = "[Launchers|Nuphy Keyboard] llm" })
        hl.bind("F20", hl.dsp.exec_cmd(scrPath .. "/launch-menu -m menus:system"), { description = "[Launchers|Nuphy Keyboard] logout menu" })

        -- era: window switcher rofi ("pkill -x rofi || rofilaunch.sh w")
        hl.bind(mainMod .. " + TAB",           hl.dsp.exec_cmd(scrPath .. "/center-window-switcher"), { description = "[Launchers|Walker menus] central windows switcher" })
        -- hl.bind(mainMod .. " + comma",      hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/emoji-picker.sh"), { description = "[Launchers|Rofi menus] emoji picker" })
        -- hl.bind(mainMod .. " + period",        hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/glyph-picker.sh"), { description = "[Launchers|Rofi menus] glyph picker" })
        -- hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/cliphist.sh -c"), { description = "[Launchers|Rofi menus] clipboard" })
        -- hl.bind(mainMod .. " + SHIFT + V",     hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/cliphist.sh"), { description = "[Launchers|Rofi menus] clipboard manager" })
        -- hl.bind(mainMod .. " + ALT + R",       hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/rofiselect.sh"), { description = "[Launchers|Rofi menus] select rofi launcher" })
    -- }}}

    -- Minimize {{{
        hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprland-minimizer"), { description = "[Minimize] current window" })

        -- Restore the last minimized window
        hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("hyprland-minimizer --restore-last"), { description = "[Minimize] restore last" })

        -- Interactively select a window to restore
        hl.bind(mainMod .. " + SHIFT + CTRL + M", hl.dsp.exec_cmd("hyprland-minimizer --menu"), { description = "[Minimize] interactive restore menu" })
    -- }}}

    -- Window Management {{{
        hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(scrPath .. "/dontkillsteam"), { description = "[Window Management] close focused window" })

        hl.bind(mainMod .. " + W", function()
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
            local m = hl.get_active_monitor()
            if m then
                -- 35% x 95% del monitor in pixel logici (width/height sono fisici)
                hl.dispatch(hl.dsp.window.resize({ x = m.width / m.scale * 0.35, y = m.height / m.scale * 0.95 }))
                hl.dispatch(hl.dsp.window.center())
            end
        end, { description = "[Window Management] Toggle floating" })

        hl.bind("SHIFT + F11", hl.dsp.window.fullscreen(), { description = "[Window Management] toggle fullscreen" })

        hl.bind(mainMod .. " + SHIFT + F", function()
            hl.dispatch(hl.dsp.window.tag({ tag = "pinned" }))
            hl.dispatch(hl.dsp.window.pin())
        end, { description = "[Window Management] toggle pin on focused window" })

        hl.bind(mainMod .. " + E", function()
            hl.dispatch(hl.dsp.window.tag({ tag = "pinned" }))
            hl.dispatch(hl.dsp.window.pin())
        end, { description = "[Window Management] toggle pin on focused window" })
        hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"), { description = "[Window Management] toggle split" })

        -- Group Navigation
        hl.bind(mainMod .. " + ALT + Right", hl.dsp.group.next(), { description = "[Window Management|Group Navigation] go app right" })
        hl.bind(mainMod .. " + ALT + Left",  hl.dsp.group.prev(), { description = "[Window Management|Group Navigation] go app left" })
        hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(scrPath .. "/center-group-reset"), { description = "[Window Management|Group Navigation] rebuild central group (three-zone)" })
        hl.bind(mainMod .. " + G", hl.dsp.submap("group"), { description = "[Window Management|Group Navigation] Enter group mode" })

        -- Define submap "group" (auto-reset dopo un dispatch, come `submap = group, reset`)
        hl.define_submap("group", "reset", function()
            hl.bind("right",  hl.dsp.group.next(), { repeating = true, description = "[Window Management|Group Navigation] go app right" })
            hl.bind("left",   hl.dsp.group.prev(), { repeating = true, description = "[Window Management|Group Navigation] go app left" })
            hl.bind("l",      hl.dsp.group.move_window({ forward = true }),  { repeating = true, description = "[Window Management|Group Navigation] move right" })
            hl.bind("h",      hl.dsp.group.move_window({ forward = false }), { repeating = true, description = "[Window Management|Group Navigation] move left" })
            hl.bind("t",      hl.dsp.group.toggle(), { repeating = true, description = "[Window Management|Group Navigation] Toggle group" })
            -- 0.56 non ha piu' il dispatcher moveoutofgroup: si usa l'API oggetto HL.Group
            hl.bind("u", function()
                local w = hl.get_active_window()
                local g = w and w.group
                if g then g:remove(w) end
            end, { description = "[Window Management|Group Navigation] sgancia la finestra corrente dal gruppo" })
            -- rinomina la tab della finestra corrente (plugin group-alias): prompt walker
            hl.bind("r", hl.dsp.exec_cmd(scrPath .. "/group-alias-prompt"), { description = "[Window Management|Group Navigation] rinomina la tab corrente" })
            hl.bind("SHIFT + r", hl.dsp.exec_cmd("hyprctl groupalias clear"), { description = "[Window Management|Group Navigation] rimuove il nome personalizzato della tab" })
            hl.bind("escape", hl.dsp.submap("reset"), { description = "[Window Management|Group Navigation] exit group mode" })
            hl.bind("return", hl.dsp.submap("reset"), { description = "[Window Management|Group Navigation] exit group mode" })
        end)

        -- Change focus
        hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }),  { description = "[Window Management|Change focus] focus left" })
        hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }), { description = "[Window Management|Change focus] focus right" })
        hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }),    { description = "[Window Management|Change focus] focus up" })
        hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }),  { description = "[Window Management|Change focus] focus down" })

        -- Move active window across current workspace
        -- (finestra float: sposta di 30px; finestra tiled: sposta nella direzione)
        local function move_float_or_tiled(dx, dy, dir)
            return function()
                local win = hl.get_active_window()
                if win and win.floating then
                    hl.dispatch(hl.dsp.window.move({ x = dx, y = dy, relative = true }))
                else
                    hl.dispatch(hl.dsp.window.move({ direction = dir }))
                end
            end
        end
        hl.bind(mainMod .. " + SHIFT + CTRL + left",  move_float_or_tiled(-30, 0, "left"),  { repeating = true, description = "Move active window to the left" })
        hl.bind(mainMod .. " + SHIFT + CTRL + right", move_float_or_tiled(30, 0, "right"),  { repeating = true, description = "Move active window to the right" })
        hl.bind(mainMod .. " + SHIFT + CTRL + up",    move_float_or_tiled(0, -30, "up"),    { repeating = true, description = "Move active window up" })
        hl.bind(mainMod .. " + SHIFT + CTRL + down",  move_float_or_tiled(0, 30, "down"),   { repeating = true, description = "Move active window down" })

        -- Resize Active Window
        hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }),  { repeating = true, description = "[Window Management|Resize Active Window] resize window right" })
        hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true, description = "[Window Management|Resize Active Window] resize window left" })
        hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true, description = "[Window Management|Resize Active Window] resize window up" })
        hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.resize({ x = 0, y = 30, relative = true }),  { repeating = true, description = "[Window Management|Resize Active Window] resize window down" })

        -- Move & Resize with mouse
        -- SUPER + LMB: se la finestra e' in un gruppo la sgancia e la rende
        -- floating prima di iniziare il drag (nessun dispatcher nativo lo fa in uno step)
        hl.bind(mainMod .. " + mouse:272", function()
            local w = hl.get_active_window()
            if w and w.group then
                w.group:remove(w)
                hl.dispatch(hl.dsp.window.float({ action = "enable" }))
            end
            hl.dispatch(hl.dsp.window.drag())
        end, { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Manage Float layout with Nuphy G1,G2,G3,G4
        local function float_layout(tag, w, h, x, y)
            return function()
                hl.dispatch(hl.dsp.window.tag({ tag = "+" .. tag }))
                hl.dispatch(hl.dsp.window.float({ action = "set" }))
                hl.dispatch(hl.dsp.window.resize({ x = w, y = h }))
                hl.dispatch(hl.dsp.window.move({ x = x, y = y }))
            end
        end
        hl.bind("F21", float_layout("left",   1474, 1117, 5,    34))
        hl.bind("F22", float_layout("center", 1926, 1112, 1486, 34))
        hl.bind("F23", float_layout("right",  672,  1117, 3420, 34))
        hl.bind("F24", hl.dsp.group.toggle())
    -- }}}

    -- Workspace {{{
        for i = 1, 10 do
            local key = i % 10 -- 10 maps to key 0
            hl.bind(mainMod .. " + " .. key,              hl.dsp.focus({ workspace = i }),                        { description = "[Workspaces|Navigation] navigate to workspace " .. i })
            hl.bind(mainMod .. " + ALT + " .. key,        hl.dsp.window.move({ workspace = i }),                  { description = "[Workspaces|Move window to workspace] move to workspace " .. i })
            hl.bind(mainMod .. " + SHIFT + " .. key,      hl.dsp.window.move({ workspace = i, follow = false }),  { description = "[Workspaces|Navigation|Move window silently] move to workspace " .. i .. " (silent)" })
        end

        -- Relative workspace
        hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "r+1" }), { description = "[Workspaces|Navigation|Relative workspace] change active workspace forwards" })
        hl.bind(mainMod .. " + CTRL + Left",  hl.dsp.focus({ workspace = "r-1" }), { description = "[Workspaces|Navigation|Relative workspace] change active workspace backwards" })

        hl.bind(mainMod .. " + CTRL + ALT + Right", hl.dsp.window.move({ workspace = "r+1" }), { description = "[Workspaces|Move window to workspace|Realtive workspace] move window to next relative workspace" })
        hl.bind(mainMod .. " + CTRL + ALT + Left",  hl.dsp.window.move({ workspace = "r-1" }), { description = "[Workspaces|Move window to workspace|Realtive workspace] move window to previous relative workspace" })

        -- Scroll worspace with mouse
        -- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "[Workspaces|Navigation] next workspace" })
        -- hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "[Workspaces|Navigation] previous workspace" })
    -- }}}

    -- Launcher Walker {{{
        hl.bind(mainMod .. " + Space",         hl.dsp.exec_cmd(scrPath .. "/launch-walker"), { description = "[Launchers|Walker menus] application finder" })
        hl.bind(mainMod .. " + ALT + Space",   hl.dsp.exec_cmd(scrPath .. "/launch-menu"), { description = "[Launchers|Walker menus] menu" })
        hl.bind(mainMod .. " + comma",         hl.dsp.exec_cmd(scrPath .. "/launch-walker -m symbols"), { description = "[Launchers|Walker menus] emoji picker" })
        hl.bind(mainMod .. " + Delete",        hl.dsp.exec_cmd(scrPath .. "/launch-menu -m menus:system"), { description = "[Launchers|Walker menus] logout menu" })
        hl.bind(mainMod .. " + slash",         hl.dsp.exec_cmd(scrPath .. "/keybinds_walker"), { description = "[Launchers|Walker menus] keybindings hint" })
    -- }}}

    -- Hardware Control {{{
        -- Audio
        hl.bind("F10",              hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o m"), { locked = true, description = "[Hardware Controls|Audio] toggle mute output" })
        hl.bind("XF86AudioMute",    hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o m"), { locked = true, description = "[Hardware Controls|Audio] toggle mute output" })
        hl.bind("F11",              hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o d"), { locked = true, repeating = true, description = "[Hardware Controls|Audio] decrease volume" })
        hl.bind("F12",              hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o i"), { locked = true, repeating = true, description = "[Hardware Controls|Audio] increase volume" })
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scrPath .. "/volumecontrol -i m"), { locked = true, description = "[Hardware Controls|Audio] un/mute microphone" })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o d"), { locked = true, repeating = true, description = "[Hardware Controls|Audio] decrease volume" })
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scrPath .. "/volumecontrol -o i"), { locked = true, repeating = true, description = "[Hardware Controls|Audio] increase volume" })

        -- Media
        hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "[Hardware Controls|Media] play media" })
        hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "[Hardware Controls|Media] pause media" })
        hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "[Hardware Controls|Media] next media" })
        hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "[Hardware Controls|Media] previous media" })

        -- Brightness
        -- brightnesscontrol.sh non esisteva in bin/: si usa brightnessctl
        hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true, description = "[Hardware Controls|Brightness] increase brightness" })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true, description = "[Hardware Controls|Brightness] decrease brightness" })
    -- }}}

    -- Utilities {{{
        hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("lock-screen"), { description = "[Utilities] lock screen" })
        hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(scrPath .. "/logoutlaunch"), { description = "[Utilities] logout menu" })
        -- hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(scrPath .. "/keyboardswitch.sh"), { locked = true, description = "[Utilities] toggle keyboardlayout" })
        hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd(scrPath .. "/gamemode.sh"), { description = "[Utilities] game mode" }) -- disable hypr effects for gamemode
        hl.bind(mainMod .. " + mouse_up", function()
            local z = hl.get_config("cursor.zoom_factor") or 1
            hl.config({ cursor = { zoom_factor = z * 0.5 } })
        end, { description = "[Utilities] zooom out" })
        hl.bind(mainMod .. " + mouse_down", function()
            local z = hl.get_config("cursor.zoom_factor") or 1
            hl.config({ cursor = { zoom_factor = z * 1.8 } })
        end, { description = "[Utilities] zoom in" })
    -- }}}

    -- Capture {{{
        hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(scrPath .. "/launch-menu -m menus:screenshot"), { description = "[Capture|Screenshot] Screenshot menu (walker)" })
        hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(scrPath .. "/grimblast --freeze copy area && notify-send -a Screenshot -i camera-photo 'Screenshot copied to clipboard'"), { description = "[Capture|Screenshot] Select area, copy image to clipboard" })
        hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("SCREENSHOT_ANNOTATION_TOOL=satty " .. scrPath .. "/cmd-screenshot s"), { description = "[Capture|Screenshot] Select area, edit in Satty" })

        hl.bind(mainMod .. " + C",           hl.dsp.exec_cmd("hyprpicker -an"),   { description = "[Capture|Color] picker" })        -- Pick color (Hex) >> clipboard
        hl.bind(mainMod .. " + SHIFT + C",   hl.dsp.exec_cmd("color_picker.sh"),  { description = "[Capture|Color] picker change" }) -- Pick color (Hex) >> oklch-color-picker
    -- }}}

    -- Ricing {{{
        -- TODO: Vedere quali di questi lasciare
        hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(scrPath .. "/theme-bg-next"), { description = "[Theming and Wallpaper] next wallpaper" }) -- next global wallpaper
        hl.bind(mainMod .. " + ALT + W",   hl.dsp.exec_cmd(scrPath .. "/launch-menu -m menus:wallpapers"), { description = "[Theming and Wallpaper] wallpaper picker" }) -- walker menu with previews
        -- hl.bind(mainMod .. " + ALT + Left", hl.dsp.exec_cmd(scrPath .. "/wallpaper.sh -Gp"), { description = "[Theming and Wallpaper] previous global wallpaper" })
        -- hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/wallpaper.sh -SG"), { description = "[Theming and Wallpaper] select a global wallpaper" })
        -- hl.bind(mainMod .. " + SHIFT + U", hl.dsp.exec_cmd("pkill -x rofi || " .. scrPath .. "/hyprlock.sh --select"), { description = "[Theming and Wallpaper] select hyprlock layout" })
        hl.bind(mainMod .. " + ALT + T", hl.dsp.exec_cmd("killall waybar || app2unit.sh -t service waybar"), { description = "[Theming and Wallpaper] toggle waybar" }) -- restart waybar
    -- }}}

    -- Speacial APP {{{
        hl.bind("CTRL + mouse:274", hl.dsp.global(":application-menu"))
        hl.bind(mainMod .. " + mouse:274", hl.dsp.global(":hyrpland-menu"), { release = true })
        -- hl.bind("ALT + Space", hl.dsp.exec_cmd("hypr-gridtile"))
        hl.bind(mainMod .. " + K", hl.dsp.send_shortcut({ mods = "CTRL", key = "K", window = "class:^(keycombiner)$" }))
    -- }}}

-- }}}

-- WINDOW RULES {{{

    -- FIX {{{
        hl.window_rule({
            name  = "suppress-maximize-all",
            match = { class = ".*" },

            suppress_event = "maximize",
        })

        hl.window_rule({
            name  = "xwayland-drag-fix-nofocus",
            match = {
                class      = "^$",
                title      = "^$",
                xwayland   = true,
                float      = true,
                fullscreen = false,
                pin        = false,
            },

            no_focus = true,
        })
    -- }}}

    -- Three-zone Layout {{{
        -- Il vecchio "Float Layout" (ws1-base float + tag left/center/right con
        -- size/move fisse) e' stato sostituito dal layout tiled "lua:threezone"
        -- (layouts/three-zone.lua) + bin/center-group-daemon per il gruppo centrale.
        -- Classi e percentuali: three-zone.conf.

        -- keycombiner prima ereditava il float da ws1-base: deve restare floating,
        -- non va mai messo in tiling nella zona centrale.
        hl.window_rule({
            name  = "keycombiner-float",
            match = { class = "^(keycombiner)$" },

            float  = true,
            center = true,
        })
    -- }}}

    -- Idleinhibit rules {{{
        hl.window_rule({
            name  = "idleinhibit-fullscreen-media-browsers",
            match = { class = "^.*(celluloid|mpv|vlc|[Ss]potify|LibreWolf|floorp|brave|firefox|chromium|zen|vivaldi).*$" },

            idle_inhibit = "fullscreen",
        })
    -- }}}

    -- Picture-in-Picture {{{
        hl.window_rule({
            name  = "pip-float-pin",
            match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },

            float             = true,
            keep_aspect_ratio = true,
            move              = { "(monitor_w*0.73)", "(monitor_h*0.72)" },
            -- l'originale hyprlang aveva `size = (monitor_w*0.25)` (solo larghezza):
            -- in Lua size richiede 2 valori, altezza calcolata 16:9
            size              = { "(monitor_w*0.25)", "(monitor_w*0.140625)" },
            pin               = true,
        })
    -- }}}

    -- Dialog {{{
        hl.window_rule({
            name  = "dolphin-dialog-generic",
            match = {
                class = "^(org.kde.dolphin)$",
                title = "^(.*(Configura|Sposta|Proprietà|Conferma|Sostituisci|Elimina|Informazioni|Progress|About|etichette).*)$",
            },

            float      = true,
            animation  = "popin",
            center     = true,
            dim_around = true,
        })

        hl.window_rule({
            name  = "dolphin-copy-progress",
            match = {
                class = "^(org.kde.dolphin|org.kde.krusader)$",
                title = "^(Copia in corso — Dolphin|Finestra di avanzamento — Dolphin)$",
            },

            float     = true, -- prima ereditato da ws1-base, ora esplicito
            move      = { 1860, 248 },
            size      = { 600, 178 },
            animation = "popin",
        })

        hl.window_rule({
            name  = "dolphin-file-exists",
            match = {
                class = "^(org.kde.dolphin)$",
                title = "^(Il file esiste già — Dolphin)$",
            },

            float      = true, -- prima ereditato da ws1-base, ora esplicito
            move       = { 1860, 434 },
            size       = { 600, 283 },
            animation  = "popin",
            dim_around = true,
        })

        hl.window_rule({
            name  = "krusader-config",
            match = {
                class = "^(org.kde.krusader)$",
                title = "^(.+Krusader)$",
            },

            float     = true, -- prima ereditato da ws1-base, ora esplicito
            size      = { "(monitor_w*0.3)", "(monitor_h*0.6)" },
            center    = true,
            animation = "popin",
            -- dim_around = true,
        })

        hl.window_rule({
            name  = "doublecmd-options",
            match = {
                class = "^(doublecmd)$",
                title = "^(Opzioni)$",
            },

            float  = true,
            center = true,
            size              = { "(monitor_w*0.34)", "(monitor_h*0.74)" },
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "doublecmd-find",
            match = {
                class = "^(doublecmd)$",
                title = "^(Trova.*)$",
            },

            float = true,
            move  = { 3274, 34 },
            size  = { 816, 1112 },
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "doublecmd-media-viewer",
            match = {
                class = "^(doublecmd)$",
                title = "(?i)^.*\\.(mp4|mkv|avi|mov|webm|m4v|wmv|flv|mpg|mpeg|ts|jpg|jpeg|png|gif|bmp|webp|svg|tif|tiff|avif|heic)$",
            },

            float  = true,
            center = true,
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "doublecmd-text-editor",
            match = {
                class = "^(doublecmd)$",
                title = "(?i)^.*\\.(txt|md|markdown|rb|rbw|rake|gemspec|py|lua|sh|bash|zsh|fish|json|jsonc|xml|yml|yaml|toml|ini|conf|cfg|js|ts|mjs|html|css|scss|c|h|cpp|hpp|pas|lfm|lpr|go|rs|java|kt|swift|pl|php|sql|log|patch|diff|desktop|service|hgl)$",
            },

            float = true,
            move  = { 2555, 34 },
            size  = { 837, 1112 },
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "doublecmd-pdf-viewer",
            match = {
                class = "^(doublecmd)$",
                title = "(?i)^.*\\.(pdf|djvu|epub)$",
            },

            float = true,
            move  = { 2418, 34 },
            size  = { 974, 1112 },
            focus_on_activate = true,
        })


        hl.window_rule({
            name  = "krusader-copy-progress",
            match = {
                class = "^(org.kde.krusader)$",
                title = "^(Copia in corso — Krusader|Finestra di avanzamento — Krusader)$",
            },

            float     = true, -- prima ereditato da ws1-base, ora esplicito
            move      = { 1860, 248 },
            size      = { 600, 178 },
            animation = "popin",
            -- dim_around = false,
        })

        hl.window_rule({
            name  = "krusader-file-exists",
            match = {
                class = "^(org.kde.krusader)$",
                title = "^(Il file esiste già — Krusader)$",
            },

            float      = true, -- prima ereditato da ws1-base, ora esplicito
            move       = { 1860, 434 },
            size       = { 600, 283 },
            animation  = "popin",
            -- dim_around = true,
        })

        hl.window_rule({
            name  = "systry-float",
            match = { class = "(org.pulseaudio.pavucontrol|syncthingtray-qt6|blueman-manager|nm-applet)" },

            float = true,
            pin   = true,
            size  = { 800, 600 },
            move  = { "(monitor_w-window_w-100)", 36 },
        })

        hl.window_rule({
            name  = "float-modals",
            match = { modal = true },

            float             = true,
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "firefox-floats",
            match = {
                class = "^firefox$",
                title = "^(About Mozilla Firefox|Picture-in-Picture|Library)$",
            },

            float = true,
        })

        hl.window_rule({
            name  = "float-dialog-title",
            match = { title = "^(.*dialog.*)$" },

            float = true,
        })

        hl.window_rule({
            name  = "portal-gtk-open-save",
            match = { class = "^(xdg-desktop-portal-gtk)$" },

            float      = true,
            size       = { 1200, 800 },
            center     = true,
            dim_around = true,
        })

        hl.window_rule({
            name  = "float-prefix-titles",
            match = { title = "^(File Upload|Choose wallpaper|Library).*$" },

            float = true,
        })


        hl.window_rule({
            name  = "float-polkit",
            match = { class = "^(polkit-gnome-authentication-agent.*)" },

            focus_on_activate = true,
            pin               = true,
            stay_focused      = true,
            dim_around        = true,
        })

    -- }}}

    -- Opacity {{{
        hl.window_rule({
            name  = "opacity-browser",
            match = { class = "(?i)^(vivaldi-stable|zen-beta|brave-browser|firefox|google-chrome|chromium|librewolf|floorp|org.qutebrowser.qutebrowser)" },

            opacity = "1 override 1 override 1",
        })

        hl.window_rule({
            name  = "opacity-kitty",
            match = { class = "^(.*kitty.*)$" },
            opacity = "0.95 override 0.85 override",
        })
    -- }}}

    -- Float {{{
        hl.window_rule({
            name  = "qview-float",
            match = { class = "(com.interversehq.qView)" },

            float             = true,
            center            = true,
            size              = { "(monitor_w*0.28)", "(monitor_h*0.54)" },
            min_size          = { 600, 420 },
            max_size          = { 2600, 1420 },
            focus_on_activate = true,
            dim_around        = true,
        })

        hl.window_rule({
            name  = "satty",
            match = { class = "(com.gabm.satty)" },

            float             = true,
            center            = true,
            size              = { "(monitor_w*0.28)", "(monitor_h*0.54)" },
            min_size          = { 700, 420 },
            max_size          = { 2600, 1420 },
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "sysd-manager-float",
            match = {
                class = "^(io.github.plrigaux.sysd-manager)$",
                title = "^(sysd-manager)$",
            },

            float             = true,
            size              = { "(monitor_w*0.58)", "(monitor_h*0.84)" },
            focus_on_activate = true,
            -- dim_around = true,
        })

        hl.window_rule({
            name  = "kitty-btop-size",
            match = { class = "^(kitty-btop)$" },

            size              = { "(monitor_w*0.58)", "(monitor_h*0.84)" },
            center            = true,
            float             = true,
            focus_on_activate = true,
            -- dim_around = true,
        })

        hl.window_rule({
            name  = "theme-manager-float",
            match = { class = "^(kvantummanager|qt5ct|qt6ct|nwg-look)$" },

            float             = true,
            size              = { "(monitor_w*0.34)", "(monitor_h*0.74)" },
            focus_on_activate = true,
            dim_around        = true,
        })

        hl.window_rule({
            name  = "floating-window-behavior",
            match = { class = "(TUI.float)" },

            float             = true,
            center            = true,
            size              = { "(monitor_w*0.28)", "(monitor_h*0.84)" },
            focus_on_activate = true,
            dim_around        = true,
        })

        hl.window_rule({
            name  = "hyprarch-editors-float-center",
            match = { class = "^(org.hyprarch.(nvim|vim|nano|micro|hx|helix))$" },

            float             = true,
            center            = true,
            size              = { "(monitor_w*0.58)", "(monitor_h*0.84)" },
            focus_on_activate = true,
            dim_around        = true,
        })

        hl.window_rule({
            name  = "float-shelly",
            match = { class = "^(com.shellyorg.shelly)" },

            float      = true,
            center     = true,
            size              = { "(monitor_w*0.48)", "(monitor_h*0.84)" },
            focus_on_activate = true,
        })

        hl.window_rule({
            name  = "cairo-dock-nota-float",
            match = { initial_title = "^Cairo-Dock - Nota:.*$" },

            float      = true,
            center     = true,
            size              = { "(monitor_w*0.20)", "(monitor_h*0.80)" },
            focus_on_activate = true,
        })
        
        hl.window_rule({
            name  = "jamedsp",
            match = { class = "^(jamesdsp)" },

            float      = true,
            center     = true,
            size              = { "(monitor_w*0.30)", "(monitor_h*0.80)" },
            focus_on_activate = true,
        })
    -- }}}

    -- Style {{{
        hl.window_rule({
            name  = "pinned-border-style",
            match = { tag = "pinned" },
            border_color = "rgba(78c6ebff) rgba(d0877090)",
        })

    -- }}}

    -- Full Screen {{{
        hl.window_rule({
            name  = "hyprarch-screensaver-fullscreen",
            match = { class = "^org\\.hyprarch\\.screensaver$" },

            fullscreen = true,
        })
    -- }}}

    -- Application {{{
        hl.window_rule({
            name  = "Oklch_Color_Picker",
            match = { title = "^(.*Oklch Color Picker.*)$" },

            float     = true,
            animation = "popin",
            group     = "barred",
            center    = true,
            size      = { "(monitor_w*0.15)", "(monitor_h*0.45)" },
        })

        hl.window_rule({
            name  = "Hypr_gridtile",
            match = { class = "^(glfw window)$" },

            no_anim      = true,
            stay_focused = true,
            group        = "barred",
            border_size  = 1,
        })

        hl.window_rule({
            name  = "Vivaldi",
            match = { class = "^(.*vivaldi.*)$" },

            group = "barred",
        })

        hl.window_rule({
            name  = "Pacsea",
            match = { class = "^(.*kitty-pacsea.*)$" },

            group             = "barred",
            size              = { "(monitor_w*0.58)", "(monitor_h*0.84)" },
            focus_on_activate = true,
            center            = true,
            float             = true,
        })

        hl.window_rule({
            name  = "Dolphin",
            match = { class = "^(org.kde.dolphin)$" },

            group = "barred",
        })

        hl.window_rule({
            name  = "Krusader",
            match = { class = "^(org.kde.krusader)$" },

            group = "barred",
        })

        hl.window_rule({
            name  = "kando-overlay",
            match = { class = "^(kando)$" },

            no_blur = true,
            opaque  = true,
            size    = { "(monitor_w*1)", "(monitor_h*1)" },

            -- l'originale aveva `border_size = on` (valore non valido, ignorato): rimosso
            no_anim = true,
            float   = true,
            pin     = true,
        })

        hl.window_rule({
            name  = "ticktick",
            match = { class = "^(vivaldi-ticktick.com__webapp-Default)$" },

            -- no_blur = true,
            xray    = true,
            opacity = "0.7 override 0.6 override",

            -- border_size = 20,
            float   = true,
        })
    -- }}}

-- }}}

-- LAYER RULES {{{
    hl.layer_rule({ match = { namespace = "rofi" },                      blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "walker" },                    blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "notifications" },             blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "swaync-control-center" },     blur = true, ignore_alpha = 0 })
    hl.layer_rule({ match = { namespace = "logout_dialog" },             blur = true })
    hl.layer_rule({ match = { namespace = "cairo-dock" },                blur = true, ignore_alpha = 0, xray = false, blur_popups = true })
-- }}}

-- EXTERNAL CONFIG {{{
    -- Alias delle tab della groupbar: caricamento nativo, gestito anche ai reload.
    hl.plugin.load(CONFIG .. "/hypr/plugins/group-alias/build/group-alias.so")

    -- Tema attivo: themes/current/theme -> symlink al tema selezionato da theme-set.
    -- require (0.56) segue il symlink a ogni reload (theme-set fa `hyprctl reload` dopo
    -- il cambio); il pcall resta per il caso di symlink/file mancante, dove require solleva.
    local ok, err = pcall(require, CONFIG .. "/hypr/themes/current/theme/hyprland")
    if not ok then
        hl.notification.create({
            text    = "Errore nel tema Lua: " .. tostring(err),
            timeout = 8000,
            icon    = "error",
        })
    end
-- }}}

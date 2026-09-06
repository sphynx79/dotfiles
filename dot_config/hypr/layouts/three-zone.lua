-- Layout deterministico a tre zone per il monitor ultrawide (Hyprland >= 0.55, config Lua).
--
-- Registrato come "lua:threezone": si seleziona con general.layout oppure, come fa
-- hyprland.lua, con hl.workspace_rule({ workspace = "1", layout = "lua:threezone" }).
--
-- | browser (left) | finestra singola o gruppo (center) | dolphin (right) |
--
-- Questo file si occupa SOLO di geometria:
--   - le zone hanno larghezze fisse (percentuali da three-zone.conf), anche se vuote;
--   - piu' finestre nella stessa zona vengono impilate in verticale;
--   - un gruppo Hyprland arriva gia' come singolo target (CWindowGroupTarget) e viene
--     tenuto in cima alla pila centrale, cosi' il demone puo' unire le finestre nuove
--     con "move into_group up" in modo deterministico.
-- La creazione/manutenzione dei gruppi e' di bin/center-group-daemon: qui nessun
-- dispatcher, nessun side effect nel recalculate.
--
-- Note vincolate alla versione (0.55.x):
--   - API: hl.layout.register(name, { recalculate(ctx) }), ctx = { area, targets },
--     target = { index, window, box, place(box) }. ctx.area e' la workArea dello
--     spazio (gia' senza zone riservate tipo waybar e senza general:gaps_out).
--   - I box vanno piazzati CONTIGUI (bordo a bordo): i gap visivi li aggiunge il
--     target layer con general:gaps_in, e la ricerca direzionale del compositor
--     (getWindowInDirection) considera adiacenti solo box logici a <= 2px.
--     Un gap fatto qui romperebbe focus direzionale e "move into_group".
--   - layout:single_window_aspect_ratio va tenuto a {0,0}: viene applicato dal
--     target SOPRA il layout quando c'e' un solo tile e falserebbe le zone.

local HOME   = os.getenv("HOME")
local CONFIG = os.getenv("XDG_CONFIG_HOME") or (HOME .. "/.config")

-- three-zone.conf e' condiviso con demone e overlay: righe KEY="VALUE".
-- Viene letto al load (quindi a ogni hyprctl reload), non nel recalculate.
local function parse_conf(path)
    local conf = {}
    local f = io.open(path, "r")
    if not f then return conf end
    for line in f:lines() do
        if not line:match("^%s*#") then
            local k, v = line:match('^%s*([%w_]+)%s*=%s*"([^"]*)"%s*$')
            if k then conf[k] = v end
        end
    end
    f:close()
    return conf
end

local function to_set(str)
    local set = {}
    for word in (str or ""):gmatch("%S+") do set[word] = true end
    return set
end

local CONF_PATH = CONFIG .. "/hypr/three-zone.conf"

-- Classi e percentuali sono hot-reload: rilette a ogni recalculate (il file e'
-- minuscolo, il costo e' trascurabile). Cambiare THREE_ZONE_WORKSPACES richiede
-- invece hyprctl reload, perche' le workspace rule si registrano al config load.
local function settings()
    local conf = parse_conf(CONF_PATH)
    return {
        left       = to_set(conf.THREE_ZONE_LEFT_CLASSES),
        right      = to_set(conf.THREE_ZONE_RIGHT_CLASSES),
        pct_left   = tonumber(conf.THREE_ZONE_LEFT_PCT)   or 0.36,
        pct_center = tonumber(conf.THREE_ZONE_CENTER_PCT) or 0.47,
        pct_right  = tonumber(conf.THREE_ZONE_RIGHT_PCT)  or 0.17,
    }
end

local function zone_of(target, s)
    local w = target.window
    if not w then return "center" end
    if w.group then return "center" end -- un gruppo sta sempre al centro
    if s.left[w.class] then return "left" end
    if s.right[w.class] then return "right" end
    return "center" -- whitelist centrale + finestre non classificate (mai raggruppate dal demone)
end

-- Impila i target di una zona in verticale, bordo a bordo (l'ultimo prende il resto).
local function stack(targets, x, y, w, h)
    local n = #targets
    if n == 0 then return end
    local each = math.floor(h / n)
    for i, t in ipairs(targets) do
        local ty = y + (i - 1) * each
        local th = (i == n) and (y + h - ty) or each
        t:place({ x = x, y = ty, w = w, h = th })
    end
end

local M = {
    name       = "lua:threezone",
    workspaces = parse_conf(CONF_PATH).THREE_ZONE_WORKSPACES or "1",
}

hl.layout.register("threezone", {
    recalculate = function(ctx)
        local s = settings()
        local zones = { left = {}, center = {}, right = {} }

        for _, t in ipairs(ctx.targets) do
            local w = t.window
            -- le finestre fullscreen le gestisce il compositor: non le tocchiamo
            if not (w and w.fullscreen ~= 0) then
                local zone = zones[zone_of(t, s)]
                -- il gruppo (target unico) va in cima alla pila centrale
                if w and w.group then
                    table.insert(zone, 1, t)
                else
                    table.insert(zone, t)
                end
            end
        end

        -- larghezze fisse dalle percentuali (normalizzate), indipendenti
        -- dall'occupazione: una zona vuota resta vuota
        local a       = ctx.area
        local total   = s.pct_left + s.pct_center + s.pct_right
        local w_left  = math.floor(a.w * s.pct_left / total)
        local w_cent  = math.floor(a.w * s.pct_center / total)
        local w_right = a.w - w_left - w_cent

        stack(zones.left,   a.x,                   a.y, w_left,  a.h)
        stack(zones.center, a.x + w_left,          a.y, w_cent,  a.h)
        stack(zones.right,  a.x + w_left + w_cent, a.y, w_right, a.h)
    end,

    -- Solo trigger di ricalcolo (Hyprland richiama recalculate dopo ogni
    -- layout_msg riuscito): lo usa center-group-daemon quando three-zone.conf
    -- cambia, via hl.dsp.layout("three-zone:refresh"). Nessuna logica qui.
    layout_msg = function(_, _) end,
})

return M

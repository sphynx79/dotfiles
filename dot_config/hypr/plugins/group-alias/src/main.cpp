// hyprland-group-alias
//
// Alias puramente visuale per i titoli delle tab della groupbar di Hyprland.
// Il titolo Wayland reale della finestra non viene mai modificato in modo persistente:
// viene sostituito solo per la durata del disegno della groupbar.
//
// Punto di hook (Hyprland 0.56.2, commit efb50993780079460b0cbed1363e2166a2de1d9f):
//   - CHyprGroupBarDecoration::draw(PHLMONITOR, const float&)
//
// Per la sola durata della draw della groupbar i titoli delle finestre con alias vengono
// scambiati con l'alias. Cosi' sia la texture sia la chiave della cache intra-frame della
// groupbar (indicizzata sul titolo) restano coerenti.

#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/Compositor.hpp>
#include <hyprland/src/desktop/view/Window.hpp>
#include <hyprland/src/desktop/view/Group.hpp>
#include <hyprland/src/desktop/state/FocusState.hpp>

#include <lua.hpp>

#include <algorithm>
#include <optional>
#include <string>
#include <unordered_map>

inline HANDLE                                        PHANDLE = nullptr;

static std::unordered_map<PHLWINDOWREF, std::string> g_aliases;

static CFunctionHook*                                g_drawHook = nullptr;

static constexpr size_t                              MAX_ALIAS_BYTES = 256;

//
// alias store
//

static void pruneDeadWindows() {
    std::erase_if(g_aliases, [](const auto& entry) { return !entry.first; });
}

static std::optional<std::string> aliasFor(PHLWINDOW window) {
    if (!window)
        return std::nullopt;

    const auto IT = g_aliases.find(window);
    if (IT == g_aliases.end())
        return std::nullopt;

    return IT->second;
}

// trim, newline -> spazio, rifiuta NUL, tronca su boundary UTF-8.
// nullopt = input non valido.
static std::optional<std::string> sanitizeAlias(const char* raw, size_t len) {
    std::string alias(raw, len);

    if (alias.find('\0') != std::string::npos)
        return std::nullopt;

    for (auto& c : alias) {
        if (c == '\n' || c == '\r' || c == '\t')
            c = ' ';
    }

    const auto FIRST = alias.find_first_not_of(' ');
    if (FIRST == std::string::npos)
        return std::string{};

    alias = alias.substr(FIRST, alias.find_last_not_of(' ') - FIRST + 1);

    if (alias.size() > MAX_ALIAS_BYTES) {
        size_t cut = MAX_ALIAS_BYTES;
        // non tagliare a metà di una sequenza UTF-8: indietreggia sui byte di continuazione 10xxxxxx
        while (cut > 0 && (static_cast<unsigned char>(alias[cut]) & 0xC0) == 0x80)
            --cut;
        alias.resize(cut);
    }

    return alias;
}

//
// redraw
//

static void damageGroupbarOf(PHLWINDOW window) {
    if (!window)
        return;

    const auto DAMAGE = [](PHLWINDOW w) {
        if (!w)
            return;
        if (auto* deco = w->getDecorationByType(DECORATION_GROUPBAR))
            deco->damageEntire();
    };

    if (window->m_group) {
        for (const auto& ref : window->m_group->windows())
            DAMAGE(ref.lock());
    } else
        DAMAGE(window);
}

//
// hooks
//

using origDraw = void (*)(void*, PHLMONITOR, const float&);

// scambia titolo reale e alias su tutte le finestre note (swap: nessuna allocazione)
static void swapTitles() {
    for (auto& [ref, alias] : g_aliases) {
        if (const auto WINDOW = ref.lock(); WINDOW)
            std::swap(WINDOW->m_title, alias);
    }
}

static void hkDraw(void* thisptr, PHLMONITOR monitor, const float& a) {
    const auto ORIGINAL = reinterpret_cast<origDraw>(g_drawHook->m_original);

    if (g_aliases.empty()) {
        ORIGINAL(thisptr, monitor, a);
        return;
    }

    // i titoli vanno ripristinati anche se il renderer lancia
    struct STitleGuard {
        ~STitleGuard() {
            swapTitles();
        }
    } guard;

    swapTitles();
    ORIGINAL(thisptr, monitor, a);
}

//
// logica condivisa Lua / hyprctl
//

// ritorna nullptr in caso di successo, altrimenti un messaggio di errore statico
static const char* applyAlias(const char* raw, size_t len) {
    const auto WINDOW = Desktop::focusState()->window();
    if (!WINDOW)
        return "nessuna finestra attiva";

    const auto ALIAS = sanitizeAlias(raw, len);
    if (!ALIAS)
        return "alias non valido (contiene byte NUL)";

    pruneDeadWindows();

    if (ALIAS->empty())
        g_aliases.erase(WINDOW);
    else
        g_aliases[WINDOW] = *ALIAS;

    damageGroupbarOf(WINDOW);
    return nullptr;
}

static bool clearAlias() {
    const auto WINDOW = Desktop::focusState()->window();
    if (!WINDOW)
        return false;

    pruneDeadWindows();
    g_aliases.erase(WINDOW);
    damageGroupbarOf(WINDOW);
    return true;
}

//
// API Lua: hl.plugin.group_alias.*
//

static int luaSet(lua_State* L) {
    const char* err = nullptr;

    {
        if (lua_type(L, 1) != LUA_TSTRING)
            err = "group_alias.set: atteso un argomento string";
        else {
            size_t      len = 0;
            const char* raw = lua_tolstring(L, 1, &len);
            err             = applyAlias(raw, len);
        }
    }

    if (err)
        return luaL_error(L, "%s", err);

    lua_pushboolean(L, 1);
    return 1;
}

static int luaGet(lua_State* L) {
    bool        found = false;
    std::string alias;

    {
        const auto WINDOW = Desktop::focusState()->window();
        if (WINDOW) {
            if (const auto ALIAS = aliasFor(WINDOW); ALIAS) {
                alias = *ALIAS;
                found = true;
            }
        }
    }

    if (!found) {
        lua_pushnil(L);
        return 1;
    }

    lua_pushlstring(L, alias.c_str(), alias.size());
    return 1;
}

static int luaClear(lua_State* L) {
    const bool OK = clearAlias();
    lua_pushboolean(L, OK ? 1 : 0);
    return 1;
}

static int luaHas(lua_State* L) {
    bool has = false;

    {
        const auto WINDOW = Desktop::focusState()->window();
        has               = WINDOW && aliasFor(WINDOW).has_value();
    }

    lua_pushboolean(L, has ? 1 : 0);
    return 1;
}

//
// comando hyprctl: hyprctl groupalias <set|clear|get|toggle> [alias]
//
// Con la config Lua i dispatcher registrati da un plugin non sono raggiungibili:
// `hyprctl dispatch` e' un wrapper di hl.dispatch(), che accetta solo i dispatcher
// tipizzati di hl.dsp. Un comando hyprctl e' invece accessibile da shell senza
// dover interpolare l'alias dentro una stringa Lua.
//

static SP<SHyprCtlCommand> g_hyprctlCommand;

static std::string         hyprctlGroupAlias(eHyprCtlOutputFormat format, std::string request) {
    static const std::string COMMAND = "groupalias";

    std::string              rest = request.substr(std::min(COMMAND.size(), request.size()));
    if (const auto FIRST = rest.find_first_not_of(' '); FIRST != std::string::npos)
        rest = rest.substr(FIRST);
    else
        rest.clear();

    const auto        SPACE = rest.find(' ');
    const std::string SUB   = rest.substr(0, SPACE);
    const std::string ARG   = SPACE == std::string::npos ? "" : rest.substr(SPACE + 1);

    if (SUB == "set") {
        if (const auto* ERR = applyAlias(ARG.c_str(), ARG.size()); ERR)
            return std::string{"error: "} + ERR;
        return "ok";
    }

    if (SUB == "clear")
        return clearAlias() ? "ok" : "error: nessuna finestra attiva";

    if (SUB == "get") {
        const auto WINDOW = Desktop::focusState()->window();
        const auto ALIAS  = WINDOW ? aliasFor(WINDOW) : std::nullopt;
        return ALIAS.value_or("") + "\n";
    }

    if (SUB == "toggle") {
        const auto WINDOW = Desktop::focusState()->window();
        if (!WINDOW)
            return "error: nessuna finestra attiva";

        if (aliasFor(WINDOW))
            return clearAlias() ? "ok" : "error: nessuna finestra attiva";

        if (const auto* ERR = applyAlias(ARG.c_str(), ARG.size()); ERR)
            return std::string{"error: "} + ERR;
        return "ok";
    }

    return "usage: hyprctl groupalias <set|clear|get|toggle> [alias]";
}

//
// entry points
//

APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    const std::string HASH = __hyprland_api_get_hash();

    if (HASH != __hyprland_api_get_client_hash()) {
        HyprlandAPI::addNotification(PHANDLE, "[group-alias] compilato per un'altra versione di Hyprland: ricompila il plugin.",
                                     CHyprColor{1.0, 0.2, 0.2, 1.0}, 8000);
        throw std::runtime_error("[group-alias] version mismatch");
    }

    // match sul nome mangled: non dipende dall'output del demangler
    static const auto DRAW_FNS = HyprlandAPI::findFunctionsByName(PHANDLE, "CHyprGroupBarDecoration4draw");
    if (DRAW_FNS.empty())
        throw std::runtime_error("[group-alias] CHyprGroupBarDecoration::draw non trovato");

    g_drawHook = HyprlandAPI::createFunctionHook(PHANDLE, DRAW_FNS[0].address, reinterpret_cast<void*>(&hkDraw));

    if (!g_drawHook->hook())
        throw std::runtime_error("[group-alias] impossibile installare l'hook su CHyprGroupBarDecoration::draw");

    HyprlandAPI::addLuaFunction(PHANDLE, "group_alias", "set", &luaSet);
    HyprlandAPI::addLuaFunction(PHANDLE, "group_alias", "get", &luaGet);
    HyprlandAPI::addLuaFunction(PHANDLE, "group_alias", "clear", &luaClear);
    HyprlandAPI::addLuaFunction(PHANDLE, "group_alias", "has", &luaHas);

    g_hyprctlCommand = HyprlandAPI::registerHyprCtlCommand(PHANDLE, SHyprCtlCommand{.name = "groupalias", .exact = false, .fn = hyprctlGroupAlias});

    return {"group-alias", "Alias visuali per i titoli della groupbar", "ichelema", "0.1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    if (g_hyprctlCommand) {
        HyprlandAPI::unregisterHyprCtlCommand(PHANDLE, g_hyprctlCommand);
        g_hyprctlCommand.reset();
    }

    const auto ALIASED = g_aliases;
    g_aliases.clear();

    // groupbar ridisegnate con i titoli reali
    for (const auto& [ref, _] : ALIASED)
        damageGroupbarOf(ref.lock());
}

# group-alias

Plugin Hyprland che assegna un **alias visuale** alle finestre: la groupbar mostra l'alias
al posto del titolo della finestra. Durante il disegno il titolo interno viene
scambiato temporaneamente con l'alias e poi ripristinato; i titoli originali
restano disponibili tramite IPC (verificato con `hyprctl clients`).
Il compromesso è descritto in "Come funziona".

Verificato live su **Hyprland 0.56.2**,
commit `efb50993780079460b0cbed1363e2166a2de1d9f`.

## Build

Servono gli header di Hyprland (`/usr/include/hyprland`, pacchetto `hyprland` su Arch) e `lua`.

```sh
make
# produce build/group-alias.so
```

`cmake` non è richiesto; il `CMakeLists.txt` è incluso per chi preferisce quella toolchain.
Il Makefile traccia anche gli header di sistema: un loro aggiornamento provoca
la ricompilazione. Non ricompilare mentre il plugin è caricato: scaricarlo
prima, come indicato sotto.

## Caricamento

```sh
hyprctl plugin load "$HOME/.config/hypr/plugins/group-alias/build/group-alias.so"
hyprctl plugin unload "$HOME/.config/hypr/plugins/group-alias/build/group-alias.so"
```

Il path deve essere assoluto. Per caricarlo a ogni avvio, in `hyprland.lua`:

```lua
hl.plugin.load(os.getenv("HOME") .. "/.config/hypr/plugins/group-alias/build/group-alias.so")
```

Questa chiamata è già presente nella configurazione locale. Il caricamento avviene
alla fine del reload, senza duplicare il plugin. Il vecchio esempio con
`hl.exec_once` non è valido in 0.56.2.

Nella configurazione locale: **Super+G**, poi **R** apre il prompt Walker;
**Super+G**, poi **Shift+R** cancella l'alias.
Il prompt controlla l'elenco JSON dei plugin: un comando hyprctl sconosciuto
può restituire `unknown request` con exit code 0, quindi il solo codice di
uscita non basta.

## Uso da Lua

```lua
hl.bind("SUPER + SHIFT + E", function()
    hl.plugin.group_alias.set("Editor")
end)

hl.bind("SUPER + SHIFT + BACKSPACE", function()
    hl.plugin.group_alias.clear()
end)
```

| funzione | ritorna | note |
| --- | --- | --- |
| `hl.plugin.group_alias.set(alias)` | `true` | errore Lua se non c'è finestra attiva o l'argomento non è una stringa. Stringa vuota = `clear` |
| `hl.plugin.group_alias.get()` | `string` o `nil` | |
| `hl.plugin.group_alias.clear()` | `boolean` | idempotente |
| `hl.plugin.group_alias.has()` | `boolean` | |

Il plugin potrebbe non essere ancora caricato quando la config viene letta, quindi conviene
proteggere le chiamate fatte a livello di file (non serve dentro un bind):

```lua
if hl.plugin.group_alias ~= nil then
    -- ...
end
```

## Uso da shell

```sh
hyprctl groupalias set Editor Ruby
hyprctl groupalias get
hyprctl groupalias toggle Editor   # set se non c'è alias, clear se c'è
hyprctl groupalias clear
```

**`hyprctl dispatch groupalias:...` non esiste.** Con la config Lua, `hyprctl dispatch` è un
wrapper di `hl.dispatch()`, che accetta solo i dispatcher tipizzati di `hl.dsp`: un dispatcher
registrato da un plugin con `addDispatcherV2` non sarebbe raggiungibile né da shell né da Lua.
Per questo il plugin registra un comando hyprctl invece di un dispatcher.

## Comportamento

- L'alias vive quanto la finestra: gli aggiornamenti di titolo fatti dal client non lo toccano.
- Dopo `clear` la groupbar mostra il titolo reale **più recente**, non quello di quando l'alias fu creato.
- L'alias si può assegnare anche a una finestra non ancora raggruppata: comparirà quando entrerà in un gruppo.
- Alias vuoto o di soli spazi equivale a `clear`; spazi iniziali/finali vengono rimossi; newline e tab diventano spazi.
- Lunghezza massima 256 byte, troncati senza spezzare sequenze UTF-8.
- Alla chiusura di una finestra la voce diventa un weak pointer scaduto e viene rimossa alla successiva `set`/`clear`.
- Funziona identico su finestre Wayland native e XWayland.

## Come funziona

Un solo function hook, su `CHyprGroupBarDecoration::draw(PHLMONITOR, const float&)`.

Per la sola durata di quella chiamata i titoli delle finestre con alias vengono scambiati
(`std::swap`, nessuna allocazione) con i rispettivi alias; alla fine vengono ripristinati da un
guard RAII, anche in caso di eccezione.

Lo scambio avviene prima della `draw` — e non dentro `CTitleTex` — perché la groupbar tiene una
cache intra-frame delle texture indicizzata sul titolo: due finestre con lo stesso titolo reale
condividerebbero la texture anche avendo alias diversi. Scambiando il titolo prima, la chiave
della cache è già l'alias e resta coerente.

Non serve invalidare texture: `draw()` chiama `invalidateTextures()` a fine frame, quindi le
texture dei titoli vengono ricostruite a ogni frame. Dopo `set`/`clear` basta un
`damageEntire()` sulla decorazione groupbar delle finestre del gruppo.

### Internals di Hyprland usati

| simbolo | uso |
| --- | --- |
| `CHyprGroupBarDecoration::draw` | punto di hook (non è API pubblica) |
| `CWindow::m_title` | scambiato temporaneamente con l'alias |
| `CWindow::m_group`, `CGroup::windows()` | trovare le finestre del gruppo da ridisegnare |
| `CWindow::getDecorationByType(DECORATION_GROUPBAR)` | damage mirato |
| `Desktop::focusState()->window()` | risoluzione della finestra attiva |

## Compatibilità e aggiornamenti

Il plugin rifiuta di caricarsi se l'ABI di Hyprland non coincide con quella degli header con cui
è stato compilato (confronto `__hyprland_api_get_hash()` / `__hyprland_api_get_client_hash()`).

Dopo un aggiornamento di Hyprland:

```sh
hyprctl plugin unload "$PWD/build/group-alias.so"
make
hyprctl plugin load "$PWD/build/group-alias.so"
```

Se `PLUGIN_INIT` fallisce con "CHyprGroupBarDecoration::draw non trovato", quella versione ha
rinominato o rimosso il simbolo: verificarlo con
`nm -D -j /usr/bin/Hyprland | grep GroupBarDecoration` e aggiornare la stringa in `PLUGIN_INIT`.
Va ricontrollato anche che `draw()` continui a leggere `m_title` e a invalidare le texture a fine frame.

Il flag `-fno-gnu-unique` non è opzionale: senza, il `.so` esporta simboli `STB_GNU_UNIQUE` e
glibc non lo scarica mai con `dlclose`, per cui un `plugin unload` seguito da `plugin load` dello
stesso path continuerebbe a eseguire il codice vecchio.

## Test manuali eseguiti

Test originari su Hyprland 0.56.0, con verifica a screenshot della groupbar:

1. Alias su finestra in gruppo: la groupbar mostra l'alias, `hyprctl clients` il titolo reale.
2. Titolo dinamico: il client aggiorna il titolo, la groupbar continua a mostrare l'alias.
3. `clear`: la groupbar torna al titolo reale corrente; `clear` ripetuto non dà errore.
4. Due finestre con titolo identico nello stesso gruppo, una sola con alias: nessuna collisione di texture.
5. XWayland (`env -u WAYLAND_DISPLAY kitty`): identico al caso Wayland nativo.
6. Unicode (`Editor 🦊 日本語 α`): reso correttamente.
7. Trim degli spazi e alias vuoto trattato come `clear`.
8. Chiusura di una finestra con alias: nessun crash.
9. `hyprctl reload`: il plugin resta caricato e funzionante.
10. `plugin unload`: le groupbar tornano ai titoli reali, il comando hyprctl viene deregistrato, nessun crash.

### Verifica dell'aggiornamento a 0.56.2

Ripetuti live: alias via shell e Lua, due titoli identici con alias diversi,
Unicode, aggiornamento del titolo reale, `clear` idempotente, conservazione
dopo reload, unload/load e finestra XWayland. Titoli IPC originali verificati
e screenshot della groupbar acquisiti. Provato anche il prompt Walker reale,
avviando direttamente `bin/group-alias-prompt`.
I binding R/Shift+R risultano registrati; la pressione fisica delle scorciatoie
non è stata verificata: il tentativo con tastiera virtuale `wtype` non attivava
Super+G.

Regressione automatica del prompt (IPC e Walker simulati, nessuna finestra reale):

```sh
ruby tests/prompt.rb
```

# Layout a tre zone (ultrawide)

`| browser 36% | finestra singola o gruppo 47% | dolphin 17% |` — deterministico:
zone fisse anche se vuote, l'ordine di apertura non conta.

## Componenti

| File | Ruolo |
|---|---|
| `three-zone.conf` (radice repo) | config condivisa: monitor, workspace, percentuali, classi |
| `layouts/three-zone.lua` | layout Lua `lua:threezone` — solo geometria, niente gruppi |
| `bin/center-group-daemon` | demone (socket2): crea/mantiene il gruppo della zona centrale |
| `bin/center-window-switcher` | SUPER+TAB: overlay walker delle finestre centrali (ordine MRU) |
| `bin/center-group-reset` | SUPER+SHIFT+G: ricostruisce il gruppo; `--adopt` rimette in tiling le float note |
| `~/.config/systemd/user/hypr-center-group.service` | supervisione demone (fuori repo) |

Il layout è applicato ai workspace di `THREE_ZONE_WORKSPACES` via
`hl.workspace_rule` in `hyprland.lua`; gli altri workspace restano su dwindle.
Navigazione nel gruppo: SUPER+ALT+Right/Left (bind già esistenti).

## Installazione / gestione

```bash
systemctl --user enable --now hypr-center-group.service   # una tantum
journalctl --user -u hypr-center-group.service -f          # log
```

`three-zone.conf` è **hot reload**: percentuali e classi si applicano da sole
entro ~2s (il demone controlla l'mtime e forza il ricalcolo del layout con un
`layout_msg`; il layout rilegge il file a ogni recalculate). Unica eccezione:
`THREE_ZONE_WORKSPACES` richiede `hyprctl reload`, perché le workspace rule si
registrano al caricamento della config.

Migrazione di una sessione con finestre ancora floating (vecchio layout float):
`center-group-reset --adopt`.

## Test rapido

Aggiungere temporaneamente `9` a `THREE_ZONE_WORKSPACES`, reload, e su ws9:
`kitty --class vivaldi-stable` (sinistra), `kitty` ×2 (centro: alla seconda
nasce il gruppo), `kitty --class org.kde.dolphin` (destra).

## Vincoli legati a Hyprland 0.55.x (rileggere agli aggiornamenti)

- I box del layout Lua devono essere **contigui**: i gap visivi li mette
  `general:gaps_in`; un gap nei box logici rompe focus direzionale e
  `move into_group` (soglia di adiacenza 2px in `getWindowInDirection`).
- `layout:single_window_aspect_ratio` deve restare `{0,0}`: viene applicato dal
  target sopra il layout col singolo tile e deformerebbe le zone.
- socket2 **non emette più `togglegroup`**: il demone deduce l'ungroup manuale
  dal confronto di stato e usa gli eventi `moveintogroup`/`moveoutofgroup`.
- I dispatcher da CLI passano da `hyprctl eval "hl.dispatch(hl.dsp....)"`.

# Piano: passaggio da qt6ct a hyprqt6engine

## Obiettivo e perimetro

Sostituire il provider Qt6 mantenendo Kvantum, riprodurre inizialmente
l'aspetto attuale e collegare la configurazione Qt al cambio temi esistente.

Questo documento è un piano: non autorizza né esegue installazioni,
modifiche della sessione o riavvii delle applicazioni.

La raccomandazione emersa dalla verifica è restare per ora con qt6ct:
il cambio temi Qt è incompleto nella configurazione locale e la migrazione
non lo risolve da sola. Procedere se si desiderano specificamente
la configurazione Hyprland e il supporto KDE/KColorScheme, accettando
i limiti descritti sotto.

## Stato iniziale verificato

- Tema attivo: `~/.config/hypr/themes/my-theme`.
- Provider: `qt6ct`, impostato in due punti:
  - `~/.config/uwsm/env-hyprland.d/00-hyperlandia.sh:12`;
  - `~/.config/hypr/hyprland.lua:65`.
- `~/.config/qt6ct/qt6ct.conf` seleziona:
  - stile `kvantum`;
  - palette `~/.config/qt6ct/style-colors.conf`;
  - icone `Papirus-Dark`;
  - font generale `CaskaydiaCove Nerd Font`, dimensione 8;
  - font fisso `CaskaydiaCove Nerd Font Mono`, dimensione 8.
- `~/.config/Kvantum/kvantum.kvconfig` seleziona `Nordic-bluish`.
- `~/.config/kdeglobals` è collegato al tema attivo.
- `QT_STYLE_OVERRIDE` non risulta impostato.
- qt5ct e il supporto Kvantum per Qt5 sono installati; non è stato accertato
  quali applicazioni Qt5 siano effettivamente utilizzate.

I numeri di riga e le versioni sono indicativi dello stato ispezionato:
ricontrollarli prima dell'implementazione.

## Problema attuale del cambio temi

Il menu richiama `~/.config/hypr/bin/theme-set`, che:

1. Aggiorna il collegamento `themes/current/theme`.
2. Aggiorna sfondo, barra, terminali e altri componenti.
3. Ricarica Hyprland e applica le impostazioni GNOME del tema.
4. Termina e riavvia Dolphin e Krusader, se in esecuzione.

Lo script non applica i file `qt6ct.conf` e `kvantum/kvantum.kvconfig`
presenti nelle cartelle dei temi. La configurazione Qt6 e quella Kvantum
restano quindi statiche, mentre `kdeglobals` segue il tema attivo.

I temi alternativi esaminati hanno un percorso palette qt6ct vuoto:
non basta convertirne automaticamente le configurazioni per ottenere
palette complete. Anche il `kdeglobals` di `my-theme` contiene solo
impostazioni colore parziali, non una palette completa da riutilizzare
senza verifica.

## Vincoli della migrazione

- hyprqt6engine sostituisce il provider Qt6, non Kvantum né qt5ct.
- Accetta palette qt6ct oppure KColorScheme.
- Nel codice verificato non è presente una rilettura automatica della
  configurazione nelle applicazioni già aperte. La richiesta di hot reload
  è ancora aperta.
- Sono presenti segnalazioni di differenze nella resa Kvantum e problemi
  con la selezione dello stile: occorre una prova locale.
- Non tutte le opzioni qt6ct hanno un equivalente. Per esempio,
  `wheel_scroll_lines=4` è attualmente configurato in qt6ct, mentre il codice
  hyprqt6engine verificato restituisce 3 senza un'opzione dedicata.
- Cambiare la variabile nella sessione non cambia il provider delle
  applicazioni già avviate.
- Non concatenare provider Qt5 e Qt6 in `QT_QPA_PLATFORMTHEME`:
  non è una lista di fallback.

## Fase 1: backup e disponibilità del pacchetto

1. Ricontrollare configurazioni, collegamenti e tema attivo.
2. Creare un backup `.bak` di ogni file esistente che verrà modificato,
   prima di modificarlo. Se il backup esiste già, sovrascriverlo.
3. Per i collegamenti simbolici preservare il collegamento stesso,
   annotandone la destinazione; non salvare soltanto il contenuto risolto.
4. Registrare quali percorsi verranno creati ex novo, per il rollback.
5. Ricontrollare disponibilità, versione e dipendenze di hyprqt6engine.

Alla verifica, il pacchetto non era disponibile nei database pacman
configurati; AUR pubblicava `hyprqt6engine` versione `0.1.0-4`,
senza conflitto dichiarato con qt6ct.

Preferire il pacchetto stabile e ispezionarne il PKGBUILD prima
dell'installazione. Non usare la variante `-git` senza necessità.
Mantenere installati qt6ct, qt5ct e Kvantum.

**Verifica:** backup ripristinabili, dipendenze compatibili e nessuna
rimozione non prevista. Fermarsi se l'installazione richiede sostituzioni
di pacchetti fuori perimetro.

## Fase 2: riprodurre l'aspetto attuale e provare il provider

Creare `~/.config/hypr/hyprqt6engine.conf` con:

```ini
theme {
    color_scheme = /home/ichelema/.config/qt6ct/style-colors.conf
    icon_theme = Papirus-Dark
    style = kvantum
    font = CaskaydiaCove Nerd Font
    font_size = 8
    font_fixed = CaskaydiaCove Nerd Font Mono
    font_fixed_size = 8
}

misc {
    single_click_activate = true
    menus_have_icons = true
    shortcuts_for_context_menus = true
}
```

La palette può restare nel percorso attuale: non è necessario spostarla
per cambiare provider.

Provare una singola applicazione Qt6 completamente chiusa,
senza modificare ancora l'ambiente globale. Esempio:

```sh
env QT_QPA_PLATFORMTHEME=hyprqt6engine dolphin
```

Chiudere prima l'applicazione in modo ordinario, salvando il lavoro.
Un'istanza già aperta potrebbe ricevere la richiesta senza caricare
il nuovo provider, rendendo il test non significativo.

Se necessario, usare temporaneamente `QT_DEBUG_PLUGINS=1` per verificare
il caricamento del plugin. Conservare i log diagnostici soltanto nello
scratch previsto dalle istruzioni locali, senza segreti.

Confrontare Dolphin e Double Commander con il comportamento precedente:

- font e dimensioni;
- icone e contrasto;
- palette, selezioni e menu;
- stile Kvantum;
- finestre di dialogo e attivazione con clic singolo.

Non aggiungere preventivamente `QT_STYLE_OVERRIDE`: prima verificare
che `style = kvantum` funzioni.

**Verifica:** plugin effettivamente caricato, nessun errore di
configurazione e resa accettabile. In caso contrario, non proseguire
con il cambio globale.

## Fase 3: integrare i temi senza generatori

Riutilizzare il collegamento `themes/current/theme`, già gestito dallo
switcher, senza aggiungere demoni, conversioni a ogni cambio o nuovi
meccanismi di ricarica.

1. Aggiungere un `hyprqt6engine.conf` completo in ogni tema selezionabile.
2. Per ciascun tema verificare palette, icone e sottotema Kvantum:
   i nomi presenti nei vecchi file non garantiscono che le risorse
   siano installate o corrette per una variante chiara/scura.
3. Riutilizzare palette valide esistenti; dove mancano, scegliere una
   palette coerente e verificarla, senza inventare una conversione
   dai file incompleti.
4. Usare percorsi assoluti per `color_scheme`, eventualmente attraverso
   il collegamento al tema attivo.
5. Dopo i backup, creare questi collegamenti:

```text
~/.config/hypr/hyprqt6engine.conf
  -> ~/.config/hypr/themes/current/theme/hyprqt6engine.conf

~/.config/Kvantum/kvantum.kvconfig
  -> ~/.config/hypr/themes/current/theme/kvantum/kvantum.kvconfig
```

Mantenere il collegamento esistente di `~/.config/kdeglobals`.
La configurazione completa per tema evita di dipendere da funzionalità
di inclusione non verificate.

Prima di attivare i collegamenti, assicurarsi che tutti i temi
selezionabili abbiano i file necessari. Modificare `theme-set` soltanto
se serve un controllo minimo dei file prima di cambiare il tema:
non riscriverne il flusso.

**Verifica:** tutti i collegamenti risolvono file validi; il passaggio
scuro → chiaro → scuro cambia palette, icone e Kvantum nelle
applicazioni riaperte, senza alterare gli altri componenti.

## Fase 4: rendere UWSM l'unica fonte del provider

In `~/.config/uwsm/env-hyprland.d/00-hyperlandia.sh` sostituire
l'assegnazione attuale con:

```sh
export QT_QPA_PLATFORMTHEME=hyprqt6engine
```

Usare un'assegnazione esplicita: la forma `${VAR:-valore}` conserverebbe
un eventuale valore precedente già presente nell'ambiente.

In `~/.config/hypr/hyprland.lua` rimuovere soltanto:

```lua
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
```

Aggiornare il commento Qt pertinente in UWSM. Non modificare le altre
variabili, lo scaling o il backend `wayland;xcb`. Mantenere gli import
esistenti verso systemd e D-Bus.

Eseguire un logout/login concordato, dopo aver salvato il lavoro.
Un semplice `hyprctl reload` non sostituisce la nuova sessione.

**Verifica:** `QT_QPA_PLATFORMTHEME=hyprqt6engine` nell'ambiente della
sessione, nell'ambiente systemd utente e nelle nuove applicazioni
avviate sia dal terminale sia dal launcher.

## Fase 5: riavvii, Qt5 e collaudo finale

Lo switcher riavvia già Dolphin e Krusader tramite `restart-app`,
che usa `pkill`. Non estendere automaticamente questa pratica ad altre
applicazioni: può interrompere operazioni o lavoro non salvato.

Le altre applicazioni Qt6 aperte dovranno essere chiuse e riaperte
manualmente per applicare completamente la nuova configurazione.

Se vengono individuate applicazioni Qt5 realmente utilizzate,
configurare un override per quelle applicazioni:

```sh
env QT_QPA_PLATFORMTHEME=qt5ct applicazione-qt5
```

Non creare wrapper o modificare launcher finché non esiste
un'applicazione concreta che ne abbia bisogno.

### Criteri di accettazione

- UWSM è l'unico punto di assegnazione del provider.
- Il plugin hyprqt6engine viene caricato dalle applicazioni Qt6 di prova.
- L'aspetto iniziale è accettabile rispetto alla configurazione qt6ct.
- Tutti i temi selezionabili hanno configurazioni e risorse valide.
- Il cambio scuro/chiaro funziona nelle applicazioni riaperte.
- GTK, terminali, barra e altri componenti non subiscono regressioni.
- Non vengono aggiunte terminazioni automatiche di applicazioni.
- Le eventuali applicazioni Qt5 mantengono il comportamento previsto.
- Le differenze non riproducibili rispetto a qt6ct vengono documentate.

Validare i file modificati con gli strumenti previsti localmente:
controllo sintattico e lint shell, `luac -p` e `luacheck` per Lua,
`markdownlint-cli2` per il documento. Separare eventuali errori
preesistenti da quelli introdotti, senza correggere codice estraneo.

Per hyprqt6engine verificare il parsing tramite un'applicazione di prova
e i relativi messaggi: non presumere l'esistenza di un comando standalone
di validazione. Mostrare il diff di tutte le modifiche.

## Rollback

1. Salvare il lavoro e chiudere ordinariamente le applicazioni di prova.
2. Ripristinare dai backup le configurazioni e i collegamenti modificati,
   inclusi UWSM, `hyprland.lua`, Kvantum ed eventualmente `theme-set`.
3. Ripristinare il tema iniziale se è stato cambiato durante le prove.
4. Rimuovere solo i file creati per la migrazione, previa conferma;
   non cancellare palette o risorse condivise.
5. Verificare che il provider sia nuovamente `qt6ct`.
6. Eseguire logout/login e ricontrollare Dolphin e Double Commander.

Non è necessario disinstallare hyprqt6engine per disattivarlo.
Non disinstallare qt6ct durante il collaudo: mantiene semplice il rollback.

## Fonti

- [Guida ufficiale hyprqt6engine](https://wiki.hypr.land/Hypr-Ecosystem/hyprqt6engine/)
- [Codice hyprqt6engine](https://github.com/hyprwm/hyprqt6engine)
- [Richiesta hot reload #9](https://github.com/hyprwm/hyprqt6engine/issues/9)
- [Segnalazione Kvantum #7](https://github.com/hyprwm/hyprqt6engine/issues/7)
- [Segnalazione selezione stile #10](https://github.com/hyprwm/hyprqt6engine/issues/10)
- [Pacchetto AUR stabile](https://aur.archlinux.org/packages/hyprqt6engine)
- [Documentazione UWSM](https://github.com/Vladimir-csp/uwsm)

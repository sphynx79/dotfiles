#!/usr/bin/env bash
# Gestione clipboard con cliphist + walker (riscrittura senza dipendenze HyDE
# del vecchio cliphist.sh rofi; stessa interfaccia usata dal widget waybar).
#
#   cliphist.sh -c | --copy            cronologia (provider clipboard nativo di walker)
#   cliphist.sh -d | --delete          elimina voci dalla cronologia (Esc per finire)
#   cliphist.sh -f | --favorites       mostra e copia un preferito
#   cliphist.sh -mf | "Manage Favorites"  aggiungi/rimuovi/svuota preferiti
#   cliphist.sh -w | --wipe            svuota la cronologia (con conferma)
#
# I preferiti sono righe base64 in $XDG_STATE_HOME/hypr/cliphist_favorites.
set -euo pipefail

favorites_file="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/cliphist_favorites"
mkdir -p "$(dirname "$favorites_file")"

# dmenu di walker: selezione per INDICE (mai per testo, i titoli possono ripetersi)
menu() {
    walker --dmenu --index -N -t menus -p "$1"
}

confirm() {
    local ans
    ans=$(printf 'No\nYes' | menu "$1") || return 1
    [[ "$ans" == "1" ]]
}

# indice scelto dall'utente su `cliphist list` -> riga completa (id\ttesto)
pick_from_history() {
    local placeholder="$1" lines idx
    mapfile -t lines < <(cliphist list)
    [[ ${#lines[@]} -eq 0 ]] && { notify-send "Clipboard" "Cronologia vuota"; return 1; }
    idx=$(printf '%s\n' "${lines[@]}" | cut -f2- | menu "$placeholder") || return 1
    [[ "$idx" =~ ^[0-9]+$ ]] || return 1
    printf '%s' "${lines[$idx]}"
}

show_history() {
    # provider nativo: anteprime immagini, ricerca, copia alla selezione
    exec walker -m clipboard -N
}

delete_items() {
    local line
    while line=$(pick_from_history " Elimina (Esc per finire)"); do
        cliphist delete <<<"$line"
        notify-send "Clipboard" "Voce eliminata"
    done
}

wipe_history() {
    if confirm "☢ Svuotare la cronologia?"; then
        cliphist wipe
        notify-send "Clipboard" "Cronologia svuotata"
    fi
}

# --- preferiti -----------------------------------------------------------

# popola gli array favorites (base64) e decoded (una riga per voce)
load_favorites() {
    favorites=()
    decoded=()
    [[ -s "$favorites_file" ]] || return 1
    mapfile -t favorites <"$favorites_file"
    local fav
    for fav in "${favorites[@]}"; do
        decoded+=("$(base64 --decode <<<"$fav" | tr '\n' ' ')")
    done
}

view_favorites() {
    load_favorites || { notify-send "Clipboard" "Nessun preferito"; return; }
    local idx
    idx=$(printf '%s\n' "${decoded[@]}" | menu "󰐃 Preferiti") || return 0
    [[ "$idx" =~ ^[0-9]+$ ]] || return 0
    base64 --decode <<<"${favorites[$idx]}" | wl-copy
    notify-send "Clipboard" "Preferito copiato"
}

add_favorite() {
    local line encoded
    line=$(pick_from_history "󰐃 Aggiungi ai preferiti") || return 0
    encoded=$(cliphist decode <<<"$line" | base64 -w 0)
    if [[ -f "$favorites_file" ]] && grep -Fxq "$encoded" "$favorites_file"; then
        notify-send "Clipboard" "Già nei preferiti"
    else
        echo "$encoded" >>"$favorites_file"
        notify-send "Clipboard" "Aggiunto ai preferiti"
    fi
}

remove_favorite() {
    load_favorites || { notify-send "Clipboard" "Nessun preferito"; return; }
    local idx
    idx=$(printf '%s\n' "${decoded[@]}" | menu "󰐃 Rimuovi preferito") || return 0
    [[ "$idx" =~ ^[0-9]+$ ]] || return 0
    unset 'favorites[idx]'
    printf '%s\n' "${favorites[@]}" >"$favorites_file"
    notify-send "Clipboard" "Preferito rimosso"
}

clear_favorites() {
    [[ -s "$favorites_file" ]] || { notify-send "Clipboard" "Nessun preferito"; return; }
    if confirm "☢ Cancellare tutti i preferiti?"; then
        : >"$favorites_file"
        notify-send "Clipboard" "Preferiti cancellati"
    fi
}

manage_favorites() {
    local idx
    idx=$(printf 'Aggiungi ai preferiti\nRimuovi preferito\nCancella tutti\n' \
        | menu "󰐃 Gestione preferiti") || return 0
    case "$idx" in
    0) add_favorite ;;
    1) remove_favorite ;;
    2) clear_favorites ;;
    esac
}

# --- main ----------------------------------------------------------------

case "${1:-}" in
-c | --copy | "" | History) show_history ;;
-d | --delete | Delete) delete_items ;;
-f | --favorites | "View Favorites") view_favorites ;;
-mf | -manage-fav | "Manage Favorites") manage_favorites ;;
-w | --wipe | "Clear History") wipe_history ;;
*) sed -n '2,12p' "$0" | sed 's/^# \?//' ;;
esac

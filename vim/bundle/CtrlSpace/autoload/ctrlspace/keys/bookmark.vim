let s:config = ctrlspace#context#Configuration()
let s:modes  = ctrlspace#modes#Modes()

function! ctrlspace#keys#bookmark#Init()
    call ctrlspace#keys#AddMapping("ctrlspace#keys#bookmark#GoToBookmark", "Bookmark", ["Tab", "CR", "Space"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#bookmark#Rename", "Bookmark", ["=", "m"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#bookmark#Edit", "Bookmark", ["e"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#bookmark#Add", "Bookmark", ["a", "A"])
    call ctrlspace#keys#AddMapping("ctrlspace#keys#bookmark#Delete", "Bookmark", ["d"])
endfunction

function! ctrlspace#keys#bookmark#GoToBookmark(k)
    let nr = ctrlspace#window#SelectedIndex()

    call ctrlspace#window#Kill(0, 1)
    call ctrlspace#bookmarks#GoToBookmark(nr)

    if a:k ==# "CR"
        call ctrlspace#window#Toggle(0)
    elseif a:k ==# "Space"
        call ctrlspace#window#Toggle(0)
        call ctrlspace#window#Kill(0, 0)
        call s:modes.Bookmark.Enable()
        call ctrlspace#window#Toggle(1)
    endif

    call ctrlspace#ui#DelayedMsg()
endfunction

function! ctrlspace#keys#bookmark#Rename(k)
    let curline = line(".")
    let nr = ctrlspace#window#SelectedIndex()
    call ctrlspace#bookmarks#ChangeBookmarkName(nr)
    call ctrlspace#window#Kill(0, 0)
    call ctrlspace#window#Toggle(1)
    call ctrlspace#window#MoveSelectionBar(curline)
    call ctrlspace#ui#DelayedMsg()
endfunction

function! ctrlspace#keys#bookmark#Edit(k)
    let curline = line(".")
    let nr = ctrlspace#window#SelectedIndex()

    if ctrlspace#bookmarks#ChangeBookmarkDirectory(nr)
        call ctrlspace#window#Kill(0, 1)
        call ctrlspace#window#Toggle(0)
        call ctrlspace#window#Kill(0, 0)
        call s:modes.Bookmark.Enable()
        call ctrlspace#window#Toggle(1)
        call ctrlspace#window#MoveSelectionBar(curline)
        call ctrlspace#ui#DelayedMsg()
    endif
endfunction

function! ctrlspace#keys#bookmark#Add(k)
    let nr = (a:k ==# "a") ? ctrlspace#window#SelectedIndex() : 0

    if ctrlspace#bookmarks#AddNewBookmark(nr)
        call ctrlspace#window#Kill(0, 1)
        call ctrlspace#window#Toggle(0)
        call ctrlspace#window#Kill(0, 0)
        call s:modes.Bookmark.Enable()
        call ctrlspace#window#Toggle(1)
        call ctrlspace#ui#DelayedMsg()
    endif
endfunction

function! ctrlspace#keys#bookmark#Delete(k)
    let nr = ctrlspace#window#SelectedIndex()
    call ctrlspace#bookmarks#RemoveBookmark(nr)
    call ctrlspace#window#Kill(0, 1)
    call ctrlspace#window#Toggle(0)
    call ctrlspace#window#Kill(0, 0)
    call s:modes.Bookmark.Enable()
    call ctrlspace#window#Toggle(1)
    call ctrlspace#ui#DelayedMsg()
endfunction

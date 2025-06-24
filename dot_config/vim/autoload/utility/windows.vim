if exists('g:loaded_windows')
    finish
endif
let g:loaded_windows = 1

let s:cpo_save = &cpo
set cpo&vim

let g:paste_cmd = {'n': ":call utility#windows#Paste()<CR>"}
" Estendi la variabile per altre modalità
let g:paste_cmd['v'] = '"-c<Esc>' . g:paste_cmd['n']
let g:paste_cmd['i'] = "\<C-\\>\<C-o>\"+gP"

function! utility#windows#Paste()
  let ove = &ve
  set ve=all
  normal! `^
  if @+ != ''
    normal! "+gP
  endif
  let c = col(".")
  normal! i
  if col(".") < c	" compensate for i<ESC> moving the cursor left
    normal! l
  endif
  let &ve = ove
endfunc

function! utility#windows#setup()
    " set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
    behave mswin

    " the better solution would be to use has("clipboard_working"),
    " but that may not be available yet while starting up, so let's just check if
    " clipboard support has been compiled in and assume it will be working :/
    if has("clipboard")
        " CTRL-X and SHIFT-Del are Cut
        vnoremap <C-X> "+x
        vnoremap <S-Del> "+x

        " CTRL-C and CTRL-Insert are Copy
        vnoremap <C-C> "+y
        vnoremap <C-Insert> "+y

        " CTRL-V and SHIFT-Insert are Paste
        map <C-V>		"+gP
        map <S-Insert>		"+gP

        cmap <C-V>		<C-R>+
        cmap <S-Insert>		<C-R>+
    else
        " Use the unnamed register when clipboard support not available

        " CTRL-X and SHIFT-Del are Cut
        vnoremap <C-X>   x
        vnoremap <S-Del> x

        " CTRL-C and CTRL-Insert are Copy
        vnoremap <C-C>      y
        vnoremap <C-Insert> y

        " CTRL-V and SHIFT-Insert are Paste
        noremap <C-V>      gP
        noremap <S-Insert> gP

        inoremap <C-V>      <C-R>"
        inoremap <S-Insert> <C-R>"
    endif

    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.
    " Use CTRL-G u to have CTRL-Z only undo the paste.

    if has("clipboard")
        exe 'inoremap <script> <C-V> <C-G>u' . g:paste_cmd['i']
        exe 'vnoremap <script> <C-V> ' . g:paste_cmd['v']
    endif

    " Use CTRL-Q to do what CTRL-V used to do
    noremap <C-Q>		<C-V>

    " Use CTRL-S for saving, also in Insert mode (<C-O> doesn't work well when
    " using completions).
    noremap <C-S>		:update<CR>
    vnoremap <C-S>		<C-C>:update<CR>
    inoremap <C-S>		<Esc>:update<CR>gi

    " For CTRL-V to work autoselect must be off.
    " On Unix we have two selections, autoselect can be used.
    if !has("unix")
        set guioptions-=a
    endif

    " CTRL-A is Select all
    noremap <C-A> gggH<C-O>G
    inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
    cnoremap <C-A> <C-C>gggH<C-O>G
    onoremap <C-A> <C-C>gggH<C-O>G
    snoremap <C-A> <C-C>gggH<C-O>G
    xnoremap <C-A> <C-C>ggVG

    if has("gui")
        " CTRL-F is the search dialog
        noremap  <expr> <localleader>s has("gui_running") ? ":promptfind\<CR>" : "/"

        " CTRL-H is the replace dialog,
        " but in console, it might be backspace, so don't map it there
        nnoremap <expr> <localleader>r has("gui_running") ? ":promptrepl\<CR>" : "\<C-H>"
    endif

endfunction

set cpo&
" Ripristina il valore originale di 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

if exists('g:loaded_toggle_fold_auto')
  finish
endif
let g:loaded_toggle_fold_auto = 1

let s:cpo_save = &cpo
set cpo&vim

function! utility#togglefold#Auto() " {{{  
    if &foldclose ==# 'all'
        echom "Fold auto disable"
        set foldclose&
    else
        echom "Fold auto enabled"
        set foldclose=all
    endif
endfunction " }}}

set cpo&
" Ripristina il valore originale di 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

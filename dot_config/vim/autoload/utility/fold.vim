if exists('g:loaded_fold')
  finish
endif

let g:loaded_fold = 1

let s:cpo_save = &cpo
set cpo&vim

function! utility#fold#Custom()  " {{{
    let nucolwidth = &fdc + &number*&numberwidth
    let winwd = winwidth(0) - nucolwidth - 5
    let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
    let prefix = " _______>>> "
    let fdnfo = prefix . string(v:foldlevel) . "," . string(foldlinecount)
    let line =  strpart(getline(v:foldstart), 0 , winwd - len(fdnfo))
    let fillcharcount = winwd - len(line) - len(fdnfo)
    return line . repeat(" ",fillcharcount) . fdnfo
endfunction   " }}}

set cpo&
" Ripristina il valore originale di 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

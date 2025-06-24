let g:MyVimLib = $VIMRUNTIME.'/gvimfullscreen.dll.x64'
function ToggleFullScreen()
    call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
endfunction

nmap <F11> :call ToggleFullScreen()<CR>

let g:VimAlpha = 240
function! SetAlpha(alpha)
    let g:VimAlpha = g:VimAlpha + a:alpha
    if g:VimAlpha < 180
        let g:VimAlpha = 180
    endif
    if g:VimAlpha > 255
        let g:VimAlpha = 255
    endif
    call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endfunction


nmap <F12> :call SetAlpha(+20)<CR>

nmap <F10> <Esc>:call SetAlpha(-20)<CR>

let g:VimTopMost = 0
function! SwitchVimTopMostMode()
    if g:VimTopMost == 0
        let g:VimTopMost = 1
    else
        let g:VimTopMost = 0
    endif
    call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
endfunction

  
    " nmap <F9> <Esc>:call SwitchVimTopMostMode()<CR>

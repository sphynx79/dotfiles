" vim: set sw=2 ts=2 sts=2 et tw=120:

if exists('g:loaded_dragopen')
  finish
endif
let g:loaded_dragopen = 1

function! s:decode_uri_run(encoded) abort
  let l:bytes = []
  let l:index = 0
  while l:index < strlen(a:encoded)
    call add(l:bytes, str2nr(strpart(a:encoded, l:index + 1, 2), 16))
    let l:index += 3
  endwhile
  if index(l:bytes, 0) >= 0 || index(l:bytes, 10) >= 0 || index(l:bytes, 13) >= 0
    return "\n"
  endif
  try
    let l:characters = blob2str(list2blob(l:bytes))
  catch
    return a:encoded
  endtry
  return empty(l:characters) ? a:encoded : join(l:characters, '')
endfunction

function! s:decode_uri(text) abort
  let l:decoded = substitute(a:text, '\%(%[0-9A-Fa-f]\{2}\)\+',
        \ '\=s:decode_uri_run(submatch(0))', 'g')
  return l:decoded =~# "[\r\n]" ? '' : l:decoded
endfunction

function! s:unescape_shell(text) abort
  let l:unescaped = ''
  let l:index = 0
  let l:quote = ''
  while l:index < strlen(a:text)
    let l:character = strpart(a:text, l:index, 1)
    if l:quote ==# "'"
      if l:character ==# "'"
        let l:quote = ''
      else
        let l:unescaped .= l:character
      endif
      let l:index += 1
      continue
    elseif l:quote ==# '"'
      if l:character ==# '"'
        let l:quote = ''
      elseif l:character ==# '\' && l:index + 1 < strlen(a:text) &&
            \ strpart(a:text, l:index + 1, 1) =~# '["\\$`]'
        let l:unescaped .= strpart(a:text, l:index + 1, 1)
        let l:index += 2
        continue
      else
        let l:unescaped .= l:character
      endif
      let l:index += 1
      continue
    elseif l:character ==# "'"
      let l:quote = "'"
      let l:index += 1
      continue
    elseif l:character ==# '"'
      let l:quote = '"'
      let l:index += 1
      continue
    elseif l:character ==# '\' && l:index + 1 < strlen(a:text)
      let l:next = strpart(a:text, l:index + 1, 1)
      if l:next !~# '[[:alnum:]_./-]'
        let l:unescaped .= l:next
        let l:index += 2
        continue
      endif
    endif
    let l:unescaped .= l:character
    let l:index += 1
  endwhile
  return empty(l:quote) ? l:unescaped : a:text
endfunction

function! s:normalize_path(text) abort
  let l:path = substitute(a:text, "\r$", '', '')
  if l:path =~# "[\r\n]"
    return ''
  endif

  let l:path = s:unescape_shell(l:path)

  if l:path =~? '^file://'
    let l:path = strpart(l:path, 7)
    if l:path =~? '^localhost/'
      let l:path = strpart(l:path, 9)
    elseif l:path !~# '^/'
      return ''
    endif
    let l:path = s:decode_uri(l:path)
  endif
  return l:path
endfunction

function! s:paste_literal(text) abort
  let l:register = getreginfo('z')
  try
    let l:text = substitute(a:text, "\r\n\|\r", "\n", 'g')
    call setreg('z', split(l:text, "\n", 1), 'v')
    execute col('.') == 1 ? 'normal! "zP' : 'normal! "zp'
  finally
    if empty(l:register)
      call setreg('z', '')
    else
      call setreg('z', l:register.regcontents, l:register.regtype)
    endif
  endtry
endfunction

function! s:dragopen() abort
  let l:text = ''
  while 1
    let l:character = getcharstr()
    if l:character ==# "\<PasteEnd>"
      break
    endif
    let l:text .= l:character
  endwhile

  let l:path = s:normalize_path(l:text)
  if !empty(l:path) && (filereadable(l:path) || isdirectory(l:path))
    if isdirectory(l:path) && exists(':NERDTree') == 2
      execute 'NERDTree ' . fnameescape(l:path)
    else
      execute 'edit ' . fnameescape(l:path)
    endif
    return
  endif
  call s:paste_literal(l:text)
endfunction

nnoremap <silent> <PasteStart> :<C-U>call <SID>dragopen()<CR>

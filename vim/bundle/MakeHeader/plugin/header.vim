" FUNCTION:
" Detect filetype looking at its extension.
" VARIABLES:
" fc = firstcomment,    ex. /*
" mc = middle comments  ex.  *
" lc = last comment     ex.  */"

function s:filetype ()

   let l:ft = &ft

   if l:ft ==# 'ruby'
      let s:fc = '=begin'
      let s:mc = ''
      let s:lc = '=end'
   elseif l:ft ==# 'eruby.html'
      let s:fc = '<%#'
      let s:mc = '#',
      let s:lc = '%>'
   elseif l:ft ==# 'haml'
      let s:fc = '-#'
      let s:mc = '-#'
      let s:lc = '-#'
   else
      let s:fc = '#'
      let s:mc = '#'
      let s:lc = '#'
   endif
endfunction


" FUNCTION:
" Insert the header when we create a new file.
" VARIABLES:
" author = User who create the file.

function MakeFileHeader()

   call s:filetype ()

   set paste
   let s:author = ""
   if exists('g:header_comment_author')
      let s:author = g:header_comment_author
   else
      echohl WarningMsg | echo "g:header_comment_author is not defined in .vimrc" | echohl None
      sleep 4
   end

   let s:comment = s:fc . "\r"
   let s:comment .= "\r"
   let s:comment .= s:mc . "File Name     : " . expand('%:t') . "\r"
   let s:comment .= "\r"
   let s:comment .= s:mc . "Author        : " . s:author . "\r"
   let s:comment .= "\r"
   let s:comment .= s:mc . "Creation Date : " . strftime("%Y-%m-%d") . "\r"
   let s:comment .= "\r"
   let s:comment .= s:mc . "Last Modified : " . strftime("%d %b %Y %X") . "\r"
   let s:comment .= "\r"
   let s:comment .= s:lc . "\r"
   exec "normal i" . s:comment
   set nopaste
endfunction


" autocmd BufNewFile * call s:insert ()
" autocmd BufWritePre * call s:update ()

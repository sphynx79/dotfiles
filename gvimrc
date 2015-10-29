"  Identify platform {
silent function! OSX()
   return has('macunix')
endfunction

silent function! LINUX()
 return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
 return  (has('win16') || has('win32') || has('win64'))
endfunction
 " } Identify platform


"colorscheme zeus 
" colorscheme macvim 
colorscheme iside 
let did_install_syntax_menu = 0
if WINDOWS()
  set guifont=Sauce_Code_Powerline:h8      " Font family and font size.
elseif OSX()
  set guifont=Source\ Code\ Pro\ for\ Powerline:h13      " Font family and font size.
endif 
set antialias                     " MacVim: smooth fonts.
set encoding=utf-8                " Use UTF-8 everywhere.
set background=dark               " Background.
set lines=25 columns=100          " Window dimensions.
set cmdheight=1
set mouse=a
set nomousefocus
set mousehide
set linespace=1
" Uncomment to use.
" set guioptions-=r                 " Don't show right scrollbar



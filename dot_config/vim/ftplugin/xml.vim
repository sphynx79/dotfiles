if (exists("b:xml_ftplugin"))
  finish
endif
let b:xml_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2> nul

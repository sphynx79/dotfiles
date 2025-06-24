if exists('g:loaded_make_ruby_tags')
  finish
endif
let g:loaded_make_ruby_tags = 1

let s:cpo_save = &cpo
set cpo&vim

function! utility#tags#make() " {{{
  let tags_file  = getcwd() . "\\" . "tags"
  " echom 'ripper-tags ' . "-f -R " . shellescape(tags_file)
  " echom shellescape(current_dir)
  call system('ripper-tags ' . "-R -f " . shellescape(tags_file) . " --exclude=test --exclude=config --exclude=.rblcl --exclude=doc  --exclude=.yardoc --exclude=.git --extra=q")
endfunction " }}}


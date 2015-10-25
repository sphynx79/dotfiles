"  Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=120 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" Maintainer:
"       Boscolo Michele
"       miboscol@gmail.com
"
" Version:
"       1.0 - 04/09/12 09:26:00
"
" Blog_post:
"       http:/.............
"
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Text, tab and indent related   -> Visual mode related
"    -> Text, tab and indent related   -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
" }

"  General {

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

 "  Sphynx options {
 let g:sphynx_Active_Accelerated_smooth_scroll = 1
 let g:sphynx_Active_Bufkill = 1
 let g:sphynx_Active_Dash = 1
 let g:sphynx_Active_DelimitMate = 1
 let g:sphynx_Active_Easycolour = 1
 let g:sphynx_Active_Emmet = 1
 let g:sphynx_Active_FastFold = 1
 let g:sphynx_Active_Funcoo = 1
 let g:sphynx_Active_GoldenRatio = 1
 let g:sphynx_Active_Html5 = 1
 let g:sphynx_Active_IndentLine = 1
 let g:sphynx_Active_L9 = 1
 let g:sphynx_Active_MatchTag = 1
 let g:sphynx_Active_NerdTree = 1
 let g:sphynx_Active_Noerrmsg = 1
 let g:sphynx_Active_RainbowParenthes = 1
 let g:sphynx_Active_SnipMate = 1
 let g:sphynx_Active_SnipMgr = 1
 let g:sphynx_Active_Tabular = 1
 let g:sphynx_Active_Tagbar = 1
 let g:sphynx_Active_TComment = 1
 let g:sphynx_Active_Ultisnips = 1
 let g:sphynx_Active_UniteMark = 1
 let g:sphynx_Active_UniteRails = 1
 let g:sphynx_Active_UniteTag = 1
 let g:sphynx_Active_UniteVim = 1
 let g:sphynx_Active_VCoolor = 1
 let g:sphynx_Active_VimAirline = 1
 let g:sphynx_Active_VimAutocomplpop = 1
 let g:sphynx_Active_VimAutoformat = 1
 let g:sphynx_Active_VimCoffeScript = 1
 let g:sphynx_Active_VimColoresque = 1
 let g:sphynx_Active_VimCtrlspace = 1
 let g:sphynx_Active_VimEasymotion = 1
 let g:sphynx_Active_VimEasytags = 1
 let g:sphynx_Active_VimLess = 1
 let g:sphynx_Active_VimLocalComplete = 1
 let g:sphynx_Active_VimMaximizer = 1
 let g:sphynx_Active_VimMisc = 1
 let g:sphynx_Active_VimMove = 1
 let g:sphynx_Active_VimRails = 1
 let g:sphynx_Active_VimRuby = 1
 let g:sphynx_Active_VimRubyXmpfilter = 1
 let g:sphynx_Active_VimSignature = 1
 let g:sphynx_Active_VimProcMac = 1
 let g:sphynx_Active_VimProcWin = 1
 let g:sphynx_Active_VimShell = 1
 let g:sphynx_Active_YouCompleteMe = 1
 if OSX()
     let g:sphynx_Active_VimAutocomplpop = 0
     let g:sphynx_Active_SnipMate = 0
     let g:sphynx_Active_SnipMgr = 0
     let g:sphynx_Active_L9 = 0
     let g:sphynx_Active_VimLocalComplete = 0
     let g:sphynx_Active_VimProcWin = 0
     let g:sphynx_Active_VimShell = 0
     let g:sphynx_Active_Tagbar = 0
 elseif WINDOWS()
     let g:sphynx_Active_VimAutocomplpop = 0
     let g:sphynx_Active_SnipMate = 0
     let g:sphynx_Active_SnipMgr = 0
     let g:sphynx_Active_Dash = 0
     let g:sphynx_Active_VimLocalComplete = 0
     let g:sphynx_Active_VimProcMac = 0
     let g:sphynx_Active_VimShell = 0
     let g:sphynx_Active_Tagbar = 0
     let g:sphynx_Active_L9 = 0
 elseif LINUX()

 endif
 " }sphynx options

 "  Stratup Pathogen {
 let g:pathogen_disabled = []

 if !g:sphynx_Active_Accelerated_smooth_scroll
     call add(g:pathogen_disabled, 'accelerated-smooth-scroll') 
 endif
 if !g:sphynx_Active_Bufkill
     call add(g:pathogen_disabled, 'bufkill.vim') 
 endif
 if !g:sphynx_Active_Dash
     call add(g:pathogen_disabled, 'dash.vim') 
 endif
 if !g:sphynx_Active_DelimitMate
     call add(g:pathogen_disabled, 'delimitMate.vim') 
 endif
 if !g:sphynx_Active_Easycolour
     call add(g:pathogen_disabled, 'easycolour') 
 endif
 if !g:sphynx_Active_Emmet 
     call add(g:pathogen_disabled, 'emmet-vim') 
 endif
 if !g:sphynx_Active_FastFold
     call add(g:pathogen_disabled, 'FastFold') 
 endif
 if !g:sphynx_Active_Funcoo
     call add(g:pathogen_disabled, 'funcoo.vim') 
 endif
 if !g:sphynx_Active_GoldenRatio
     call add(g:pathogen_disabled, 'golden-ratio')
 endif
 if !g:sphynx_Active_Html5
     call add(g:pathogen_disabled, 'html5.vim') 
 endif
 if !g:sphynx_Active_IndentLine
     call add(g:pathogen_disabled, 'indentLine') 
 endif
 if !g:sphynx_Active_L9
     call add(g:pathogen_disabled, 'L9') 
 endif
 if !g:sphynx_Active_VimLocalComplete
     call add(g:pathogen_disabled, 'vim-localcomplete') 
 endif
 if !g:sphynx_Active_MatchTag
     call add(g:pathogen_disabled, 'MatchTag') 
 endif
 if !g:sphynx_Active_NerdTree
     call add(g:pathogen_disabled, 'nerdtree') 
 endif
 if !g:sphynx_Active_Noerrmsg
     call add(g:pathogen_disabled, 'noerrmsg') 
 endif
 if !g:sphynx_Active_RainbowParenthes
     call add(g:pathogen_disabled, 'rainbow_parentheses.vim') 
 endif
 if !g:sphynx_Active_SnipMate
     call add(g:pathogen_disabled, 'snipMate') 
 endif
 if !g:sphynx_Active_SnipMgr
     call add(g:pathogen_disabled, 'SnipMgr') 
 endif
 if !g:sphynx_Active_Tabular
     call add(g:pathogen_disabled, 'tabular') 
 endif
 if !g:sphynx_Active_TComment
     call add(g:pathogen_disabled, 'tComment') 
 endif
 if !g:sphynx_Active_Ultisnips
     call add(g:pathogen_disabled, 'ultisnips') 
 endif
 if !g:sphynx_Active_UniteMark
     call add(g:pathogen_disabled, 'unite-mark') 
 endif
 if !g:sphynx_Active_UniteRails
     call add(g:pathogen_disabled, 'unite-rails') 
 endif
 if !g:sphynx_Active_UniteTag
     call add(g:pathogen_disabled, 'unite-tag') 
 endif
 if !g:sphynx_Active_UniteVim
     call add(g:pathogen_disabled, 'unite.vim') 
 endif
 if !g:sphynx_Active_VCoolor
     call add(g:pathogen_disabled, 'vCoolor.vim') 
 endif
 if !g:sphynx_Active_VimAirline
     call add(g:pathogen_disabled, 'vim-airline') 
 endif
 if !g:sphynx_Active_VimAutocomplpop
     call add(g:pathogen_disabled, 'vim-autocomplpop') 
 endif
 if !g:sphynx_Active_VimAutoformat
     call add(g:pathogen_disabled, 'vim-autoformat') 
 endif
 if !g:sphynx_Active_VimCoffeScript 
     call add(g:pathogen_disabled, 'vim-coffee-script') 
 endif 
 if ! g:sphynx_Active_VimColoresque
     call add(g:pathogen_disabled, 'vim-coloresque') 
 endif
 if !g:sphynx_Active_VimCtrlspace
     call add(g:pathogen_disabled, 'vim-ctrlspace') 
 endif
 if !g:sphynx_Active_VimEasymotion
     call add(g:pathogen_disabled, 'vim-easymotion') 
 endif
 if !g:sphynx_Active_VimEasytags
     call add(g:pathogen_disabled, 'vim-easytags') 
 endif
 if !g:sphynx_Active_VimLess
     call add(g:pathogen_disabled, 'vim-less') 
 endif
 if !g:sphynx_Active_VimMaximizer
     call add(g:pathogen_disabled, 'vim-maximizer') 
 endif
 if !g:sphynx_Active_VimMisc
     call add(g:pathogen_disabled, 'vim-misc') 
 endif
 if !g:sphynx_Active_VimMove
     call add(g:pathogen_disabled, 'vim-move') 
 endif
 if !g:sphynx_Active_VimRails
     call add(g:pathogen_disabled, 'vim-rails') 
 endif
 if !g:sphynx_Active_VimRuby
     call add(g:pathogen_disabled, 'vim-ruby') 
 endif
 if !g:sphynx_Active_VimRubyXmpfilter
     call add(g:pathogen_disabled, 'vim-ruby-xmpfilter') 
 endif
 if !g:sphynx_Active_VimSignature
     call add(g:pathogen_disabled, 'vim-signature') 
 endif
 if !g:sphynx_Active_VimProcMac
     call add(g:pathogen_disabled, 'vimproc_mac') 
 endif
 if !g:sphynx_Active_VimProcWin
     call add(g:pathogen_disabled, 'vimproc_win') 
 endif
 if !g:sphynx_Active_VimShell
     call add(g:pathogen_disabled, 'vimshell.vim') 
 endif
 if !g:sphynx_Active_YouCompleteMe
     call add(g:pathogen_disabled, 'YouCompleteMe') 
 endif
 "call add(g:pathogen_disabled, 'ctrlp.vim')          " Disabilito un plugin
 call pathogen#infect()                               " Comando utilizzato per far funzionare il plugin Pathogen (serve per gestire i plugin)
 call pathogen#helptags()                             " Crea la documentazione per i plugin
 " } Stratup Pathogen

 "  Environment {

 set guioptions-=T                                     " Hide toolbar.

 set guioptions-=m                                     " Hide menubar.

 set guioptions-=L                                    " hide the left-hand scrollbar for splits/new windows

 "set guioptions+=M                                    " disable syntax menu

 set nocompatible                                     " Deve stare prima di qualsiasi altro impostazione, perchè fa cambiare il senso dei settaggio successivi

 set history=700                                      " Sets how many lines of history VIM has to remember

 set autowrite                                        " Salva automaticamente il file quando esco

 set browsedir=last                                   " riapre la navigazione delle directory ricordandosi l'ultima

 filetype indent on                                   " Turn on file type detection
 filetype plugin on                                   " Enable filetype plugins  

 set backspace=eol,start,indent                       " Configure backspace so it acts as it should act

 set whichwrap+=b,s,h,l,<,>,[,]                       " Backspace and cursor keys wrap too

 set ignorecase                                       " Ignore case when searching

 set smartcase                                        " When searching try to be smart about cases

 set noerrorbells                                     " No annoying sound on errors
 set novisualbell
 set vb t_vb= t_vb=
 set tm=500

 scriptencoding utf-8                                 " Set utf8 as standard encoding and en_US as the standard language
 set encoding=utf-8

 set spell spelllang=it,en                            " Set English and Italian language

 set completeopt-=preview

 set switchbuf=usetab                                 " Now, when using :sb, :sbnext, :sbprev instead of :b, :bnext, :bprev to switch buffers, Vim will check if buffer is open in tab/window and switch to that tab/window.

 set autoread

 set nospell

 " apre posiziona il cursore dove lo avevo lasciato l'ultima volta
 if has("autocmd")
     au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
 endif


 " di default era .,w,b,u,t,i io ci ho tolto la "i" cosi l'autocompletamento dovrebbe essere più veloce
 " perchè con l'opzione i fa lo scan di tutti i file inclusi
 " . => scan the current buffer ('wrapscan' is ignored)
 " w => scan buffers from other windows
 " b => scan other loaded buffers that are in the buffer list
 " t => tag completion
 " u => scan the unloaded buffers that are in the buffer list
 " i => scan current and included files
 " k => scan the files given with the 'dictionary'
 set complete=.,w,b,u,t

 if WINDOWS()
     " Prefer unix even though we're on Windows.
     set fileformats=unix,dos
 endif

 if WINDOWS()
     let $PATH = 'C:\APPL\Python27;' . $PATH
     "let $HOME = 'C:\APPL\vim74'
 endif


 "  Files, backups and undo {
 set nobackup                                         " Turn backup off, since most stuff is in SVN, git et.c anyway...
 set nowb
 set noswapfile

 set undodir=$VIMRUNTIME/undo                         " Persistent undo
 set undofile
 " }

 "  Tab and indent relate {
 set expandtab                                        " Use spaces instead of tabs
 set smarttab                                         " Be smart when using tabs ;)

 set shiftwidth=3                                     " 1 tab == 3 spaces
 set tabstop=3

 set lbr                                              " Line break on 500 characters
 set tw=0

 set ai                                               " Indent at the same level of the previous line
 set si                                               " Smart indent
 set nowrap                                           " Wrap lines
 " }

 " }

 "  UI Setting {

 " disabilita il messaggio iniziale
 set shortmess+=I

 set foldcolumn=2                                     " set margin left foldin area

 set so=5                                             " Set 7 lines to the cursor - when moving vertically using j/k

 set title                                            " Set the terminal's title

 set wildmenu                                         " Turn on the WiLd menu/Enhanced command line completion
 set wildmode=list:longest,full                       " Command <Tab> completion, list matches, then longest common part, then all.
 set wildignore=*.o,*~,*.pyc,*.png,*.jpg,*.gif        " Ignore compiled files
 set wildignore+=log/**
 set wildignore+=vendor/cache/**
 set wildignore+=vendor/rails/**
 set wildignore+=tmp/**
 set wildignore+=log/**


 if has('cmdline_info')
     set ruler                                          " Always show current position
     set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
     set showcmd                                        " Show partial commands in status line and
 endif

 set showmode                                         " Display the current mode

 set cmdheight=1                                      " Height of the command bar

 set hidden                                           " Setta per ogni buffer l'opzione hidden di default, questo mi permette di passare in maniera più pratica tra i buffer(ved. usr_22: nascondere i buffer)

 set hlsearch                                         " Highlight search terms

 set incsearch                                        " Find as you type search

 set magic                                            " For regular expressions turn magic on

 set ttyfast

 set lazyredraw                                       " Don't redraw while executing macros (good performance config)

 "set showmatch                                        " Show matching brackets when text indicator is over them

 "set mat=2                                            " How many tenths of a second to blink when matching brackets

 set number                                           " Mostra il numero di righe

 highlight Pmenu ctermbg=238 gui=bold                 " migliora il colore del menu autocomplete

 syntax enable                                        " Enable syntax highlighting

 if OSX()                                             " Set extra options when running in GUI mode
     set guioptions-=T
     set guioptions+=e
     set t_Co=256
     set guitablabel=%M\ %t
 endif

 set laststatus=2                                     " Always show the status line

 " Configurazione utile associata al plugin vim-maximizer
 "set winminwidth=0                                    " setto l'altezza minima per una finestra
 "set winminheight=0                                   " setto la larghezza minima per una finestra

 set foldcolumn=1

 let g:loaded_matchparen=1                           " Disabilito il match delle parentesi

 "miglioro il rendereing dei font
 if WINDOWS()
     set renderoptions=type:directx,
                 \gamma:1.8,contrast:0.5,geom:1,
                 \renmode:5,taamode:1,level:0.5
 endif

 "hi vertsplit guifg=NONE guibg=NONE
 set guicursor+=a:blinkon0

 " carattere usato per la linea che separa una finestra verticale 
 set fillchars=vert:\│

 " migliora le performance di vim
 syntax sync maxlines=200
 syntax sync minlines=10
 set nocursorline

 " }UI Setting

 "  Key Setting {
 if OSX()
     let macvim_skip_cmd_opt_movement = 1
 endif

 if OSX()
     let macvim_skip_colorscheme = 1    
 endif

 " Receive option keys as meta
 if OSX()
     set macmeta
 endif

 if OSX()
     nmap <D-j> <M-j>
     nmap <D-k> <M-k>
     vmap <D-j> <M-j>
     vmap <D-k> <M-k>
 endif 

 if WINDOWS()
     behave mswin
     source $VIMRUNTIME/mswin.vim
 endif 

 " map leader
 " let mapleader=" "

 " è stato rimappato il ` per poter accedere alla posizione giusta del mio segnalibro  
 map ? i

 " setto il secondo leader
 let maplocalleader = '-'

 " mi permette di selezionare in modalità colonna con il mouse
 " vedere http://vim.wikia.com/wiki/Easy_block_selection_with_mouse
 noremap <M-LeftMouse> <4-LeftMouse>
 inoremap <M-LeftMouse> <4-LeftMouse>
 onoremap <M-LeftMouse> <C-C><4-LeftMouse>
 noremap <M-LeftDrag> <LeftDrag>
 inoremap <M-LeftDrag> <LeftDrag>
 onoremap <M-LeftDrag> <C-C><LeftDrag>

 " switch CWD to the directory of the open buffer
 map <leader>cd :lcd %:p:h<cr>:pwd<cr>

 " apro esplorara risorse per aprire il mio file
 map <Leader>o :browse e<cr>

 " apre salva con nome
 map <Leader>s :browse saveas<cr>

 " mi apre subito il mio vimrc
 map <leader>e :e $MYVIMRC<cr>

 " pressing ,ss will toggle and untoggle spell checking
 map <leader>sc :setlocal spell!<cr>

 imap <Esc> <Esc><Esc>

 "  Shortcut => Folding {
 " setto i tasti per il folding
 nmap z<Left>  zc
 nmap z<Right> zo
 nmap z<Up>    :set foldlevel=1<CR>
 nmap z<Down>  zr
 " }Shortcut => Folding

 "  Shortcut => Moving around {
 " Treat long lines as break lines (useful when moving around in them)
 map j gj
 map k gk

 " si posiziona a fine riga
 map 9 $
 " si posiziona a meta riga
 map 8 :call cursor(0, virtcol('$')/2)<CR>
 " si posiziona all'inizio della riga
 map 0 ^

 " Per fare lo scroll della pagina si appogia anche al plugin accelerated-smooth-scroll
 " zz mi centra la pagina sulla riga corrente
 " C-e mi sposto verso giu di una riga
 nmap <leader><leader><Up> <C-b>
 nmap <leader><leader><Down> <C-f>
 nmap <leader><Up> <C-u>
 nmap <leader><Down> <C-d>
 " scorro la pagina di una riga verso giu senza spostare il cursore
 nmap <A-Down> <C-e>
 " scorro la pagina di una riga verso su senza spostare il cursore
 nmap <A-UP> <C-y>

 " Remap VIM `. per spostarmi ultima riga modificata
 map <silent><leader>le `.


 " }Shortcut => Moving around 

 "  Shortcut => Buffer & window {
 " per spostarmi tra i buffer
 "nnoremap <silent> <A-Left>  :bprevious<CR>
 "nnoremap <silent> <A-Right> :bnext<CR>
 "inoremap <silent> <A-Left>  :bprevious<CR>
 "inoremap <silent> <A-Right> :bnext<CR>
 "vnoremap <silent> <A-Left>  :bprevious<CR>
 "vnoremap <silent> <A-Right> :bnext<CR>

 " mi sposto tra i buffer con i numeri
 "imap <A-1> <Esc>:b1<CR>i
 "imap <A-2> <Esc>:b2<CR>i
 "imap <A-3> <Esc>:b3<CR>i
 "imap <A-4> <Esc>:b4<CR>i
 "imap <A-5> <Esc>:b5<CR>i
 "imap <A-6> <Esc>:b6<CR>i
 "imap <A-7> <Esc>:b7<CR>i
 "imap <A-8> <Esc>:b8<CR>i
 "imap <A-9> <Esc>:b9<CR>i
 "map <A-1> :b1<CR>
 "map <A-2> :b2<CR>
 "map <A-3> :b3<CR>
 "map <A-4> :b4<CR>
 "map <A-5> :b5<CR>
 "map <A-6> :b6<CR>
 "map <A-7> :b7<CR>
 "map <A-8> :b8<CR>
 "map <A-9> :b9<CR>
 nnoremap <silent> <A-Down>  :tabprevious<CR>
 nnoremap <silent> <A-Up> :tabnext<CR>
 inoremap <silent> <A-Down>  :tabprevious<CR>
 inoremap <silent> <A-Up> :tabnext<CR>
 vnoremap <silent> <A-Down>  :tabprevious<CR>
 vnoremap <silent> <A-Up> :tabnext<CR>

 " mi permette di spostarmi tra i buffer con <leader>n.ro buffer
 for n in range(1, 9)
     exe "nmap <leader>".n." :set foldlevel=".n."<CR>"
 endfor


 " Smart way to move between windows
 map <C-j> <C-W>j
 map <C-k> <C-W>k
 map <C-h> <C-W>h
 map <C-l> <C-W>l

 " Spostarmi tra le finestre con i tasti direzionali
 nmap <silent> <C-Up> :wincmd k<CR>
 nmap <silent> <C-Down> :wincmd j<CR>
 nmap <silent> <C-Left> :wincmd h<CR>
 nmap <silent> <C-Right> :wincmd l<CR>

 " creare nuove finestre ed è pensato rispetto la finestra o rispetto il buffer
 " vedere https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
 " window
 nmap <leader>w<left>  :topleft  vnew<CR>
 nmap <leader>w<right> :botright vnew<CR>
 nmap <leader>w<up>    :topleft  new<CR>
 nmap <leader>w<down>  :botright new<CR>

 " buffer
 nmap <leader>b<left>   :leftabove  vnew<CR>
 nmap <leader>b<right>  :rightbelow vnew<CR>
 nmap <leader>b<up>     :leftabove  new<CR>
 nmap <leader>b<down>   :rightbelow new<CR>

 " shortcut per ridimensionare le finestre
 nnoremap  <localleader><left>  : vertical resize -6<cr>
 nnoremap  <localleader><up>    : resize +6<cr>
 nnoremap  <localleader><down>  : resize -6<cr>
 nnoremap  <localleader><right> : vertical resize +6<cr>
 nnoremap  <localleader>-         <C-W>=
 nnoremap  <localleader><localleader><left>   <C-w>\| 
 nnoremap  <localleader><localleader><Up>   <C-w>_ 

 " Close the current buffer
 map <leader>q :bd<cr>

 " Close all the buffers
 map <leader>qa :1,1000 bd!<cr>
 " }Shortcut => Buffer & window 

 "  Shortcut => Editing {
 " in insert mode va a capo e mi inserisce una tabulazione
 imap <C-Return> <CR><CR><C-o>k<Tab>
 " in insert mode mi crea una nuova linea e si posiziona sulla nuova linea
 imap <A-Return> <C-O>o

 " Usate per eliminare una parola anche tipo @variabile o se mi trova al centro della parola
 inoremap <C-d> <C-O>B<C-O>dE
 noremap <leader>dw BdEi

 " Mette le parentesi sul testo selezionato
 vnoremap ( <Esc>`>a)<Esc>`<i(<Esc>
 " Mette le parentesi quadre sul testo selezionato
 vnoremap [ <Esc>`>a]<Esc>`<i[<Esc>
 " Mette gli apici sul testo selezionato
 vnoremap " <Esc>`>a"<Esc>`<i"<Esc>

 "  }Shortcut => Editing

 "  Shortcut => Visualization {
 " Clear search highlight
 map <silent> <leader>- :let @/=""<CR>:echo "Cleared search register."<cr>

 " per evidenziare riga e colonna
 map <silent> <Leader>cl         :set   cursorline! <CR>
 imap <silent> <Leader>cl <Esc>  :set   cursorline! <CR>
 map <silent> <Leader>cc         :set   cursorcolumn! <CR>
 imap <silent> <Leader>cc <Esc>  :set   cursorcolumn! <CR>
 map <silent> <Leader>ca         :set   cursorcolumn!  cursorline! <CR>
 imap <silent> <Leader>ca <Esc>  :set   cursorcolumn!  cursorline! <CR>

 " }Shortcut => Visualization

 "  Shortcut => Search & Replace {
 " Visual mode uso * o # per avviare la ricerca della parola sotto il curosre
 vnoremap <silent> * :call VisualSelection('f')<CR>
 vnoremap <silent> # :call VisualSelection('b')<CR>

 " start a substitute
 map <leader>r :%s/
 " sostituisce tutte le occorrenze della parola che si trova sotto il cursore
 nmap <leader>sw :%s/<C-r>=expand("<cword>")<CR>/
 " pull word under cursor into Ack for a global search
 map <leader>za :Ack "<C-r>=expand("<cword>")<CR>"
 " }Shortcut => Search & Replace

 "  Ctags {
 " va al tag sotto il cursore
 map <silent><leader><Left> <C-T>
 " va al tag sotto il cursore
 map <silent><leader><Right> <C-]>
 " }Ctags

 "  Diff mode {
 " per spostarmi tra le differenze in modalità diff
 if &diff
     noremap <M-down> ]cz
     noremap <M-up> [cz
 endif
 " }Diff mode

 " }Key Setting

 " } General

"  Language Support {

"  Ruby & Rails {
    let ruby_operators = 1
    "let ruby_space_errors = 1
    "let ruby_fold=1                                               " enable foldmethod=syntax for ruby files
    let ruby_no_comment_fold = 1
    set tags+=gems.tags                                           " aggiungo il supporto ai tag anche per le gemme del progetto
    "silent command -bar -nargs=1 OpenURL :!open <args>            " Serve per aprire da vim la pagina corrente nel browser con il comando Rpreview
    "disabilito il balloon
    set noballooneval

    "forzo vim ad usare il vecchio regex engine, più veloce per la syntax in ruby
    set re=1
    
    " i comandi seguenti sono utilizzati per rendere vim piu veloce
    let ruby_minlines = 200
    "let ruby_no_expensive = 1
    let ruby_space_errors = 0
    let ruby_no_trail_space_error = 0

    "Per far funzionare matchit
    runtime macros/matchit.vim

    if WINDOWS()
       let g:ruby_path = ':C:\Ruby21\bin'
    elseif OSX()
        let g:ruby_path = system('echo $HOME/.rbenv/shims')
    endif 

    if !exists( "*RubyEndToken" )

      function RubyEndToken()
        let current_line = getline( '.' )
        let braces_at_end = '{\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'
        let stuff_without_do = '^\s*\(class\|if\|unless\|begin\|case\|for\|module\|while\|until\|def\)'
          let with_do = 'do\s*\(|\(,\|\s\|\w\)*|\s*\)\?$'

          if match(current_line, braces_at_end) >= 0
            return "\<CR>}\<C-O>O"
          elseif match(current_line, stuff_without_do) >= 0
            return "\<CR>end\<C-O>O"
          elseif match(current_line, with_do) >= 0
            return "\<CR>end\<C-O>O"
          else
            return "\<CR>"
          endif
        endfunction

    endif

    imap <S-CR> <C-R>=RubyEndToken()<CR>



    "Vedere impostazione presenti in Autocmd
" }Ruby & Rails

"  Xml {
    "au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
    au FileType xml exe ":silent 1,$!xml fo - 2>/dev/null"
" }Xml

" }Language Support

"  Plugin {

"  Dash {
    if g:sphynx_Active_Dash
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " definisco su quali docset andare a cercare prima
        " importante mettere in maiuscolo il nome dei docset
        let g:dash_map = {
             \ 'ruby' :  ['Ruby', 'Rails'],
             \ 'javascript' : ['Javascript, Jquery']
             \ }
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " avvia la ricerca in dash della parola sotto il cursore
        nmap <silent> <leader>d <Plug>DashSearch
    endif
" }Dash

"  Emmet {
    if g:sphynx_Active_Emmet
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }Emmet

"  GoldenRatio {
    if g:sphynx_Active_GoldenRatio
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:golden_ratio_autocommand = 0
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <F7> :GoldenRatioToggle<CR>
    endif
" }Emmet

"  IndentLine {
    if g:sphynx_Active_IndentLine 
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:indentLine_enabled = 0
        let g:indentLine_color_gui = '#0B5E6F'
        let g:indentLine_char = '¦'
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " attiva & disattiva il resize automatico
        nmap <Leader>il :IndentLinesToggle<cr>
    endif
" }IndentLine

"  NerdTree {
    if g:sphynx_Active_NerdTree
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let NERDTreeQuitOnOpen = 1
        let NERDTreeMouseMode = 2 
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        map  <F2> :NERDTreeToggle  %:p:h<cr>
        vmap <F2> <esc>:NERDTreeToggle %:p:h<cr>
        imap <F2> <esc>:NERDTreeToggle %:p:h<cr>
        map  <Leader>nt :NERDTree %:p:h<CR>
    endif
" }NerdTree

"  RainbowParentheses {
    if g:sphynx_Active_RainbowParenthes
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " IMPORTANTE
            " ho settato dei parametri nella sessione Autocmd per attivazione plugin e configurazione
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }RainbowParentheses

"  Tabular {
    if g:sphynx_Active_Tabular
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:\zs<CR>
        vmap <Leader>a: :Tabularize /:\zs<CR>
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }Tabular

"  Tagbar {
    if g:sphynx_Active_Tagbar
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:tagbar_autoclose = 1
        let g:tagbar_usearrows = 1
        let g:tagbar_width=28
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nmap <F3> :TagbarToggle<CR>
    endif
" } Tagbar

"  Tcomment {
    if g:sphynx_Active_TComment
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:tcommentMaps = 0
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <silent><leader>. :TComment<CR>
        vnoremap <silent><leader>. :TComment<CR>
    endif
" }Tcomment

"  Ultisnip {
    if g:sphynx_Active_Ultisnips
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Le seguenti funzioni mi permettono una migliore integrazione con Youcompleteme
        function! g:UltiSnips_Reverse()
            call UltiSnips#JumpBackwards()
            if g:ulti_jump_backwards_res == 0
                return "\<C-P>"
            endif
            return ""
        endfunction

        function! g:UltiSnips_Complete()
            call UltiSnips#ExpandSnippet()
            if g:ulti_expand_res == 0
                if pumvisible()
                    return "\<C-n>"
                else
                    call UltiSnips#JumpForwards()
                    if g:ulti_jump_forwards_res == 0
                        return "\<TAB>"
                    endif
                endif
            endif
            return ""
        endfunction
        " IMPORTANTE
        " Ho inserito dei parametri nella sezione Autocmd per migliore
        " integrazione con Youcompleteme

        " this mapping Enter key to <C-y> to chose the current highlight item
        " and close the selection list, same as other IDEs.
        " CONFLICT with some plugins like tpope/Endwise
        inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        " Setto le cartelle dove cercare gli snippet
        if WINDOWS()
            let g:UltiSnipsSnippetsDir=$VIM."/vimfiles/bundle/ultisnips/UltiSnips"
        endif

        let g:UltiSnipsUsePythonVersion = 2
        let g:UltiSnipsSnippetDirectories=["UltiSnips","CssUltiSnips","snippet"]
        let g:UltiSnipsMappingsToIgnore = [ "unite" ]
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:UltiSnipsListSnippets="<c-e>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    endif
" }Ultisnip

"  Unite {
    if g:sphynx_Active_UniteVim
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "Ag command is disabled by default. Because, it is slower than default find command.
        " https://github.com/Shougo/vimproc.vim/issues/150
        " vedere se tenerlo
        if executable('ag')
        let g:unite_source_rec_async_command =  ['ag', '--follow', '--nocolor', '--nogroup', '--ignore', '.git', '--ignore', 'tmp', '--hidden', '-g', '']
        " Use ag in unite grep source.
          " let g:unite_source_grep_command = 'ag'
          " let g:unite_source_grep_default_opts =
          " \ ' --line-numbers --nocolor -i --vimgrep --hidden --ignore ' .
          " \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
          let g:unite_source_grep_command = 'sift'
          let g:unite_source_grep_default_opts =
          \ ' --binary-skip --ext=rb,erb  --line-number --no-color ' .
          \ '--exclude-dirs ''.svn'' --exclude-dirs ''.git'' --exclude-dirs ''.bzr'''
	     let g:unite_source_grep_recursive_opt = ''
        " let g:unite_source_grep_default_opts =
        "         \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
        "         \ '''.hg'' --ignore ''.svn'' --ignore ''**/*.html'' --ignore ''tags'' --ignore ''doc'' --ignore ''.yardoc'' --ignore ''**/*.js'' --ignore ''.git'' --ignore ''.bzr'' ' .
        "         \ '--ignore ''**/*.pyc'' --ignore ''.yml'''
        endif

        " Unite mappings
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        " ordina i risultati in base ala pertinenza della parola e alla sua lunghezza
        " nota: questa impostazione rallenta la ricerca.
        call unite#filters#sorter_default#use(['sorter_rank'])
        " call unite#set_profile('files', 'smartcase', 1)
        " call unite#custom#profile('files', 'filters', ['sorter_rank'])
        " call unite#custom#source('line,outline','matchers','matcher_fuzzy')
        " call unite#custom#source('file_rec', 'ignore_pattern', 'node_modules/')
        " call unite#custom#source('file_rec', 'ignore_pattern', '.git/')
        let g:unite_source_history_yank_enable = 0
        let g:unite_source_grep_max_candidates = 200
        let g:unite_enable_auto_select = 0
        call unite#custom_source('file,file_rec,file_rec/async,grep',
              \ 'ignore_pattern', join([
              \ '\.git/',
              \ '\.bundle/',
              \ '\.rubygems/',
              \ 'vendor/',
              \ 'tags',
              \ 'doc/',
              \ '\.yardoc/'
              \ ], '\|'))
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "nnoremap <leader>p :<C-u>Unite -no-split -cursor-line-highlight=Visual -winheight=8 -update-time=10 -buffer-name=files -start-insert file_rec/async:!<cr>
        nnoremap <leader>p :Unite -no-split -winheight=8 -update-time=10 -buffer-name=files -start-insert file_rec/async:!<cr>
        nnoremap <leader>b :Unite -start-insert -winheight=8 -update-time=10 buffer_tab<cr>
        nnoremap <leader>t :Unite -start-insert -winheight=8 -update-time=10 tag<cr>
        nnoremap <leader>y :Unite -winheight=8 -update-time=10 history/yank<cr>
        nnoremap <leader>m :Unite -winheight=8 -update-time=10 mark<cr>
        "nnoremap <silent> <leader>r :<C-u>Unite -no-split -cursor-line-highlight=Visual -winheight=8 -update-time=10 -buffer-name=register register<CR>
        " Rails Integration
        nnoremap <localleader>rc :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/controller<cr>
        nnoremap <localleader>rv :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/view<cr>
        nnoremap <localleader>rm :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/model<cr>
        nnoremap <localleader>rb :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/bundle<cr>
        nnoremap <localleader>rs :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/stylesheet<cr>
        nnoremap <localleader>rj :Unite -no-split  -winheight=8 -update-time=10  -start-insert rails/javascript<cr>
        nnoremap <localleader>rh :Unite -no-split -winheight=8 -update-time=10  -start-insert rails/helper<cr>

        
        autocmd FileType unite call s:unite_settings()
        " Quick grep from cwd
        nnoremap <silent> <leader>g :<C-u>Unite -winwidth=150 grep:.::<CR>
        nnoremap <silent> <leader>G :<C-u>Unite -buffer-name=search  -auto-preview -no-quit -no-empty grep:.::<CR>


        function! s:unite_settings()
          imap <silent><buffer><expr> <C-x> unite#do_action('split')
          imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
          imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
          nmap <buffer> <ESC> <Plug>(unite_exit)
        endfunction
        
    endif
"  }

"  Vim-airline {
    if g:sphynx_Active_VimAirline
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " abilito i font speciali quelli con la path
        let g:airline_powerline_fonts = 1
        " seleziono il tema
        let g:airline_theme     = 'solarized'
        let g:Powerline_symbols = 'unicode'
        if !exists('g:airline_powerline_fonts')
        " Use the default set of separators with a few customizations
            let g:airline_left_sep='›'  " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif

        "let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
        let g:airline#extensions#tabline#show_buffers = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        " visualizza il numero del buffers nella tabline
        let g:airline#extensions#tabline#buffer_nr_format = '%s: '
        " quando avvio vim airline aspetta che vengano caricate tutte le estensini
        " presenti nel mio runtimepath, questo rallenta l'avvio, cosi lo disabilito
        let g:airline#extensions#disable_rtp_load = 1
        " cambio il modo in cui viene visualizzato il nome del buffer
        let g:airline#extensions#tabline#formatter = 'unique_tail'
        let g:airline#extensions#whitespace#enabled = 0
        let g:airline#extensions#tagbar#enabled = 0

        "IMPORTANTE
        " Nella sezione Autocmd ho modificato alcuni parametri per migliorare le
        " performance di questo plugin
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }vim-airline

"  Vim-autocomplpop {
    if g:sphynx_Active_VimAutocomplpop 
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Remove dictionary lookup from the Vim keyword completion.  It did always
        " complete the first match for me.  If you edit files with tags you might
        " want to add those.
        " . => scan the current buffer ('wrapscan' is ignored)
        " w => scan buffers from other windows
        " b => scan other loaded buffers that are in the buffer list
        " t => tag completion
        " u => scan the unloaded buffers that are in the buffer list
        " i => scan current and included files
        " k => scan the files given with the 'dictionary'
        let g:acp_completeOption = '.,w,b,t'

        " Don't preselect the first item.  Use the same key to select and to browse
        let g:acp_autoselectFirstCompletion = 0

        " count of chars required to start keyword completion
        let g:acp_behaviorKeywordLength = 3

        " This adds the local-completion function before all other completions
        " (snipmate, keyword, file) in the g:acp_behavior records set up by ACP.
        let g:acp_behaviorUserDefinedFunction = 'localcomplete#localMatches'
        "let g:acp_behaviorUserDefinedMeets = 'acp#meetsForKeyword'

        let g:acp_behaviorRubyOmniMethodLength = -1
        "Per usare snipmate devi iniziare a scrivere in maiuscolo e per inserire lo snipper devo dare Ctrl-y
        let g:acp_behaviorSnipmateLength = 1

        let g:acp_mappingDriven = 1
        let g:acp_behaviorKeywordCommand = "\<C-n>"
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Line  completion
        inoremap <C-L> <C-R>=acp#pum_color_and_map_adaptions(1)<CR><C-X><C-L><C-P>

        " Filename completion
        inoremap <C-F> <C-R>=acp#pum_color_and_map_adaptions(1)<CR><C-X><C-F><C-P>

        " Spelling corrections
        "inoremap <C-S> <C-R>=acp#pum_color_and_map_adaptions(1)<CR><C-X><C-S><C-P>

        " Omni completion
        inoremap <C-O> <C-R>=acp#pum_color_and_map_adaptions(1)<CR><C-X><C-O><C-P>

        " User defined completion
        inoremap <C-U> <C-R>=acp#pum_color_and_map_adaptions(1)<CR><C-X><C-U><C-P>


        " Close the pum with <Return>.  Otherwise, it would restore the old value after
        " manual completion.
        inoremap <Return> <C-R>=pumvisible()
                    \ ? "\<lt>C-X>\<lt>Return>"
                    \ : "\<lt>Return>"<CR>

        " Specify the keys used to select entries.  These create insert mode
        " mappings like you know them from the Vim documentation.
        "let g:acp_nextItemMapping = ['<TAB>', '\<lt>TAB>']
        "let g:acp_previousItemMapping = ['<S-TAB>', '\<lt>S-TAB>']

        map <S-F5> :AcpDisable<CR>
        map <F5>   :AcpEnable<CR>
    endif
" }AutoComplPop

"  Vim-autoformat {
    if g:sphynx_Active_VimAutoformat
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        noremap <F12> :Autoformat<CR><CR>
    endif
" }Vim-autoformat

"  Vim-ctrlspace {
    if g:sphynx_Active_VimAutoformat
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:ctrlspace_use_ruby_bindings = 1
        let g:ctrlspace_use_mouse_and_arrows = 1
        let g:airline_exclude_preview = 1

        let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
        let g:ctrlspace_show_key_info=1
        let g:ctrlspace_load_last_workspace_on_start=1
        let g:ctrlspace_save_workspace_on_exit=1
        "per i colori vedere il mio file zeus.txt del plugin easycolour
        
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <silent> <A-Left>  :CtrlSpaceGoUp<CR>
        nnoremap <silent> <A-Right> :CtrlSpaceGoDown<CR>
        inoremap <silent> <A-Left>  :CtrlSpaceGoUp<CR>
        inoremap <silent> <A-Right> :CtrlSpaceGoDown<CR>
        vnoremap <silent> <A-Left>  :CtrlSpaceGoUp<CR>
        vnoremap <silent> <A-Right> :CtrlSpaceGoDown<CR>

    endif
" }Vim-ctrelspace

"  Vim-Easytag {
    if g:sphynx_Active_VimEasytags
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        "abilita di default la generazione dei tag in modo ricorsivo
        "cioè fa lo scan tutti i file a partire dalla directory in cui mi trovo
        let g:easytags_autorecurse = 1
        "disabilito che quando smetto di scrivere parte l'update
        let g:easytags_on_cursorhold = 0
        let g:easytags_file = './tags'
        " Prevent easytags from auto updating and highlighting since it causes
        " glithces in terminal interfaces
        let g:easytags_auto_update=0
        let g:easytags_auto_highlight=0

        " Create and update tags file relative to project root
        let g:easytags_dynamic_files = 2
        let g:easytags_resolve_links=1

        " Use ripper-tags for ruby files (if available)
        " Install: gem install ripper-tags
        if executable('ripper-tags')
          let g:easytags_languages = {'ruby': {'cmd': 'ripper-tags'}}
        endif
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    endif
" }Vim-Easytag

"  Vim-maximizer {
    if g:sphynx_Active_VimMaximizer
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:maximizer_set_default_mapping = 0               " disabilito i tasto di default
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <silent><localleader>m :MaximizerToggle<CR>
        vnoremap <silent><localleader>m :MaximizerToggle<CR>gv
    endif
" }Vim-maximizer

"  vim-signature {
    if g:sphynx_Active_VimSignature
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:SignatureMap = {
            \ 'GotoNextLineByPos'  :  "m<Right>",
            \ 'GotoPrevLineByPos'  :  "m<Left>"
            \ }
    endif
" }

"  SnipMgr {
    if g:sphynx_Active_SnipMgr
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        if WINDOWS()
          let g:snipmgr_snippets_dir =  $VIM."/vimfiles/bundle/snipMate/snippets"
        elseif OSX()
          "let g:snipmgr_snippets_dir = $HOME."/.vim/bundle/snipM"
        endif
        let g:snipmgr_disable_menu = 1
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }SnipMgr

"  Youcompleteme {
    if g:sphynx_Active_YouCompleteMe 
        let g:acp_enableAtStartup = 0                     " mi assicuro di disabilitare AutoComplPop
        let g:ycm_use_ultisnips_completer = 1             " enable ultisnip integration
        let g:ycm_collect_identifiers_from_tags_files = 1 " enable completion from tags
        let g:EclimCompletionMethod = 'omnifunc'
        let g:ycm_min_num_of_chars_for_completion = 2
        let g:ycm_autoclose_preview_window_after_completion = 1
        let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'notes' : 1,
        \ 'markdown' : 1,
        \ 'unite' : 1,
        \ 'text' : 1,
        \ 'infolog' : 1,
        \}
        let g:ycm_semantic_triggers =  {
        \   'css': [ 're!^\s{4}', 're!:\s+' ],
        \   'ruby' : ['.', '::'],
        \ }
    endif
" }Youcompleteme

" }Plugin   "}

"  Autocmd {

   augroup vimrcEx
        autocmd!

        autocmd BufNewFile,BufRead *.json set ft=json

        " Enable omni completion
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

        "opzioni rubycomplete
        autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
        autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
        autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
        "vedere https://github.com/vim-ruby/vim-ruby/blob/master/doc/ft-ruby-omni.txt
        autocmd FileType ruby,eruby let g:rubycomplete_load_gemfile = 1
        autocmd BufRead,BufNewFile {Gemfile,Rakefile,config.ru} setlocal ft=ruby
        autocmd BufRead,BufNewFile *.yml setlocal ft=yaml
        autocmd BufNewFile,BufRead *.html.erb,*.erb set filetype=eruby.html " setto in filetype in html quando uso html.erb


        " Automatic fold settings for specific files. Uncomment to use.
        " uso il plugin fastfold
        autocmd FileType ruby setlocal foldmethod=syntax
        "autocmd FileType ruby setlocal foldmethod=manual
        autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

        " Automatically reload vimrc when it's saved
        "au BufWritePost .vimrc source ~/.vimrc|set foldlevel=0|AirlineRefresh
        au FileType vim set fdm=marker
        au SourceCmd .vimrc set foldlevel=0|AirlineRefresh

        " RainbowParentheses ==> mi inserisci i colori sulle parentesi che si matchano
        " au VimEnter * RainbowParenthesesToggle
        autocmd FileType ruby,eruby call rainbow_parentheses#activate()
        au Syntax ruby,eruby* RainbowParenthesesLoadRound         " (), the default when toggling
        au Syntax ruby,eruby RainbowParenthesesLoadSquare        " []
        au Syntax ruby,eruby RainbowParenthesesLoadBraces        " {}


        " AIRLINE ==> Risolve un problema di ritardo quando si lascia modalità inserimento
        if ! has('gui_running')
            set ttimeoutlen=10
            au InsertEnter * set timeoutlen=0
            au InsertLeave * set timeoutlen=1000
        endif
 
        " FOLDING ==> Non modifica il folding quando apro gli apici per inserire una stringa o quando cambio finestra
        "autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
        "autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

        " ULTISNIP ==> Viene utilizzato per migliorare l'integrazione con youcompleteme
        if g:sphynx_Active_Ultisnips
          au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
          au BufEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
        endif
    augroup END

" }Autocmd

"  Helper functions {

    function MyFoldText()
      let nucolwidth = &fdc + &number*&numberwidth
      let winwd = winwidth(0) - nucolwidth - 5
      let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
      let prefix = " _______>>> "
      let fdnfo = prefix . string(v:foldlevel) . "," . string(foldlinecount)
      let line =  strpart(getline(v:foldstart), 0 , winwd - len(fdnfo))
      let fillcharcount = winwd - len(line) - len(fdnfo)
      return line . repeat(" ",fillcharcount) . fdnfo
    endfunction

    " Tooltip per vedere codice in folding
    function! FoldSpellBalloon()"{{{
        let foldStart = foldclosed(v:beval_lnum)
        let foldEnd = foldclosedend(v:beval_lnum)
        let lines = []
        " Detect if we are in a fold
        if foldStart < 0
            " Detect if we are on a misspelled word
            let lines = spellsuggest(spellbadword(v:beval_text)[ 0 ], 5, 0)
        else
            " we are in a fold
            let numLines = foldEnd - foldStart + 1
            " if we have too many lines in fold, show only the first 14
            " and the last 14 lines
            if ( numLines > 31 )
                let lines = getline( foldStart, foldStart + 14 )
                let lines += [ '-- Snipped ' . (numLines - 30 ) . ' lines --' ]
                let lines += getline( foldEnd - 14, foldEnd)
            else
                "less than 30 lines, lets show all of them
                let lines = getline( foldStart, foldEnd)
            endif
        endif
        " return result
        return join (lines, has("balloon_multiline" ) ? "\n" : " ")
    endfunction"}}}


    " Trasforma in HTML il testo selezionato mantenendo la sintassi
    let g:html_use_css = 1
    let html_number_lines = 0
    function! MyToHtml(line1, line2)
        " make sure to generate in the correct format
        let old_css = 1
        if exists('g:html_use_css')
            let old_css = g:html_use_css
        endif
        let g:html_use_css = 0

        " generate and delete unneeded lines
        exec a:line1.','.a:line2.'TOhtml'
        %g/<body/normal k$dgg

        " convert body to a table
        %s/<body\s*\(bgcolor="[^"]*"\)\s*text=\("[^"]*"\)\s*>/<table \1 cellPadding=0><tr><td><font color=\2>/
        %s#</body>\(.\|\n\)*</html>#\='</font></td></tr></table>'#i

        " restore old setting
        let g:html_use_css = old_css
    endfunction
    command! -range=% MyToHtml :call MyToHtml(<line1>,<line2>)

" }Helper functions

"  Folding {
    set foldnestmax=2       "deepest fold is 10 levels
    set foldlevel=99        "this is just what i use

    " tooltip che mostra il contenuto del folding
    " set balloonexpr=FoldSpellBalloon()

    " cosa viene visualizzato quando faccio il folding del codice
    set foldtext=MyFoldText()

    " rimuove i caratteri ----- dopo il fold
    setl fillchars="fold: "

    " fare l'unfold automatico
    set foldopen+=block,insert,jump,mark,percent,quickfix,search,tag,undo

    " set foldclose=all

    " abilita il tooltip per vedere cosa c'e dentro il mio fold
    " set balloonexpr=FoldSpellBalloon()

    " IMPORTANTE
    " ho settato dei parametri nella sessione Autocmd per non modificarmi il
    " folding quando inserivo gli apici o cambiavo finestra
" }

"  Test {

    " Funzione che crea 'header per i miei file
    "autocmd BufNewFile *.rb call MakeFileHeader('=begin','','=end')
    let g:header_comment_author="Boscolo Michele"

    function! MakeFileHeader(fc,mc,lc)
        set paste
        let s:author = ""
        let s:copyright = ""
        if exists('g:header_comment_author')
            let s:author = g:header_comment_author
        else
            echo "g:header_comment_author is not defined in .vimrc"
        end
        if exists('g:header_comment_copyright')
            let s:copyright = g:header_comment_copyright
        else
            echo "g:header_comment_copyright is not defined in .vimrc"
        end

        let s:comment = a:fc . "\r"
        let s:comment .= "\r"
        let s:comment .= a:mc . "File Name     : " . expand('%:t') . "\r"
        let s:comment .= "\r"
        let s:comment .= a:mc . "Author        : " . s:author . "\r"
        let s:comment .= "\r"
        let s:comment .= a:mc . "Creation Date : " . strftime("%Y-%m-%d") . "\r"
        let s:comment .= "\r"
        let s:comment .= a:mc . "Last Modified : " . strftime("%d %b %Y %X") . "\r"
        let s:comment .= "\r"
        let s:comment .= a:lc . "\r"
        exec "normal i" . s:comment
        set nopaste
    endfunction


    let g:autosave_on_focus_change=1
    function! Autosave ()
        if &modified && g:autosave_on_focus_change
            "execute "normal ma"
            "exe "1," . 11 . "g/Last Modified :.*/s//Last Modified : " .strftime("%d %b %Y %X")
            "execute "normal `a"
            "execute "normal ma"
            write
        endif
    endfunction

    "autocmd  FocusGained  *.rb   :call Highlight_cursor()
    "function! Highlight_cursor ()
    "    set cursorline
    "    redraw
    "    sleep 250m
    "    set nocursorline
    "endfunction


    "autocmd Bufwritepre,filewritepre *.rb exe "1," . 11 . "g/Last Modified :.*/s//Last Modified : " .strftime("%d %b %Y %X")
    "autocmd bufwritepost,filewritepost *.rb execute "normal `a"

    " salvataggio automatico quando viene perso il focus
    " e aggiorna data di modifica nell'Header
    " au  VimLeave   *.rb   :bufdo call Autosave()
    " au  FocusLost  *.rb   :call Autosave()

    "vedere come usare https://github.com/tacahiroy/ctrlp-funky
    "if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
    "CtrlP extensions
    "let g:ctrlp_extensions = ['funky']
    "funky
    "nnoremap <Leader>fu :CtrlPFunky<Cr>
    "endif

" }


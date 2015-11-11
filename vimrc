"  Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=120 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
" Maintainer:
"       
"       miboscol@gmail.com
"
" Version:
"       2.0 - 10/11/15 09:26:00
"
" Blog_post:
"       http:/.............
"
"
" Sections:
"    -> General
"       -> Identify platform
"       -> Sphynx options
"       -> Stratup Pathogens
"       -> Environment 
"          -> Files, backups and undo 
"          -> Tab and indent relate
"          -> Folding
"       -> UI Setting  
"       -> Key Setting  
"          -> Shortcut => Folding 
"          -> Shortcut => Moving aroundg 
"          -> Shortcut => Buffer & window
"          -> Shortcut => Editing 
"          -> Shortcut => Visualization 
"          -> Shortcut => Search & Replace 
"          -> Shortcut => Ctags 
"          -> Shortcut => Diff mode  
"    -> Language Support
"       -> Ruby & Rails
"       -> Xml
"    -> Plugin
"       -> Airline
"       -> AutoFormat
"       -> CtrlSpace 
"       -> Dash
"       -> EasyTag 
"       -> Emmet 
"       -> GoldenRatio 
"       -> IndentLine
"       -> MakeHeader 
"       -> Maximizer 
"       -> NerdTree  
"       -> RainbowParentheses
"       -> Signature
"       -> Tabular 
"       -> Tagbar
"       -> Tcomment
"       -> Ultisnip
"       -> Unite 
"       -> Youcompleteme
"    -> Autocmd
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

     let g:sphynx_Active = {
         \ 'AcceleratedSmoothScroll'  :  1 ,
         \ 'Airline'                  :  1 ,
         \ 'Autoformat'               :  1 ,
         \ 'BufKill'                  :  1 ,
         \ 'CoffeeScript'             :  1 ,
         \ 'Colorv'                   :  1 ,
         \ 'CtrlSpace'                :  1 ,
         \ 'Dash'                     :  1 , 
         \ 'DelimitMate'              :  1 ,
         \ 'EasyColour'               :  1 ,
         \ 'EasyMotion'               :  1 ,
         \ 'EasyTags'                 :  1 ,
         \ 'Emmet'                    :  1 ,
         \ 'FastFold'                 :  1 , 
         \ 'Funcoo'                   :  1 ,
         \ 'GoldenRatio'              :  1 ,
         \ 'Html5'                    :  1 ,
         \ 'IndentLine'               :  1 ,
         \ 'MakeHeader'               :  1 ,
         \ 'MarkLines'                :  1 ,
         \ 'MatchTag'                 :  1 ,
         \ 'Maximizer'                :  1 ,
         \ 'Misc'                     :  1 ,
         \ 'Move'                     :  1 ,
         \ 'Nerdtree'                 :  1 ,
         \ 'NoErrMsg'                 :  1 ,
         \ 'Rails'                    :  1 ,
         \ 'RainbowParentheses'       :  1 ,
         \ 'Ruby'                     :  1 ,
         \ 'Signature'                :  1 ,
         \ 'Tabular'                  :  1 ,
         \ 'TagBar'                   :  1 ,
         \ 'TagBarCss'                :  1 ,
         \ 'TComment'                 :  1 ,
         \ 'Ultisnips'                :  1 ,
         \ 'Unite'                    :  1 ,
         \ 'UniteMark'                :  1 ,
         \ 'UniteRails'               :  1 ,
         \ 'VimProcMac'               :  1 ,
         \ 'VimProcWin'               :  1 ,
         \ 'WebApi'                   :  1 ,
         \ 'YouCompleteMeMac'         :  1 ,
         \ 'YouCompleteMeWin'         :  1 ,
         \}
 
     if OSX()
         let g:sphynx_Active.VimProcWin = 0
         let g:sphynx_Active.YouCompleteMeWin = 0
     elseif WINDOWS()
         let g:sphynx_Active.VimProcMac  = 0
         let g:sphynx_Active.Dash = 0
         let g:sphynx_Active.YouCompleteMeMac = 0
         let g:sphynx_Active.Maximizer = 0
     elseif LINUX()

     endif

 " }sphynx options

 "  Stratup Pathogen {

     " Disabilito i plugin non necessari
     let g:pathogen_disabled = []

     for [key, val] in items(g:sphynx_Active)
        if  !(val == 1)
            call add(g:pathogen_disabled, key)
        end
     endfor

     " Comando utilizzato per far funzionare il plugin Pathogen (serve per gestire i plugin)
     call pathogen#infect()
     " Crea la documentazione per i plugin
     call pathogen#helptags()

 " } Stratup Pathogen

 "  Environment {

     " Deve essere settata prima di qualsiasi altro impostazione, perchè fa cambiare il senso dei settaggio successivi
     set nocompatible
     " Sets how many lines of history VIM has to remember
     set history=700
     " riapre la navigazione delle directory ricordandosi l'ultima
     set browsedir=last
     " Turn on file type detection
     filetype indent on
     " Enable filetype plugins
     filetype plugin on 
     " Configure backspace so it acts as it should act
     set backspace=eol,start,indent
     " Backspace and cursor keys wrap too
     set whichwrap+=b,s,h,l,<,>,[,]
     " Ignore case when searching
     set ignorecase
     " When searching try to be smart about cases
     set smartcase                                        
     " No annoying sound on errors
     set noerrorbells
     set novisualbell
     set vb t_vb= t_vb=
     " timeoutlen: timeout insert key
     set tm=500
     " Set utf8 as standard encoding and en_US as the standard language
     scriptencoding utf-8
     set encoding=utf-8
     " Set English and Italian language
     set spell spelllang=it,en
     " delete preview from insert mode completion 
     set completeopt-=preview
     " Now, when using :sb, :sbnext, :sbprev instead of :b, :bnext, :bprev to switch buffers, Vim will check if buffer is open in tab/window and switch to that tab/window
     set switchbuf=usetab
     " when file change outside vim, vim reload automatically it
     set autoread
     " disable splell checking
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

     " Use both Unix and DOS file formats, but favor the Unix one for new files.
     if WINDOWS()
         set fileformats=unix,dos
     endif

     if WINDOWS()
         let $PATH = 'C:\APPL\Python27;' . $PATH
         "let $HOME = 'C:\APPL\vim74'
     endif

     " migliora le performance di vim
     syntax sync maxlines=200
     syntax sync minlines=10
     set nocursorline
     " more characters will be sent tothe screen for redrawing, instead of using insert/delete line commands
     set ttyfast
     " Don't redraw while executing macros (good performance config)
     set lazyredraw   

 "  Files, backups and undo {

     " Turn backup off, since most stuff is in SVN, git et.c anyway...
     set nobackup
     set nowb
     set noswapfile
     " Persistent undo
     set undodir=$VIMRUNTIME/undo                         
     set undofile

 " }Files, backups and undo

 "  Tab and indent relate {

     " Use spaces instead of tabs
     set expandtab
     " Be smart when using tabs ;)
     set smarttab
     " 1 tab == 3 spaces
     set shiftwidth=3
     set tabstop=3
     " Line break on 500 characters
     set lbr
     " maximum width of text that is being inserted
     set tw=0
     " Indent at the same level of the previous line
     set ai
     " Smart indent
     set si
     " no wrap lines
     set nowrap

 " }Tab and indent relate

 "  Folding {

    " deepest fold is 10 levels
    set foldnestmax=2       
    " this is just what i use
    set foldlevel=99

    " cosa viene visualizzato quando faccio il folding del codice
    set foldtext=MyFoldText()

    " rimuove i caratteri ----- dopo il fold
    setl fillchars="fold: "

    " fare l'unfold automatico
    set foldopen+=block,insert,jump,mark,percent,quickfix,search,tag,undo

    " abilita il tooltip per vedere cosa c'e dentro il mio fold
     set balloonexpr=FoldSpellBalloon()
     set ballooneval
     set balloondelay=400

 " }Folding

 " }Environment

 "  UI Setting {
 
     " hide toolbar
     set guioptions-=T
     " hide menubar
     set guioptions-=m
     " hide the left-hand scrollbar for splits/new windows
     set guioptions-=L
     " disables the initial message
     set shortmess+=I
     " set width fold column
     set foldcolumn=3
     " set 5 lines to the cursor - when moving vertically using j/k
     set so=5                                             
     " set the terminal's title
     set title
     " turn on the WiLd menu/Enhanced command line completion
     set wildmenu                                         
     " command <Tab> completion, list matches, then longest common part, then all
     set wildmode=list:longest,full

     " ignore compiled files
     set wildignore=*.o,*~,*.pyc,*.png,*.jpg,*.gif
     set wildignore+=log/**
     set wildignore+=vendor/cache/**
     set wildignore+=vendor/rails/**
     set wildignore+=tmp/**
     set wildignore+=log/**


     if has('cmdline_info')
        " Show the line and column number of the cursor position
         set ruler
         " A ruler on steroids
         set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
         " Show partial commands in status line and
         set showcmd
     endif

     " display the current mode
     set showmode                                         
     " height of the command bar
     set cmdheight=1                                      
     " Setta per ogni buffer l'opzione hidden di default, questo mi permette di passare in maniera più pratica tra i buffer(ved. usr_22: nascondere i buffer)
     set hidden                                           
     " highlight search terms
     set hlsearch
     " find as you type search
     set incsearch                                        
     " for regular expressions turn magic on
     set magic                                    
     " show line number
     set number                                           
     " Enable syntax highlighting
     syntax enable

     " Set extra options when running in GUI mode
     if OSX()
         set guioptions-=T
         set guioptions+=e
         set t_Co=256
         set guitablabel=%M\ %t
     endif

     if OSX()
         let macvim_skip_colorscheme = 1    
     endif

     " Always show the status line
     set laststatus=2                                     
     " disables the match brackets
     let g:loaded_matchparen=1

     " improve rendereing font
     if WINDOWS()
         set renderoptions=type:directx,
                     \gamma:1.8,contrast:0.5,geom:1,
                     \renmode:5,taamode:1,level:0.5
     endif

     " set cursor behavior
     set guicursor+=a:blinkon0

     " font used for the line that separates a vertical window 
     set fillchars=vert:\│

 " }UI Setting

 "  Key Setting {

     if OSX()
         let macvim_skip_cmd_opt_movement = 1
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

     " remap ` for to go right position mark 
     map ? `

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

     " apro esplora risorse per aprire il mio file
     map <Leader>o :browse e<cr>

     " open saveas
     map <Leader>s :browse saveas<cr>

     " mi apre subito il mio vimrc
     map <leader>e :e $MYVIMRC<cr>

     " pressing ,ss will toggle and untoggle spell checking
     map <leader>sc :setlocal spell!<cr>

     imap <Esc> <Esc><Esc>

 "  Shortcut => Folding {

     " set key for folding
     nmap z<Left>  zc
     nmap z<Right> zo
     nmap z<Up>    :set foldlevel=1<CR>
     nmap z<Down>  zr

 " }Shortcut => Folding

 "  Shortcut => Moving around {
     " Treat long lines as break lines (useful when moving around in them)
     map j gj
     map k gk

     " go to end line
     map 9 $
     " go to middle line
     map 8 :call cursor(0, virtcol('$')/2)<CR>
     " go go start line
     map 0 ^

     " Per fare lo scroll della pagina si appogia anche al plugin AcceleratedSmoothScroll
     " zz mi centra la pagina sulla riga corrente
     " C-e mi sposto verso giu di una riga
     nmap <leader><leader><Up> <C-b>
     nmap <leader><leader><Down> <C-f>
     nmap <leader><Up> <C-u>
     nmap <leader><Down> <C-d>

     " Remap VIM `. per spostarmi ultima riga modificata
     map <silent><leader>le `.

 " }Shortcut => Moving around 

 "  Shortcut => Buffer & window {
     
     " per spostarmi tra i tab
     nnoremap <silent> <A-Down>  :tabprevious<CR>
     nnoremap <silent> <A-Up> :tabnext<CR>
     inoremap <silent> <A-Down>  :tabprevious<CR>
     inoremap <silent> <A-Up> :tabnext<CR>
     vnoremap <silent> <A-Down>  :tabprevious<CR>
     vnoremap <silent> <A-Up> :tabnext<CR>

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
     map <leader>qa :bufdo bd<cr>
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

 "  Shortcut => Ctags {
 
    " va al tag sotto il cursore
    map <silent><leader><Left> <C-T>
    " va al tag sotto il cursore
    "map <silent><leader><Right> <C-]>

    " alternative to <C-]>
    " place your cursor on an id or class and hit <leader>]
    " to jump to the definition
    map <silent><leader><Right> :tag /<c-r>=expand('<cword>')<cr><cr>

 "}Shortcut => Ctags

 "  Shortcut => Diff mode {
 
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
    let ruby_no_comment_fold = 1
    " aggiungo il supporto ai tag anche per le gemme del progetto
    set tags+=gems.tags                                            

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

"  AirLine {
    if g:sphynx_Active.Airline
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " abilito i font speciali quelli con la path
        let g:airline_powerline_fonts = 1
        " seleziono il tema
        let g:airline_theme     = 'flatlandia'
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
" }AirLine

"  AutoFormat {
    if g:sphynx_Active.Autoformat
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        noremap <F12> :Autoformat<CR><CR>
    endif
" }AutoFormat

"  CtrlSpace {
    if g:sphynx_Active.CtrlSpace
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
" }CtrelSpace

"  Dash {
    if g:sphynx_Active.Dash
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

"  Easytag {
    if g:sphynx_Active.EasyTags
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
" }Easytag

"  Emmet {
    if g:sphynx_Active.Emmet
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }Emmet

"  GoldenRatio {
    if g:sphynx_Active.GoldenRatio
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:golden_ratio_autocommand = 0
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <F7> :GoldenRatioToggle<CR>
    endif
" }Emmet

"  IndentLine {
    if g:sphynx_Active.IndentLine 
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:indentLine_enabled = 0
        let g:indentLine_color_gui = '#0B5E6F'
        let g:indentLine_char = '¦'
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " attiva & disattiva il resize automatico
        nmap <Leader>il :IndentLinesToggle<cr>
    endif
" }IndentLine

"  MakeHeader {
    if g:sphynx_Active.MakeHeader
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:header_comment_author="Boscolo Michele"
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }IndentLine

"  Maximizer {
    if g:sphynx_Active.Maximizer
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:maximizer_set_default_mapping = 0               " disabilito i tasto di default
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <silent><localleader>m :MaximizerToggle<CR>
        vnoremap <silent><localleader>m :MaximizerToggle<CR>gv
    endif
" }Maximizer

"  NerdTree {
    if g:sphynx_Active.Nerdtree
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let NERDTreeQuitOnOpen = 0
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
    if g:sphynx_Active.RainbowParentheses
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            " IMPORTANTE
            " ho settato dei parametri nella sessione Autocmd per attivazione plugin e configurazione
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }RainbowParentheses

"  Signature {
    if g:sphynx_Active.Signature
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:SignatureMap = {
            \ 'GotoNextLineByPos'  :  "m<Right>",
            \ 'GotoPrevLineByPos'  :  "m<Left>"
            \ }
    endif
" }Signature

"  Tabular {
    if g:sphynx_Active.Tabular
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a: :Tabularize /:\zs<CR>
        vmap <Leader>a: :Tabularize /:\zs<CR>
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    endif
" }Tabular

"  Tagbar {
    if g:sphynx_Active.TagBar
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:tagbar_autoclose = 1
        let g:tagbar_usearrows = 1
        let g:tagbar_width=28
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nmap <F3> :TagbarToggle<CR>
    endif
" } Tagbar

"  Tcomment {
    if g:sphynx_Active.TComment
        """""""""""""""""""""""""""""""""""""""""PARAMETRI""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        let g:tcommentMaps = 0
        """""""""""""""""""""""""""""""""""""""""SHORTCUT"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        nnoremap <silent><leader>. :TComment<CR>
        vnoremap <silent><leader>. :TComment<CR>
    endif
" }Tcomment

"  Ultisnip {
    if g:sphynx_Active.Ultisnips
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
    if g:sphynx_Active.Unite
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

"  Youcompleteme {
    if g:sphynx_Active.YouCompleteMeWin || g:sphynx_Active.YouCompleteMeMac
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
        autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

        " Automatically reload vimrc when it's saved
        au BufWritePost .vimrc source ~/.vimrc| set foldlevel=0 |AirlineRefresh
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
            set ttimeoutlen=11
            au InsertEnter * set timeoutlen=0
            au InsertLeave * set timeoutlen=1000
        endif
 
        " ULTISNIP ==> Viene utilizzato per migliorare l'integrazione con youcompleteme
        if g:sphynx_Active.Ultisnips
          au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
          au BufEnter * exec "inoremap <silent> " . g:UltiSnipsJumpBackwardTrigger . " <C-R>=g:UltiSnips_Reverse()<cr>"
        endif

        " Funzione che crea 'header per i miei file
        autocmd BufNewFile *.rb,*.rbw,*.haml,*.html.erb,*.erb silent call MakeFileHeader()

        " salvataggio automatico dei file
        autocmd Bufwritepre,filewritepre,FocusLost * silent call  Autosave()
        autocmd VimLeave  * :bufdo call Autosave()

    augroup END

" }Autocmd

"  Helper functions {

    function! MyFoldText()
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
    function! FoldSpellBalloon()
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
    endfunction
    


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

    " Controlla se il file è stato modificato aggiorna l'header se presente, salva il file
    function! Autosave ()
        if &modified
             silent call UpdateHeader()
             write
        endif
    endfunction


" }Helper functions



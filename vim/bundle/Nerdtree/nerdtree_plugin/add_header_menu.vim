" ============================================================================
" File:        add_header_menu.vim
"
" ============================================================================
if exists("g:loaded_nerdtree_add_header_menu")
    finish
endif
let g:loaded_nerdtree_add_header_menu = 1
     
call NERDTreeAddMenuItem({'text': '(h)Add new file with header', 'shortcut': 'h', 'callback': 'NERDTreeAddHeader'})
 
" FUNCTION: NERDTreeAddHeader() 
function! NERDTreeAddHeader()
    let curDirNode = g:NERDTreeDirNode.GetSelected()

    let newNodeName = input("Add a childnode\n".
                          \ "==========================================================\n".
                          \ "Enter the dir/file name to be created. Dirs end with a '/'\n" .
                          \ "", curDirNode.path.str() . g:NERDTreePath.Slash(), "file")

    if newNodeName ==# ''
        echohl WarningMsg | echo "Node Creation Aborted." | echohl None
        return 
    endif

    try
        let newPath = g:NERDTreePath.Create(newNodeName)
        let parentNode = b:NERDTreeRoot.findNode(newPath.getParent())

        let newTreeNode = g:NERDTreeFileNode.New(newPath)
        if empty(parentNode)
            call b:NERDTreeRoot.refresh()
            call b:NERDTree.render()
        elseif parentNode.isOpen || !empty(parentNode.children)
            call parentNode.addChild(newTreeNode, 1)
            call NERDTreeRender()
            call newTreeNode.putCursorHere(1, 0)
            call newTreeNode.open({'where': 'h'})
            if (&ft=='ruby' || &ft=='rbw' || &ft=='haml' || &ft=='eruby.html')
                silent call MakeFileHeader()
            endif
        endif
    catch 
        echohl WarningMsg | echo "Node Not Created." | echohl None
    endtry
endfunction


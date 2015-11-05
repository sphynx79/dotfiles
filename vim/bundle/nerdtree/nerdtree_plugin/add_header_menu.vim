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
        call s:echo("Node Creation Aborted.")
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
            call newTreeNode.openVSplit()
            if (&ft=='ruby' || &ft=='rbw')
                call MakeFileHeader('=begin','','=end')
            elseif (&ft=='haml')
                call MakeFileHeader('-#','-#','-#')
            elseif (&ft=='eruby.html')
                call MakeFileHeader('<%#','#','%>')
            endif

        endif
    catch /^NERDTree/
        call s:echoWarning("Node Not Created.")
    endtry 
endfunction

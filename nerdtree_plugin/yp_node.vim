if exists('g:loaded_nerdtree_yp_node')
  finish
endif
let g:loaded_nerdtree_yp_node = 1
let g:nerd_yanked_path = ''

" NERDTreeYankNode {{{1
call NERDTreeAddMenuItem({
  \ 'text'     : '(y)ank file',
  \ 'shortcut' : 'y',
  \ 'callback' : 'NERDTreeYankNode'})

function! NERDTreeYankNode()
  let l:currentNode = g:NERDTreeFileNode.GetSelected()
  let g:nerd_yanked_path = l:currentNode.path.str()
endfunction


" NERDTreePasteNode {{{1
call NERDTreeAddMenuItem({
  \ 'text'     : '(p)aste yanked file',
  \ 'shortcut' : 'p',
  \ 'callback' : 'NERDTreePasteNode'})

function! NERDTreePasteNode()
  if g:nerd_yanked_path ==# ''
    echohl ErrorMsg | echo 'You have to yank command!' | echohl None
    return
  endif

  let l:currentNode = g:NERDTreeFileNode.GetSelected()
  let l:dest_path = l:currentNode.path.isDirectory ?
    \ l:currentNode.path.str() : l:currentNode.path.getParent().str()

  let l:dest_path .= '/' . fnamemodify(g:nerd_yanked_path, ':t')

  " Check already exists file and confirm overwrite.
  if filereadable(l:dest_path)
    let l:confirmed = 0

    echohl ErrorMsg | echo 'Overwrite ' . l:dest_path . '?'  | echohl None
    let l:choice = input('[yes/no]: ')
    let l:confirmed = l:choice ==# 'yes'

    if !l:confirmed | return | endif
  endif

  execute '!cp -r' g:nerd_yanked_path l:dest_path
  call b:NERDTree.root.refresh()
  call b:NERDTree.render()
  redraw

  echo 'Copied' g:nerd_yanked_path
endfunction
" }}}1

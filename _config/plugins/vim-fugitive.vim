scriptencoding utf-8
UsePlugin 'vim-fugitive'

" タブで開く
function! s:gstatus() abort
  let l:path = fugitive#Find('.git/index')
  let l:repo_path = fnamemodify(fugitive#repo().dir(), ':h')
  let l:cur_path = expand('%:p')

  if vimrc#find_visible_file(l:path)
    execute 'drop ' . l:path
    execute 'edit!'
  else
    try
      Git
      "wincmd T
    catch /.*/
      echomsg v:errmsg
    endtry
  endif

  " カーソル移動して、 diff を表示
  if l:cur_path =~# '^' .. l:repo_path
    call search(l:cur_path[len(l:repo_path)+1:] .. '$')
    " " diff を表示
    " normal >
  endif
endfunction
 "nnoremap <silent> <Space>gs :<C-u>Gstatus<CR>\|:wincmd T<CR>
 nnoremap <silent> <Space>gs :<C-u>call <SID>gstatus()<CR>
"nnoremap <Space>gs <Cmd>Git<CR>

" Gstatus のウィンドウ内で実行できるマッピング
" > , < diff の表示
" =     diff のの切り替え
" a     add
" -     stage/unstage 切り替え

" J/K  hung の移動

function! s:fugitive_my_settings() abort
  nnoremap <buffer>           <C-q> <C-w>q
  nnoremap <buffer>           q     <C-w>q
  nnoremap <buffer><silent>   ?     :<C-u>help fugitive-maps<CR>
  nnoremap <buffer>           s     s

  setlocal cursorline
endfunction


augroup MyFugitive
  autocmd!
  autocmd FileType fugitive call s:fugitive_my_settings()
augroup END

command! GitAdd execute 'Git add %'

scriptencoding utf-8

" =================================================
" バックスラッシュをスラッシュにして返す
" =================================================
function! vimrc#get_fullpath(path) abort
  return tr(expand(a:path), "\\", '/')
endfunction

"
" -------------------------------------------------
" バッファが表示されているか返す
" -------------------------------------------------
function! vimrc#find_visible_file(path) abort
  for l:buf in getbufinfo({'buflisted': 1})
    if vimrc#get_fullpath(l:buf.name) ==# a:path &&
    \   !empty(l:buf.windows)
      return 1
    endif
  endfor
  return 0
endfunction


" =================================================
" :drop or :tabedit のどっちか
" =================================================
function! vimrc#drop_or_tabedit(path) abort
  let l:path = vimrc#get_fullpath(a:path)
  if vimrc#find_visible_file(l:path)
    execute 'drop ' . l:path
  else
    execute 'tabedit ' . l:path
  endif
endfunction


" =================================================
" 最後に選択した文字列を取得する
" =================================================
function! vimrc#getwords_last_visual() abort
  let l:reg = '"'
  " save
  let l:save_reg = getreg(l:reg)
  let l:save_regtype = getregtype(l:reg)
  let l:save_ve = &virtualedit

  set virtualedit=

  silent exec 'normal! gv"'.l:reg.'y'
  let l:result = getreg(l:reg, 1)

  " resotore
  call setreg(l:reg, l:save_reg, l:save_regtype)
  let &virtualedit = l:save_ve

  return l:result
endfunction

" " コマンドがないと怒られるため
" function! vimrc#delcommand(cmd) abort
"     if exists(':'.a:cmd) ==# 2
"         execute 'delcommand '.a:cmd
"     endif
" endfunction

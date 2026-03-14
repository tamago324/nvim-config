scriptencoding utf-8
UsePlugin 'vim-sandwich'

" sr と sd は置換、削除したい文字を入力するだけでいい
"   sr'"   -> 周りの ' を " に置換
"   sd'    -> 周りの ' を削除
"   sdf    -> 関数を削除
"   sdt    -> タグを削除

" vi'  -> 周りの ' の中を選択

augroup sandwich-ft-python
  autocmd!
  autocmd Filetype python let b:sandwich_magicchar_f_patterns = [
  \   {
  \       'header' : '\<\%(\h\k*\.\)*\h\k*',
  \       'bra'    : '(',
  \       'ket'    : ')',
  \       'footer' : '',
  \   },
  \]
augroup END

let g:textobj_sandwich_no_default_key_mappings = 1

" vib とかで選択できる
omap ib <Plug>(textobj-sandwich-auto-i)
xmap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)
xmap ab <Plug>(textobj-sandwich-auto-a)

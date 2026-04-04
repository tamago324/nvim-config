scriptencoding utf-8

augroup MyAutoCmd
  autocmd!
augroup END

" 自動でコメント開始文字を挿入しないようにする
autocmd MyAutoCmd FileType * setlocal formatoptions-=r formatoptions-=o


"   expandtab   タブ入力を複数の空白入力に置き換える
"   tabstop     実際に挿入されるスペースの数
"   shiftwidth  (auto)indent、<<,>> で使われるスペースの数
"   softtabstop <Tab> <BS> を押したときのカーソル移動の幅
" autocmd MyAutoCmd FileType java         setlocal sw=2 sts=2 ts=2 et
" autocmd MyAutoCmd FileType vim          setlocal sw=4 sts=4 ts=4 et

autocmd MyAutoCmd FileType blade        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType c            setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType css          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType ctp          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType firestore    setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType graphql        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType html         setlocal sw=2 sts=2 ts=4 et
autocmd MyAutoCmd FileType htmldjango   setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType java         setlocal sw=4 sts=4 ts=4 noexpandtab
autocmd MyAutoCmd FileType javascript   setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType js           setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType json         setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType kotlin       setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType lua          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType markdown     setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType nim          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType ocaml        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType org          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType php          setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType pl0          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType python       setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType rust         setlocal sw=4 sts=4 ts=4 et
autocmd MyAutoCmd FileType scss         setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType sh           setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType sml          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType smlnj        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType sql          setlocal sw=2 sts=2 ts=2 et
" autocmd MyAutoCmd FileType typescript.tsx        setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType typescript   setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType vim          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType vue          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType yaml         setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType typescriptreact setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType jsx          setlocal sw=2 sts=2 ts=2 et
autocmd MyAutoCmd FileType javascriptreact setlocal sw=2 sts=2 ts=2 et


" 拡張子をもとにファイルタイプを設定
autocmd MyAutoCmd BufRead,BufWinEnter *.ini     setlocal filetype=dosini
autocmd MyAutoCmd BufRead,BufWinEnter *.csv     setlocal filetype=csv
autocmd MyAutoCmd BufRead,BufWinEnter *.jsx     setlocal filetype=jsx
autocmd MyAutoCmd BufRead,BufWinEnter *.pl0     setlocal filetype=pl0
autocmd MyAutoCmd BufRead,BufWinEnter *.ml      setlocal filetype=sml
autocmd MyAutoCmd BufRead,BufWinEnter *_spec.rb setlocal filetype=ruby.rspec
autocmd MyAutoCmd BufRead,BufWinEnter *_test.go setlocal filetype=go.test
autocmd MyAutoCmd BufRead,BufWinEnter .babelrc  setlocal filetype=json
autocmd MyAutoCmd BufRead,BufWinEnter my.cnf    setlocal filetype=dosini
autocmd MyAutoCmd BufRead,BufWinEnter *.blade.php setlocal filetype=blade
" autocmd MyAutoCmd BufRead,BufWinEnter *.tsx setlocal filetype=typescript.tsx

" autocmd MyAutoCmd BufWinEnter,BufNewFile *_spec.rb setlocal filetype=ruby.rspec

" ファイル名を元にファイルタイプを設定
autocmd MyAutoCmd BufRead,BufWinEnter Vagrantfile set ft=ruby

" xxx-xxx もキーワードとして認識させる
autocmd MyAutoCmd FileType scss setlocal iskeyword+=-

" ====================
" cmdline-window コマンドラインウィンドウ
" ====================
function! s:save_global_options(...) abort
  let s:save_opts = {}
  let l:opt_names = a:000

  for l:name in l:opt_names
    execute 'let s:save_opts[l:name] = &'.l:name
  endfor
endfunction

function! s:restore_global_options() abort
  " global じゃないときはどうしよっかって感じだけど
  for [l:key, l:val] in items(s:save_opts)
    execute 'set '.l:key.'='.l:val
  endfor
endfunction

function! CmdlineEnterSettings() abort
  " いらない
  nnoremap <buffer> <C-l> <Nop>
  nnoremap <buffer> <C-i> <Nop>

  " 移動
  inoremap <buffer> <C-j> <Esc>j
  inoremap <buffer> <C-k> <Esc>k
  nnoremap <buffer> <C-j> j
  nnoremap <buffer> <C-k> k

  " 終了
  nnoremap <buffer> q     :<C-u>quit<CR>
  inoremap <buffer> <C-q> <Esc>:<C-u>quit<CR>
  nnoremap <buffer> <C-q> :<C-u>quit<CR>

  inoremap <buffer> <CR>  <C-c><CR>

  " global options
  call s:save_global_options(
  \ 'backspace',
  \ 'completeopt'
  \)
  " insertモード開始位置より左を削除できるようにする
  set backspace=start

  set completeopt=menu

  " local options
  " setlocal signcolumn=no
  setlocal nonumber

  " insertモードで開始
  " startinsert!
endfunction

function! CmdlineLeaveSettings() abort
  call s:restore_global_options()
endfunction

" 明日から使える Command-line window テクニック @monaqa
" https://bit.ly/2qybcv3
function! CmdlineRemoveLinesExec() abort
  " いらないものを消す
  let l:patterns = [
  \   '\v^wq?!?',
  \   '\v^qa?!?',
  \]

  for l:pattern in l:patterns
    call execute('g/'.l:pattern.'/"_d', 'silent')
  endfor

  " 一番下に移動
  silent normal! G
  if !has('nvim')
    call cursor(line('.'), s:cmdline_cursor_pos)
  endif
endfunction


augroup MyCmdWinSettings
  autocmd!
  autocmd CmdwinEnter * call CmdlineEnterSettings()
  autocmd CmdwinLeave * call CmdlineLeaveSettings()
  autocmd CmdwinEnter : call CmdlineRemoveLinesExec()
augroup END


" ====================
" カーソルラインの位置を保存する
" from skanehira/dotfiles (http://bit.ly/2N82age)
" ====================
autocmd MyAutoCmd BufReadPost *
\   if line("'\"") > 0 && line("'\"") <= line("$") |
\     exe "normal! g'\"" |
\   endif

autocmd MyAutoCmd StdinReadPost * set nomodified

" " ====================
" " diffthis しているときにテキスト更新したら diffupdate
" " http://bit.ly/2wxMnCa
" " ====================
" function! s:auto_diffupdate() abort
"   if &diff
"     diffupdate
"   endif
" endfunction
" autocmd MyAutoCmd TextChanged * call s:auto_diffupdate()


" ====================
" ディレクトリ自動生成
"   https://github.com/skanehira/dotfiles/blob/1a311030cbd201d395d4846b023156f346c6a1aa/vim/vimrc#L384-L394
" ====================
function! s:auto_mkdir(dir)
  if !isdirectory(a:dir)
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
augroup my-auto-mkdir
  au!
  au BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'))
augroup END


" ====================
" ファイル閉じても、undoできるようにする
" ====================
if has('persistent_undo')
  if !isdirectory($HOME.'/.cache/nvim/undo')
    call mkdir($HOME.'/.cache/nvim/undo', 'p')
  endif
  set undodir=$HOME/.cache/nvim/undo
  augroup MyAutoCmdUndofile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif


" ====================
" IME を自動で OFF
" ====================
let s:im_disable_script_path = expand('<sfile>:h:h') .. '/ahk/imDisable.ahk'

function! s:isWSL() abort
  return isdirectory('/run/WSL')
endfunction

let s:ahk_exe_path = ''
if s:isWSL()
  let s:ahk_exe_path = '/mnt/c/Program Files/AutoHotkey/AutoHotkeyU64.exe'
elseif has('win64')
  let s:ahk_exe_path = 'C:\Program Files\AutoHotkey\AutoHotkey.exe'
endif

if executable(s:ahk_exe_path)
  augroup my-InsertLeave-ImDisable
    autocmd!
    autocmd InsertLeave * :call system(printf('%s "%s"', shellescape(s:ahk_exe_path), s:im_disable_script_path))
  augroup END
endif


" ===================
" ヤンクのハイライト
" ===================
augroup my-highlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="Visual", timeout=90}
augroup END


" =============================================================================
" FileType
"   from https://zenn.dev/rapan931/articles/081a302ed06789
" =============================================================================
augroup my_filetypes
  autocmd!
  autocmd FileType * call <SID>autocmd_filetypes(expand('<amatch>'))
augroup END
function! s:autocmd_filetypes(ft) abort
  let l:ft = substitute(a:ft, '\.', '__', 'g')
  if !empty(l:ft) && exists(printf('*s:my_ft_%s', l:ft))
    execute printf('call s:my_ft_%s()', l:ft)
  endif
endfunction


" ====================
" help
" ====================
function! VimDocFormat() abort range
  " range をつけると、 a:firstline と a:lastline が使える
  let l:pos = getcurpos()
  for l:lnum in range(a:firstline, a:lastline)
    let l:line = getline(l:lnum)
    if l:line =~# '\*$'
      let l:space_cnt = &textwidth - strdisplaywidth(substitute(l:line, '\v\s*\ze\*[^*]+\*$', '', 'g'))
      " ** が非表示になるため、 +2 する
      " let l:space_cnt += 2
      " let l:new_line = substitute(l:line, '\v^[[:graph:]]+\zs\s+', repeat(' ', l:space_cnt), '')
      let l:new_line = substitute(l:line, '\v\s+\ze\*[^*]+\*$', repeat(' ', l:space_cnt), '')
      call setline(l:lnum, l:new_line)
    endif
  endfor
  call setpos('.', l:pos)
  echo '[VimDocFormat] Formatted!'
endfunction

function! s:my_ft_help() abort
  " help を q で閉じれるようにする
  nnoremap <buffer> q <C-w>c

  command! -range VimDocFormat <line1>,<line2>call VimDocFormat()
  nnoremap <buffer> <Space>rf :<C-u>%VimDocFormat<CR>
  xnoremap <buffer> <Space>rf :VimDocFormat<CR>
endfunction


" ====================
" quickfix
" ====================

" bqf を使うため、不要
" " https://github.com/neovim/neovim/pull/13079 がマージされないといけない...
" function! s:colder() abort
"   if getqflist({'nr': 0}).nr ==# 1
"     " execute getqflist({'nr': '$'}).nr .. 'chistory'
"   else
"     execute 'colder'
"   endif
" endfunction
"
" function! s:cnewer() abort
"   if getqflist({'nr': 0}).nr ==# getqflist({'nr': '$'}).nr
"     " execute '1chistory'
"   else
"     execute 'cnewer'
"   endif
" endfunction

" function! s:cursor_move(direction) abort
"   if a:direction ==# 'j'
"     call search('\v^[^|]+\|\d+ col \d+\|')
"     " call search('^[^\|]')
"   elseif a:direction ==# 'k'
"     call search('\v^[^|]+\|\d+ col \d+\|', 'b')
"     " call search('^[^\|]', 'b')
"   endif
" endfunction

function! s:my_ft_qf() abort
  " nnoremap <buffer>         p         <CR>zz<C-w>p
  nnoremap <buffer><silent> q         :<C-u>quit<CR>
  nnoremap <buffer><silent> <A-q>     :<C-u>quit<CR>

  nnoremap <buffer><silent> j  j
  nnoremap <buffer><silent> k  k
  nnoremap <buffer><silent> gj gj
  nnoremap <buffer><silent> gk gk

  nnoremap <buffer><silent> <Right> <Cmd>cnewer<CR>
  nnoremap <buffer><silent> <Left> <Cmd>colder<CR>

  nnoremap <buffer><silent> <Space>fq <Cmd>lua require'plugins.telescope_nvim'.quickfix_in_qflist()<CR>

  " nnoremap <Plug>(qfpreview-toggle-auto-show) :<C-u>lua require'vimrc.qfpreview'.toggle_auto_preview()<CR>
  " nnoremap <Plug>(qfpreview-show)             :<C-u>lua require'vimrc.qfpreview'.show()<CR>
  " nnoremap <Plug>(qfpreview-goto-preview-win) :<C-u>noautocmd call win_gotoid(bufwinid(t:qfpreview_bufnr))<CR>
  "
  " nmap <buffer>         <A-k> <Plug>(qfpreview-toggle-auto-show)
  " nmap <buffer><silent> <A-f> <Plug>(qfpreview-show)
  " nmap <buffer><silent> <A-p> <Plug>(qfpreview-goto-preview-win)
  "
  " command! -buffer ToggleQfPreview lua require'vimrc.qfpreview'.toggle_auto_preview()<CR>
  "
  " nnoremap <buffer><silent> <CR> :<C-u>lua require'vimrc.qfpreview'.edit()<CR>

  nnoremap <buffer> <C-j> <Cmd>call search('^[^\\|]')<CR>
  nnoremap <buffer> <C-k> <Cmd>call search('^[^\\|]', 'b')<CR>

  nnoremap <buffer> <Space>ff :Cfilter

  " quickfix とじる
  " nnoremap <buffer> <A-d> <Cmd>lclose<CR>

  wincmd J
  resize 20
  setlocal signcolumn=no
  setlocal cursorline
  setlocal number
  setlocal nowrap

  " lua require('lir.float').close()
endfunction

augroup my-quickfix-cmd-post
  autocmd!
  " grepし終わったら、quickfix ウィンドウを開く
  autocmd QuickFixCmdPost *grep* cwindow
augroup END



" ====================
" json
" ====================
function! s:my_ft_json() abort
  " // をコメントとする
  syntax match Comment +\/\/.\+$+
  setlocal concealcursor=nc
endfunction


" ====================
" gitconfig
" ====================
function! s:my_ft_gitconfig() abort
  setlocal noexpandtab
endfunction


" ====================
" scheme
" ====================
function! s:my_ft_scheme() abort
  " let g:paredit_mode = 1
  " call PareditInitBuffer()
endfunction


" lexima を使ってやることにした
" " ====================
" " markdown
" " ====================
" function! s:my_ft_markdown() abort
"   function! s:markdown_space() abort
"     let l:col = getpos('.')[2]
"     " 先頭でリストではなかったら、* とする
"     if l:col ==# 1 && getline('.') !~# '^\s*\* .*'
"       return '* '
"     endif
"
"     " インデント
"     let l:line = getline('.')[:l:col]
"     if l:line =~# '\v^\s*\* \s*$'
"       return "\<C-t>"
"     endif
"     return "\<Space>"
"   endfunction
"
"   inoremap <buffer>        <Tab>   <C-t>
"   inoremap <buffer>        <S-Tab> <C-d>
"   inoremap <buffer> <expr> <Space> <SID>markdown_space()
"   " inoremap <buffer> <expr> <CR>    <SID>cr()
"
"   function! s:markdown_cr() abort
"     let l:line = getline('.')
"     let l:col = getpos('.')[2]
"     " 先頭が * and 末尾にカーソルがあるとき
"     if l:line =~# '\v^\s*\*' && l:line[l:col:] ==# ''
"       return "\<C-o>:InsertNewBullet\<CR>"
"     endif
"     return "\<CR>"
"   endfunction
"
"   if exists('g:loaded_bullets_vim')
"     inoremap <silent> <buffer> <expr> <CR> <SID>markdown_cr()
"     nnoremap <silent> <buffer> o    :<C-u>InsertNewBullet<CR>
"     " vnoremap <silent> <buffer> gN   <C-u>:RenumberSelection<CR>
"     " nnoremap <silent> <buffer> gN   <C-u>:RenumberList<CR>
"     " nnoremap <silent> <buffer> <Space>x <C-u>:ToggleCheckbox<CR>
"   endif
" endfunction
" ====================
" markdown
" ====================
function! s:my_ft_markdown() abort
  setlocal concealcursor=n

  " nnoremap <buffer> <Left> Nzz
  " nnoremap <buffer> <Right> nzz
  " nnoremap <buffer> N Nzz
  " nnoremap <buffer> n nzz
endfunction


" ====================
" python
" ====================
function! s:python_send_lines() abort
  let l:colon = v:false
  let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
  for l:line in l:lines
    call deol#send(l:line)
    sleep 50ms
  endfor
endfunction

function! s:my_ft_python() abort
  " " from jedi-vim
  " function! s:smart_auto_mappings() abort
  "     let l:line = line('.')
  "     let l:completion_start_key = "\<C-Space>"
  "     if search('\m^\s*from\s\+[A-Za-z0-9._]\{1,50}\%#\s*$', 'bcn', l:line)
  "         return "\<Space>import\<Space>"
  "     return "\<Space>"
  " endfunction
  "
  " imap <silent> <buffer> <expr> <Space> <SID>smart_auto_mappings()

  "nnoremap <buffer><silent> ,f :<C-u>call deol#send(getline('.'))<CR>
  "vnoremap <buffer><silent> ,f :<C-u>call <SID>python_send_lines()<CR>
  vnoremap <buffer><silent> <Space>rf :<C-u>silent !black %<CR>
endfunction


" ====================
" sql
" ====================
function! s:my_ft_sql() abort
  nnoremap <Space>rf :<C-u>SQLFmt<CR>

  if !empty(globpath(&rtp, 'autoload/nrrwrgn.vim'))
    vnoremap <Space>rf :NR<CR> \| :SQLFmt<CR> \| :write<CR> \| :close<CR>
  endif

  if FindPlugin('formatter.nvim')
    augroup sql-formatter
      autocmd!
      autocmd BufWritePost <buffer> lua my_format_write()
    augroup END
  endif
endfunction


" ====================
" sml
" ====================

" --------------------
" 複数行送信
" --------------------
function! s:sml_send_lines() abort
  let l:colon = v:false
  let l:lines = getline(getpos("'<")[1], getpos("'>")[1])
  for l:line in l:lines
    call deol#send(l:line)
    sleep 50ms
  endfor
  if l:lines[-1] !~# ';$'
    call deol#send(';')
  endif
endfunction

" --------------------
" 選択範囲でフォーマット
" --------------------
function! s:vsmlformat() abort
  let l:cmd = winrestcmd()
  :'<,'>NarrowRegion
  SmlFormat
  wq
  exec l:cmd
endfunction
command! -range VSmlFormat call <SID>vsmlformat()

function! s:start_sml() abort
  new
  Deol -command=sml -no-start-insert -no-edit
  wincmd w
endfunction


function! s:my_ft_smlnj() abort
  nnoremap <buffer>         <Space>rf :<C-u>SmlFormat<CR>
  vnoremap <buffer><silent> <Space>rf :<C-u>VSmlFormat<CR>
  nnoremap <buffer><silent> <Space>re :<C-u>call <SID>start_sml()<CR>

  iabbrev <buffer> func fun

  " deol.nvim との連携
  " send all
  nnoremap <buffer><silent> ,a :<C-u>call deol#send('use "' . expand("%:p:t") . '";')<CR>
  " send line
  nnoremap <buffer><silent> ,f :<C-u>call deol#send('' . getline('.') . (getline('.') =~# ';$' ? '' : ';'))<CR>
  vnoremap <buffer><silent> ,f :<C-u>call <SID>sml_send_lines()<CR>

  " off autopairs
  inoremap <buffer> ' '
endfunction

function! s:my_ft_sml() abort
  call s:my_ft_smlnj()
endfunction


" ====================
" c
" ====================
function! s:my_ft_c() abort
  " https://github.com/neovim/neovim/blob/master/CONTRIBUTING.md#style
  " Neovim のため
  if !empty(findfile('.clang-format', ';'))
    setlocal formatprg=clang-format\ -style=file
  endif
  let b:caw_oneline_comment = '// %s'
  let b:caw_wrap_oneline_comment = '// %s'
endfunction
function! s:my_ft_cpp() abort
  call s:my_ft_c()
endfunction


" ====================
" diff
" ====================
function! s:my_ft_diff() abort
  nnoremap <buffer><silent> <A-j> :<C-u>call search('^--- a', 'W')<CR>
  nnoremap <buffer><silent> <A-k> :<C-u>call search('^--- a', 'Wb')<CR>
  nnoremap <buffer><silent> ? :<C-u>LeaderfPatchFiles<CR>
endfunction


" ====================
" patch
" ====================
augroup MyLfPatch
  autocmd!
  autocmd BufEnter *.patch nnoremap <silent><buffer> ? :<C-u>LeaderfPatchFiles<CR>
augroup END


" ====================
" git
" ====================
function! s:my_ft_git() abort
  nnoremap <silent><buffer> ? :<C-u>LeaderfPatchFiles<CR>
endfunction


" ====================
" lua
" ====================
function! s:my_ft_lua() abort
  " nnoremap <buffer><silent> <Space>vs. :<C-u>luafile %<CR>
  nnoremap <buffer><silent> <Space>vs. <Cmd>call LoadLuaScript()<CR>

  " nnoremap <buffer><silent> <Space>rr  :<C-u>luafile %<CR>
  "nnoremap <buffer><silent> <Space>rf <Cmd>call <SID>equal_format()<CR>
  "xnoremap <buffer><silent> <Space>rf <Cmd>call <SID>equal_format()<CR>

  nnoremap <buffer><silent> <Space>bf :<C-u>silent lmake\| lopen<CR>

  " if exists(':AlterCommand')
  "   call altercmd#define('<buffer>', 'so', 'luaf')
  " endif
endfunction

function! LoadLuaScript() abort
  let l:module_name = substitute(expand('%:p:r'), g:vimfiles_path .. '/lua/', '', '')
  if empty(l:module_name)
    return
  endif

  exec printf('lua package.loaded["%s"] = nil', l:module_name)
  exec printf('lua require"%s"', l:module_name)

  echo 'loaded'
endfunction


" ====================
" neosnippet
" ====================
function! s:my_ft_neosnippet() abort
  " setlocal noexpandtab
  nnoremap <buffer> ? :<C-u>h neosnippet<CR> \| <C-w>L<CR>
endfunction


" ====================
" gitcommit
" ====================
function! s:my_ft_gitcommit() abort
  setlocal textwidth=72
  " 自動で折り返しを行う
  setlocal formatoptions+=t
  setlocal spell spelllang=en_us

  "inoremap <C-l><C-o> <Cmd>lua require'plugins.telescope_nvim'.git_commit_prefix()<CR>

  startinsert!
  "call feedkeys("\<C-l>\<C-o>")
endfunction

" ====================
" vim
" ====================
function! s:equal_format() abort
  let l:winview = winsaveview()
  if mode() =~? 'v'
    normal! =
  else
    normal! ggVG=
  endif
  call winrestview(l:winview)
endfunction
function! s:my_ft_vim() abort
  "nnoremap <buffer><silent> <Space>rf <Cmd>call <SID>equal_format()<CR>

  " if exists(':AlterCommand')
  "   call altercmd#define('<buffer>', 'so', 'so %')
  " endif

  " tagfunc を初期設定にする
  setlocal tagfunc&

endfunction



" ====================
" rust
" ====================
command! QCargoRun call QCrun()
command! QCargoTest call QCrun({'type': 'test'})
function! QCrun(...) abort
  let l:opts = get(a:, 1, {})

  let l:curwin = win_getid()
  let l:result_bufnr = v:null
  for l:win in nvim_tabpage_list_wins(0)
    let l:bufnr = nvim_win_get_buf(l:win)

    " 100:cargo run みたいなバッファを探す
    if bufname(l:bufnr) =~# '\v\d+:cargo '
      " もし、あれば移動する
      let l:result_bufnr = l:bufnr
      break
    endif
  endfor

  let l:cmd = 'run'
  let l:args = ''

  " cmd
  if get(l:opts, 'type', '') ==# 'test'
    let l:cmd = 'test'
  else
    " args
    if expand('%:p:h:t') ==# 'examples'
      let l:args = ' --example ' .. substitute(expand('%:p:t'), '.rs', '', '')
    endif
  endif

  if l:result_bufnr == v:null
    execute '15 new'
  else
    execute printf('noautocmd %d wincmd w', bufwinnr(l:bufnr))
  endif

  execute printf('terminal cargo %s %s', l:cmd, l:args)
  setlocal nobuflisted
  call win_gotoid(l:curwin)
endfunction

function! s:my_ft_rust() abort
  nnoremap <buffer>         <Space>rf :<C-u>RustFmt<CR>
  nnoremap <buffer><silent> <Space>rr :<C-u>QCargoRun<CR>
  nnoremap <buffer><silent> <Space>rt :<C-u>QCargoTest<CR>

  " xnoremap <buffer> <A-d> :<C-u>execute printf('OpenBrowserSmartSearch -rust_doc_std %s', vimrc#getwords_last_visual())<CR>
  " nnoremap <buffer> <A-d> :<C-r>=printf('OpenBrowserSmartSearch -rust_doc_std ')<CR>
endfunction


" ====================
" zsh
" ====================
function! s:my_ft_zsh() abort
  " treesitter を使ってしまうと、入らないため
  " setlocal iskeyword+=-
endfunction


" ====================
" make
" ====================
function! s:my_ft_make() abort
  setlocal iskeyword+=-
endfunction


"" ====================
"" TelescopePrompt
"" ====================
"function! s:my_ft_TelescopePrompt() abort
"  inoremap <buffer> <C-o> <C-r>+
"endfunction


" ====================
" nlsp.log 用
" ====================
function! s:nlsp_log() abort
  syntax match Green /\v^..DEBUG[^\t]+\ze\t/
  syntax match Yellow /\v^..WARN[^\t]+\ze\t/
  syntax match Aqua /\v^..INFO[^\t]+\ze\t/
  syntax match Red /\v^..ERROR[^\t]+\ze\t/

  " syntax match Underlined /\v^[^\t]+\ze\t/
  " syntax match Red /^\[ ERROR \] .*/
  syntax match Comment ?\v.*"\$/status/report".*?
  syntax match Title /client <--- server/
endfunction
autocmd MyAutoCmd BufRead,BufWinEnter nlsp.log,lsp.log call <SID>nlsp_log()

" augroup MyNlsp
"   autocmd!
"   autocmd User NLspProgressUpdate echomsg 'hello'
" augroup END


" command! QZigTest call QZigTest()
" function! QZigTest() abort
"   let l:curwin = win_getid()
"   let l:result_bufnr = v:null
"   for l:win in nvim_tabpage_list_wins(0)
"     let l:bufnr = nvim_win_get_buf(l:win)
"
"     " 100:cargo run みたいなバッファを探す
"     if bufname(l:bufnr) =~# '\v\d+:zig '
"       " もし、あれば移動する
"       let l:result_bufnr = l:bufnr
"       break
"     endif
"   endfor
"
"   let l:fname = expand('%:p')
"
"   if l:result_bufnr == v:null
"     execute '15 new'
"   else
"     execute printf('noautocmd %d wincmd w', bufwinnr(l:bufnr))
"   endif
"
"   execute printf('terminal zig test %s', l:fname)
"   setlocal nobuflisted
"   call win_gotoid(l:curwin)
" endfunction

command! -nargs=? SandboxEdit call s:sandbox_edit(<q-args>)
function! s:sandbox_edit(file) abort
  " sandbox-zig をeditする
  let l:sandbox_zig_path = expand('~/ghq/github.com/tamago324/sandbox-zig/sandbox')
  if a:0 == 0
    execute printf('new %s', l:sandbox_zig_path)
    return
  endif
  execute printf('edit %s/%s', l:sandbox_zig_path, a:file)
endfunction

function! s:my_ft_zig() abort
  nnoremap <buffer> <Space>rt <Cmd>QuickRun zig/test<CR>
  nnoremap <buffer> <Space>rm <Cmd>Make<CR>
  nnoremap <buffer> <Space>rs <C-u>:SandboxEdit 
endfunction



function! PrettierFormat() abort range
  let l:view = winsaveview()
  execute printf('%s,%s! prettier %s', a:firstline, a:lastline, expand('%:p'))
  call winrestview(l:view)
endfunction

function! s:my_ft_vue() abort
  command! -range=% PrettierFormat <line1>,<line2>call PrettierFormat()
  nnoremap <buffer> <Space>rf <Cmd>PrettierFormat<CR>
endfunction


" https://reviewdog.github.io/errorformat-playground/

" https://qiita.com/rbtnn/items/92f80d53803ce756b4b8
" 以下のように試せる
" call TestErrFmt('[ERROR] %f:[%l\,%c]%m,%-G%.%#', ['[ERROR] LocalDateTimeConverter.java:[13,16] シンボルを見つけられません'])
" %-G%.%# を入れておくと、マッチしなかったら、表示されないから、便利
function! TestErrFmt(errfmt, lines) abort
  let temp_errorformat = &errorformat
  try
    let &errorformat = a:errfmt
    cexpr join(a:lines, "\n")
    copen
  catch
    echo v:exception
    echo v:throwpoint
  endtry
endfunction

function! s:my_ft_java() abort
  let l:efm = ''
  " Spring Boot 用

  let l:efm .= '[ERROR] %f:[%l\,%c]%m'

  " 11:02:50.375 [main] DEBUG hogehoge
  " %*\d は \d+ と同じ意味
  " %.%# は .* と同じ意味
  let l:efm .= ',%-G%*\d:%*\d:%*\d.%*\d [main] %.%#'

  " 2021-05-24 11:02:51.024 ...
  let l:efm .= ',%-G\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d.\d\d\d %.%#'

  " [INFO] Finished at: 2021-05-24T11|6| 11+09:00
  let l:efm .= ',%-G[INFO] Finished at: %.%#'

  if !empty(&errorformat)
    let l:efm .= ',' .. &errorformat
  endif
  let &errorformat = l:efm

  nnoremap <Space>rm :<C-u>Make build
endfunction


" TODO:自動で :e! したい。 treesitter をリフレッシュしたいため


function! s:my_ft_javascript() abort
  nnoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>
  inoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>
endfunction

function! s:my_ft_php() abort
  nnoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>
  inoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>

  setlocal formatoptions+=o
endfunction

function! s:my_ft_typescriptreact() abort
  nnoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>
  inoremap <buffer> <C-y>j <Cmd>lua require'ts/jsx_split_join_tag'.split_join_tag()<CR>
endfunction


command! ExercismPhpRun call ExercismPhpRun()
function! ExercismPhpRun() abort
  let l:curwin = win_getid()
  let l:result_bufnr = v:null

  for l:win in nvim_tabpage_list_wins(0)
    let l:bufnr = nvim_win_get_buf(l:win)

    " 100:cargo run みたいなバッファを探す
    if getbufvar(l:bufnr, 'my_quickrun_phpunit')
      " もし、あれば移動する
      let l:result_bufnr = l:bufnr
      break
    endif
  endfor

  let l:exercism_php_dir = expand('~/exercism/php')
  let l:cmd = l:exercism_php_dir .. '/vendor/bin/phpunit'
  " TODO: Test.php ファイルだった場合は、そのカーソルのテストのみを実行する
  let l:file = expand('%:p:r') .. 'Test.php'
  let l:cwd = getcwd()

  if l:result_bufnr == v:null
    execute 'vsplit'
  else
    execute printf('noautocmd %d wincmd w', bufwinnr(l:bufnr))
  endif

  try
    execute 'lcd ' .. l:exercism_php_dir
    execute printf('terminal %s %s', l:cmd, l:file)
    let b:my_quickrun_phpunit = 1
  catch /.*/
    execute 'lcd ' .. l:cwd
  endtry
  setlocal nobuflisted
  call win_gotoid(l:curwin)
endfunction
augroup my-quickrun-exercism-php
  autocmd!
  autocmd BufEnter ~/exercism/php/*/*.php nnoremap <buffer> <Space>rr <Cmd>ExercismPhpRun<CR>
augroup END
  


function! s:m_line_prev() abort
  let ctx = b:fin_context
  let size = max([len(ctx.indices), 1])
  if ctx.cursor is# 1
    let ctx.cursor = g:fin#wrap_around ? size : 1
  else
    let ctx.cursor -= 1
  endif
  call cursor(ctx.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:m_line_next() abort
  let ctx = b:fin_context
  let size = max([len(ctx.indices), 1])
  if ctx.cursor is# size
    let ctx.cursor = g:fin#wrap_around ? 1 : size
  else
    let ctx.cursor += 1
  endif
  call cursor(ctx.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:my_ft_fin() abort
  cnoremap <silent><buffer><expr> <C-k> <SID>m_line_prev()
  cnoremap <silent><buffer><expr> <C-j> <SID>m_line_next()
  cnoremap <silent><buffer><expr> <Up> <SID>m_line_prev()
  cnoremap <silent><buffer><expr> <Down> <SID>m_line_next()
  " cnoremap <silent><buffer> <Plug>(fin-matcher-prev)
  " cnoremap <silent><buffer> <Plug>(fin-matcher-next)

  " set number
endfunction


" function! s:my_ft_blade__php() abort
"   nmap <buffer> <C-y>j <plug>(emmet-split-join-tag)
"   imap <buffer> <C-y>j <plug>(emmet-split-join-tag)
" endfunction

function! s:my_ft_LspsagaCodeAction() abort
  nnoremap <buffer> <Esc> q
  inoremap <buffer> <C-o> <C-r>+
endfunction

function! s:my_ft_LspsagaRename() abort
  nnoremap <buffer> <Esc> q
  inoremap <buffer> <C-o> <C-r>+
  inoremap <buffer> <C-w> <C-S-W>
endfunction

command! DenoRun call DenoRun()
function! DenoRun() abort
  let l:curwin = win_getid()
  let l:result_bufnr = v:null

  for l:win in nvim_tabpage_list_wins(0)
    let l:bufnr = nvim_win_get_buf(l:win)

    if getbufvar(l:bufnr, 'my_quickrun_denorun')
      let l:result_bufnr = l:bufnr
      break
    endif
  endfor

  let l:cmd = 'deno run -A --no-check --unstable --watch'
  let l:file = expand('%:p')
  let l:cwd = getcwd()

  if l:result_bufnr == v:null
    execute 'vnew'
  else
    execute printf('noautocmd %d wincmd w', bufwinnr(l:bufnr))
  endif

  try
    execute 'lcd ' .. expand('%:p:h')
    execute printf('terminal %s %s', l:cmd, l:file)
    let b:my_quickrun_denorun = 1
  catch /.*/
    execute 'lcd ' .. l:cwd
  endtry
  setlocal nobuflisted
  call win_gotoid(l:curwin)
endfunction

function! s:my_ft_typescript() abort
  nnoremap <buffer> <Space>rr <Cmd>call DenoRun()<CR>
endfunction


" Copilot CLI とかで変更されたら通知する
function! CheckExternalFileChange() abort
  if !&modified
    checktime
  endif
endfunction

autocmd MyAutoCmd CursorHold,FocusGained * call CheckExternalFileChange()
autocmd MyAutoCmd FileChangedShellPost * lua vim.notify(
      \ "Buffer reloaded (external change)",
      \ vim.log.levels.INFO,
      \ { title = "External Edit" }
      \ )
      

" カレントウィンドウだけ、カーソルをつける
autocmd MyAutoCmd WinEnter,BufEnter * setlocal cursorline
autocmd MyAutoCmd WinLeave * setlocal nocursorline

" pytest 実行
augroup QuickRunPytest
  autocmd!
  " test_*.py という名前のファイルを開いた時だけ、そのバッファにマッピングを作成
  autocmd BufRead,BufNewFile test_*.py nnoremap <buffer> <Space>rr :QuickRun python/pytest<CR>
augroup END

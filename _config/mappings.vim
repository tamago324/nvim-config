scriptencoding utf-8

nnoremap <C-z> <Nop>

" insert mode で細かく undo できるようにする
inoremap <Left> <C-g>u<Left>
inoremap <Right> <C-g>u<Right>
inoremap <Home> <C-g>u<Home>
inoremap <End> <C-g>u<End>

" like emacs
inoremap <C-a> <C-o>_
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>

" 選択範囲で . を実行
xnoremap . :normal! .<CR>

" シンボリックリンクの先に移動する
nnoremap cd <Cmd>exec 'lcd ' .. resolve(expand('%:p:h')) \| pwd<CR>

nnoremap <Space>vs. <Cmd>source %<CR>

" update は変更があったときのみ保存するコマンド
nnoremap <Space>w <Cmd>update<CR>
nnoremap <C-s> <Cmd>update<CR>
nnoremap <Space>W <Cmd>update!<CR>

" function! s:quit(...) abort
"   let l:bang = get(a:, 1, v:false) ? '!' : ''
"   try
"     execute 'quit' .. l:bang
"   catch /\v(E5601|E37)/
"     " Neovimでタブの最後のウィンドウで、float window があると、エラーになるため
"     execute 'tabclose' .. l:bang
"   endtry
" endfunction
" nnoremap <Space>q <Cmd>call <SID>quit()<CR>
" nnoremap <Space>Q <Cmd>call <SID>quit(v:true)<CR>
nnoremap <Space>e <Cmd>quit<CR>
nnoremap <Space>E <Cmd>quit!<CR>

" window 操作
nnoremap s <Nop>

nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L

nnoremap sn <Cmd>new<CR>
nnoremap sp <Cmd>split<CR>
nnoremap sv <Cmd>vsplit<CR>

" カレントウィンドウを新規タブで開く
nnoremap st <C-w>T

" 新規タブ
nnoremap so <Cmd>tabedit<CR>
" 前のタブに戻る
nnoremap si <Cmd>tabnext #<CR>

" ターミナル
nnoremap sx <Cmd>new <Bar> terminal<CR>

" タブ間の移動
nnoremap gt <Nop>
nnoremap gT <Nop>
" nnoremap <C-l> gt
" nnoremap <C-h> gT
nnoremap <End> gt
nnoremap <Home> gT


" 先頭と末尾
nnoremap <Space>h ^
xnoremap <Space>h ^
nnoremap <Space>l $
xnoremap <Space>l $

" 上下の空白に移動
" https://twitter.com/Linda_pp/status/1108692192837533696
nnoremap <silent> <C-j> <Cmd>keepjumps normal! '}<CR>
nnoremap <silent> <C-k> <Cmd>keepjumps normal! '{<CR>
xnoremap <silent> <C-j> '}
xnoremap <silent> <C-k> '{

" 見た目通りに移動
nnoremap j gj
nnoremap k gk

" 中央にする
nnoremap G Gzz

" カーソル位置から行末までコピー
nnoremap Y y$

" 最後にコピーしたテキストを貼り付ける
nnoremap <Space>p "0p
xnoremap <Space>p "0p

" 直前に実行したマクロを実行する
nnoremap Q @@

" ハイライトの消去
nnoremap <Esc><Esc> <Cmd>noh<CR>

" <C-]> で Job mode に移行
tnoremap <Esc> <C-\><C-n>

" コマンドラインで emacs っぽく
cnoremap <C-a> <Home>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" " / -> \/ にする
" cnoremap <expr> / getcmdtype() ==# '/' ? '\/' : '/'

" " :h magic
" " markonm/traces.vim のバグ？で、 set incsearch が消えるため
" nnoremap / :<C-u>set incsearch<CR>/\v

" クリップボード内の文字列をそのまま検索
nnoremap <Space>/ /\V<C-r>+<CR>

" 全行で置換
nnoremap <Space>s<Space> :<C-u>%s///g<Left><Left>
nnoremap s<Space>s :<C-u>%s///g<Left><Left>

" カレントバッファを検索
nnoremap <Space>gg :vimgrep // %:p<Left><Left><Left><Left><Left>

" help
xnoremap <A-m> "hy:help <C-r>h<CR>
nnoremap <A-m> :h 
xnoremap K     <Nop>

" クリップボードの貼り付け
inoremap <C-r><C-r> <C-r>+
cnoremap <C-o>      <C-r>+

" tyru さんのマッピング
" https://github.com/tyru/config/blob/master/home/volt/rc/vimrc-only/vimrc.vim#L618
inoremap <C-l><C-l> <C-x><C-l>
inoremap <C-l><C-n> <C-x><C-n>
inoremap <C-l><C-k> <C-x><C-k>
inoremap <C-l><C-t> <C-x><C-t>
inoremap <C-l><C-i> <C-x><C-i>
inoremap <C-l><C-]> <C-x><C-]>
inoremap <C-l><C-f> <C-x><C-f>
inoremap <C-l><C-d> <C-x><C-d>
inoremap <C-l><C-v> <C-x><C-v>
inoremap <C-l><C-u> <C-x><C-u>
inoremap <C-l><C-o> <C-x><C-o>
inoremap <C-l><C-s> <C-x><C-s>
inoremap <C-l><C-p> <C-x><C-p>

" plugins.vim を開く
nnoremap <Space>v, <Cmd>call vimrc#drop_or_tabedit(g:plug_script)<CR>
nnoremap <Space>v. <Cmd>execute 'split ' .. g:plug_script<CR>

" new tempfile
nnoremap sf <Cmd>call <SID>new_tmp_file()<CR>
function! s:new_tmp_file() abort
  let l:ft = input('FileType: ', '', 'filetype')
  if l:ft ==# ''
    echo 'Cancel.'
    return
  endif

  " もし空ならそのバッファを使う
  let l:cmd = line('$') ==# 1 && getline(1) && !&modified ? 'e' : 'new'
  exec l:cmd .. ' '.. tempname()
  exec 'setfiletype ' .. l:ft
endfunction

" 再描画
nnoremap <Space>a <Cmd>call <SID>reopen()<CR>
function! s:reopen() abort
  let l:winview = winsaveview()
  e!
  call winrestview(l:winview)
endfunction

" quickfix をトグル
nnoremap <A-q> <Cmd>ToggleQuickfix<CR>
function! s:toggle_quickfix() abort
  let l:is_show_qf = v:false
  for l:win in nvim_tabpage_list_wins(0)
    let l:buf = nvim_win_get_buf(l:win)
    if nvim_buf_get_option(l:buf, 'buftype') ==# 'quickfix'
      let l:is_show_qf = v:true
      break
    endif
  endfor

  if l:is_show_qf
    if &buftype ==# 'quickfix'
      exec 'wincmd p'
    endif
    exec 'cclose'
  else
    exec 'botright copen'
  endif
endfunction
command! ToggleQuickfix call <SID>toggle_quickfix()

nnoremap <C-up> <Cmd>cprev<CR><Plug>Pulse
nnoremap <C-down> <Cmd>cnext<CR><Plug>Pulse
" " 先頭
" nnoremap [[ <Cmd>cfirst<CR>

" toggle option
function! s:toggle_option(key, opt) abort
  exec printf('nnoremap %s <Cmd>setlocal %s!<CR> \| <Cmd>set %s?<CR>', a:key, a:opt, a:opt)
endfunction
call s:toggle_option('<F2>', 'wrap')
call s:toggle_option('<F3>', 'readonly')

function! s:ripgrep(text) abort
  " let l:regex = input("Grep string> ")
  " " let l:input = input(printf("Grep string> "))
  " if empty(l:regex)
  "   call nvim_echo([['Calcel.', 'WarningMsg']], v:false, [])
  "   return
  " endif

  " もし、 lir なら、そのディレクトリを cwd の初期値にする
  let cwd = getcwd()
  if &filetype ==# 'lir'
    let cwd = luaeval('require("lir").get_context().dir')
  endif

  let l:cwd = input("cwd> ", cwd, 'dir')
  if !isdirectory(l:cwd)
    call nvim_echo([[printf('Not exists "%s"', l:cwd), 'WarningMsg']], v:false, [])
    return
  endif

  let l:save_cwd = getcwd()
  try
    noautocmd execute 'lcd ' .. l:cwd
    " ! をつけると、最初のマッチにジャンプしなくなる
    if has('win64')
      execute printf("silent grep! %s", a:text)
    else
      execute printf("silent grep! '%s'", a:text)
    endif
  catch /.*/
    noautocmd execute 'lcd ' .. l:save_cwd
  endtry
endfunction

command! -nargs=1 Rg call <SID>ripgrep(<q-args>)
nnoremap <Space>fg :<C-u>Rg 
"nnoremap ,g :<C-u>Rg 
xnoremap <Space>fg "hy:Rg <C-r>h<CR>


" nnoremap <Space>d. <Cmd>call vimrc#drop_or_tabedit('~/dict')<CR>

" カレントバッファのパスを入力
cnoremap <C-x> <C-r>%

nnoremap x "_x

" 便利
onoremap ( t(
onoremap ) t)
onoremap [ t[
onoremap ] t]
onoremap { t{
onoremap } t}
onoremap " t"
onoremap ' t'
onoremap ` t`

nnoremap <Space>dt <Cmd>windo diffthis<CR>
nnoremap <Space>do <Cmd>windo diffoff<CR>

nnoremap sq <Cmd>tabo<CR>
nnoremap sc <Cmd>tabclose<CR>
" nnoremap sl <Cmd>only<CR>

" let s:float_tmp = {}
" let s:float_tmp.buf = v:null
" let s:float_tmp.win = v:null
" 
" " function! s:glow_width() abort
" "   " 横幅を広げる
" "   let l:len = len(line('.'))
" "   echo l:len
" "   let l:width = nvim_win_get_config(s:float_tmp.win).width
" "   if l:len > l:width
" "     call nvim_win_set_config(s:float_tmp.win, {
" "     \ 'width': l:len - l:width
" "     \})
" "   endif
" " endfunction
" 
" function! s:hide_tiknot() abort
"   call nvim_win_hide(s:float_tmp.win)
" endfunction
" 
" function! s:open_tiknot() abort
"   " カーソルの近くに使い捨てのフローティングウィンドウを表示する
"   if s:float_tmp.buf ==# v:null
"     let s:float_tmp.buf = nvim_create_buf(v:false, v:true)
"   endif
" 
"   " cursor って使えないの？
"   let s:float_tmp.win = nvim_open_win(s:float_tmp.buf, v:true, {
"  \ 'relative': 'cursor',
"  \ 'width': 40,
"  \ 'height': 15,
"  \ 'col': 10,
"  \ 'row': 3,
"  \ 'focusable': v:true,
"  \ 'style': 'minimal',
"  \ 'border': 'shadow',
"  \})
" 
"   setlocal winhl=Normal:TikNotNormal,EndOfBuffer:TikNotNormal
" 
"   setlocal cursorline
"   setlocal number
" 
"   nnoremap <buffer> q  <Cmd>call <SID>hide_tiknot()<CR>
"   nnoremap <buffer> si <Cmd>call <SID>hide_tiknot()<CR>
" 
"   augroup TikNot
"     autocmd!
"     autocmd WinLeave <buffer> call <SID>hide_tiknot()
"   augroup END
" endfunction
" nnoremap si <Cmd>call <SID>open_tiknot()<CR>

" " 現在の位置に対応する ) にジャンプ
" noremap <Space>a) ])
" noremap <Space>a] ]]
" noremap <Space>a} ]}

" noremap m) ])
" noremap m} ]}
"
" vnoremap m] i]o``
" vnoremap m( i)``
" vnoremap m{ i}``
" vnoremap m[ i]``
"
" nnoremap dm] vi]o``d
" nnoremap dm( vi)``d
" nnoremap dm{ vi}``d
" nnoremap dm[ vi]``d
"
" nnoremap cm] vi]o``c
" nnoremap cm( vi)``c
" nnoremap cm{ vi}``c
" nnoremap cm[ vi]``c


" " 選択場所を新しいタブで開く
" nnoremap <silent> <Space>at  <Cmd>tabnew<Cr>]p:call deletebufline('%', 1, 1)<Cr>
" vnoremap <silent> <Space>at y<Cmd>tabnew<Cr>]p:call deletebufline('%', 1, 1)<Cr>


" Hoge| を <Hoge |/> に置き換える関数
function! s:expand_component_tag() abort
  " カーソル前の文字を取得
  let l:line = getline('.')
  let l:col = col('.')
  let l:tagname = matchstr(l:line[: l:col-2], '\v[^ ()]+$')

  " 置き換える
  let l:new_line = l:line[: (l:col-2) - len(l:tagname)]
  let l:new_line ..= '<' .. l:tagname .. ' />'
  let l:new_line ..= l:line[l:col-1:]

  call setline(line('.'), l:new_line)
  call cursor([line('.'), l:col+2])
endfunction
inoremap <C-y>t <Cmd>call <SID>expand_component_tag()<CR>

function! s:better_jump_last_change() abort
  let l:first = line("w0")
  let l:last = line("w$")
  let l:last_change_line = line("'.")

  if l:first < l:last_change_line && l:last_change_line < l:last
    " 画面内なら、そのままジャンプ
    return 'g;'
  endif

  " 画面外なら、中央に表示
  return 'g;zz'
endfunction
nnoremap <expr> ; <SID>better_jump_last_change()

nnoremap <Space><Space> :
xnoremap <Space><Space> :
" nnoremap <Space><Space> <Cmd>FineCmdline<CR>

nnoremap - <C-^>

" cu で _ まで c する
onoremap u t_
" cU で キャメルケースの切り替わりまで削除する
onoremap U :<C-u>call <SID>numSearchLine('[A-Z]', v:count1, '')<CR>
function! s:numSearchLine(ptn, num, opt)
  for i in range(a:num)
    call search(a:ptn, a:opt, line('.'))
  endfor
endfunction

" " rbttn さんの実装
" function! s:percent_expr() abort
"   let curr_char = getline('.')[col('.') - 1]
"   if curr_char == '"'
"     if col('.') == col('''>')
"       return "v2i\"o\<esc>"
"     else
"       return "v2i\"\<esc>"
"     endif
"   elseif curr_char == "'"
"     if col('.') == col('''>')
"       return "v2i'o\<esc>"
"     else
"       return "v2i'\<esc>"
"     endif
"   else
"     return '%'
"   endif
" endfunction
" nnoremap   <expr>%        <SID>percent_expr()

function! s:put_semicoron() abort
  " 末尾に ; をセットするだけのマッピング
  call setline(line('.'), getline('.') .. ';')
endfunction
nnoremap <Space>; <Cmd>call <SID>put_semicoron()<CR>


" " jumps を searchx の関数を使ってスムーズにする
" " from unite
" function! s:capture(command) abort
"   try
"     redir => out
"     silent execute a:command
"   finally
"     redir END
"   endtry
"   return out
" endfunction

" function! s:jumps(direction) abort
"   let [l:jumplist, l:current] = getjumplist()
"   let l:next = l:current
"   if a:direction ==# 'prev'
"     " <C-o>
"     let l:next -= 1
"     if l:next < 0 
"       return
"     endif
"   else
"     let l:next += 1
"     if l:next >= len(l:jumplist)
"       return
"     endif
"   endif
" 
"   let l:item = l:jumplist[l:next]
"   if l:item.bufnr ==# bufnr()
"     call searchx#cursor#goto([l:item.lnum, l:item.col])
"     " 押したことにするため、押させる
"     " return
"   endif
" 
"   if a:direction ==# 'prev'
"     call feedkeys("\<C-o>", 'n')
"   else
"     call feedkeys("\<C-i>", 'n')
"   endif
" endfunction
" 
" nnoremap <C-i> <Cmd>call <SID>jumps('next')<CR>
" nnoremap <C-o> <Cmd>call <SID>jumps('prev')<CR>



cnoremap <C-j> <C-g>
cnoremap <C-k> <C-t>

nnoremap <Plug>MyplusejumpTab <C-i>
function! s:jump(cmd) abort
  let l:bufname = bufname('%')
  if a:cmd ==# 'next'
    exec "normal \<Plug>MyplusejumpTab"
    " exe "normal \<Ta>" 
  else
    exec "normal! \<C-o>"
  endif

  let l:new_bufname = bufname('%')
  if l:bufname !=# l:new_bufname
    call search_pulse#Pulse(v:true)
  endif
endfunction

nnoremap <silent> <C-o> <Cmd>call <SID>jump('prev')<CR>
nnoremap <silent> <Tab> <Cmd>call <SID>jump("next")<CR>

nnoremap <A-c> <Cmd>call <SID>copy_relative_path()<CR>
xnoremap <A-c> <Cmd>call <SID>copy_relative_path_with_lines()<CR>
nnoremap <A-x> <Cmd>call <SID>send_relative_path_with_lines()<CR>
xnoremap <A-x> <Cmd>call <SID>send_relative_path_with_lines()<CR>

" git_root からの相対パスをコピー
function! s:copy_relative_path() abort
  let l:git_root = systemlist('git rev-parse --show-toplevel')[0]
  let l:file_path = expand('%:p')
  let l:relative_path = fnamemodify(l:file_path, ':~:.' .. l:git_root)
  call setreg('+', l:relative_path)
  echo 'Copied: ' .. l:relative_path
endfunction

" ビジュアルモード用：git_root からの相対パス + 行番号をコピー
function! s:get_relative_path_with_lines() abort
  let l:git_root = systemlist('git rev-parse --show-toplevel')[0]
  let l:file_path = expand('%:p')
  let l:relative_path = fnamemodify(l:file_path, ':~:.' .. l:git_root)
  let l:start_row = getpos('v')[1]
  let l:end_row = getpos('.')[1]
  if l:start_row > l:end_row
    let [l:start_row, l:end_row] = [l:end_row, l:start_row]
  endif
  return l:relative_path .. ':L' .. l:start_row .. '-L' .. l:end_row
endfunction

function! s:copy_relative_path_with_lines() abort
  let l:result = s:get_relative_path_with_lines()
  call setreg('+', l:result)
  echo 'Copied: ' .. l:result
  call feedkeys("\<Esc>", 'n')
endfunction

function! s:send_relative_path_with_lines() abort
  call luaeval('require("xcopilot").send_text(_A)', s:get_relative_path_with_lines() .. ' ')
  call feedkeys("\<Esc>", 'n')
endfunction

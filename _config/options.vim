scriptencoding utf-8

set encoding=utf-8

" 改行コードの設定
set fileformats=unix,dos,mac

" https://github.com/vim-jp/issues/issues/1186
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932

" 折返しのインデント
let g:vim_indent_cont = 0

" from https://twitter.com/hrsh7th/status/1206597079134437378
let $MYVIMRC = resolve($MYVIMRC)


set autoindent          " 改行時に前の行のインデントを維持する
" set smartindent         " 改行時に入力された行の末尾に合わせて次の行のインデントを増減
set shiftround          " インデント幅を必ず shiftwidth の倍数にする
set hlsearch            " 検索文字列をハイライトする
set incsearch           " 文字を入力されるたびに検索を実行する
set scrolloff=5         " 5行開けてスクロールできるようにする
set visualbell t_vb=    " ビープ音すべてを無効にする
set noerrorbells        " エラーメッセージの表示時にビープ音を鳴らさない
set history=3000         " 検索、置換、コマンド... の履歴を300にする(default: 50)
" set showtabline=2       " 常にタブを表示
set showtabline=2       " タブを表示しない
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 大文字が入らない限り、大文字小文字は区別しない
set cmdheight=2         " 2 で慣れてしまったため
" if !has('nvim')
" set ambiwidth=double    " 記号を正しく表示
set ambiwidth=single    " 記号を正しく表示
" endif
set timeoutlen=480      " マッピングの待機時間
set nrformats-=octal    " 07 で CTRL-A しても、010 にならないようにする
if has('nvim')
  " set signcolumn=yes:2    " 常に表示 (幅を2にする)
  set signcolumn=yes    " 常に表示 (幅を2にする)
else
  set signcolumn=yes      " 常に表示
endif
if !has('nvim')
  set completeslash=slash " 補完時に使用する slash
endif
set nostartofline       " <C-v>で選択しているときに、上下移動しても、行頭に行かないようにする
set autoread            " Vim の外でファイルを変更した時、自動で読み込む
set splitright          " 縦分割した時、カレントウィンドウの右に作成する
set nosplitbelow        " 横分割した時、カレントウィンドウの上に作成する
set noshowcmd
set nowrap

" menuone:  候補が1つでも表示
" popup:    info を popup で表示
" noselect: 自動で候補を表示しない
" noinsert: 自動で候補を挿入しない
" set completeopt=menuone,noselect,noinsert
set completeopt=menuone,noselect
" 補完候補の最大表示数
set pumheight=15

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" syntax highlight
" syntax enable と syntax on の違いを理解する (:help :syntax-on)
" on: 既存の色の設定を上書きする
" enable: まだ、設定されていない色の設定のみ適用する
syntax enable

" plugin ファイルタイプ別プラグインを有効化
" indent ファイルタイプごとのインデントを有効化
" ファイルタイプの自動検出
filetype plugin indent on

" <BS>, <Del>, <CTRL-W>, <CTRL-U> で削除できるものを設定
"   indent  : 行頭の空白
"   eol     : 改行(行の連結が可能)
"   start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

" Windows の場合、 @* と @+ は同じになる
if has('win32')
  set clipboard=unnamed
else
  " https://pocke.hatenablog.com/entry/2014/10/26/145646
  " reset
  set clipboard&
  set clipboard^=unnamedplus
endif

" WSL でのクリップボードの設定
if $WSL_DISTRO_NAME !=# ""
  let g:clipboard = {
          \   'name': 'myClipboard',
          \   'copy': {
          \      '+': 'win32yank.exe -i',
          \      '*': 'win32yank.exe -i',
          \    },
          \   'paste': {
          \      '+': 'win32yank.exe -o',
          \      '*': {-> systemlist('win32yank.exe -o | tr -d "\r"')},
          \   },
          \   'cache_enabled': 1,
          \ }
end

" 余白文字を指定
"   vert: 垂直分割の区切り文字
"   fold: 折畳の余白
"   diff: diffの余白
" set fillchars=vert:\ ,fold:\ ,diff:\ 
set fillchars=vert:\|,fold:\ ,diff:\ 

" バックアップファイル(~)を作成しない(defaut: off)
set nobackup
set nowritebackup

" スワップファイル(.swp)を作成しない
set noswapfile
set updatecount=0

" cmdline の補完設定
" ステータスラインに候補を表示
set wildmenu

" Tab 1回目:  共通部分まで補完し、候補リストを表示
" Tab 2回目~: 候補を完全に補完
set wildmode=longest:full,list:full

" cmdline から cmdline-window へ移動
set cedit=\<C-y>

" listchars (不可視文字を表示する) "
set list
set listchars=
" 改行記号
"set listchars+=eol:↲
" タブ
set listchars+=tab:»\ 
" 右が省略されている
set listchars+=extends:>
" 行をまたいでいる
set listchars+=precedes:<
" 行末のスペース
set listchars+=trail:\ 

" 補完のメッセージを表示しない
set shortmess+=c

" diff の設定
" https://qiita.com/takaakikasai/items/3d4f8a4867364a46dfa3
" internal: 内部diffライブラリを設定する
" filler: 片方にしか無い行を埋める
" algorithm:histogram: histogram差分アルゴリズム を使用する
" indent-heuristic: 内部 diff のインデントヒューリスティック？を使う
if !has('nvim')
  "set diffopt=internal,filler,algorithm:histogram,indent-heuristic
  set diffopt=internal,filler,closeoff,linematch:60
endif
" 垂直に分割する
set diffopt+=vertical

" " fold 折畳
" function! MyFoldText() abort "
"     let marker_start = strpart(&foldmarker, 0, 3)
"     let line = getline(v:foldstart)
"     let lcnt = v:foldend - v:foldstart
"
"     " TODO: 4桁固定ではなく、レベルごとに設定とかできないのかな...
"     let lcnt =  printf('%4d', lcnt)
"
"     let l:foldtext = ''
"     let l:foldtext.= lcnt.'L'
"     let l:foldtext.= ' '
"     let l:foldtext.= line
"     return l:foldtext
" endfunction
"
" set foldtext=MyFoldText()

" from kaoriya's vimrc
" マルチバイト文字の間でも改行できるようにする(autoindentが有効の場合いる)
set formatoptions+=m
" マルチバイト文字の間で行連結した時、空白を入れない
set formatoptions+=M

" from #vimtips_ac https://twitter.com/Takutakku/status/1207676964225597441
" 結合時、コメントを削除する
set formatoptions+=j

set formatoptions-=t

" terminal
" prefix
if !has('nvim')
  set termwinkey=<C-w>
endif

set noshowmode
set laststatus=2

" パスとして = を含めない (set rtp=~/path/to/file で補完できるようにする)
set isfname-==
" パスとして ' を含めない (set rtp='~/path/to/file' で補完できるようにする)
set isfname-='
" @,48-57,/,.,-,_,+,,,#,$,%,~
" @,48-57,/,.,-,_,+,,,#,$,%,~,'

" 矩形選択の時、文字がない箇所も選択できるようにする
set virtualedit=block

" gf とかで相対パスを検索するときの基準となるディレクトリのリスト
set path=
" カレントファイルからの相対パス
set path+=.
" カレントディレクトリからの相対パス
set path+=,,
" カレントディレクトリから上に探しに行く
set path+=**

set foldlevelstart=99

" 表示できるところまで表示する
set display=lastline

" マクロの実行が終わったら、描画する (高速化)
set lazyredraw

" " よく間違える文字をハイライト
" let s:misspell = [
" \   'pritn',
" \   'funciton',
" \   'fmg',
" \   'Prinln',
" \   'improt',
" \]
" exe printf('match Error /%s/', join(s:misspell, '\|'))


" .,w,b,u,t,i
" include
set complete-=i
" tag
set complete-=t
" unload buffer
set complete-=u

" カーソルの形を変更する
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" https://github.com/tyru/config/commit/993b57acd84a4996990771ae293625133f1b2ed8#diff-054bd431f12b7b2850de6d50d6e0ce17R864
" https://qiita.com/Linda_pp/items/9e0c94eb82b18071db34
" if has('vim_starting')
"     " 挿入モード時に非点滅の縦棒タイプのカーソル
"     let &t_SI .= "\e[6 q"
"     " ノーマルモード時に非点滅のブロックタイプのカーソル
"     let &t_EI .= "\e[2 q"
"     " 置換モード時に非点滅の下線タイプのカーソル
"     let &t_SR .= "\e[4 q"
" endif

" 
" set breakindent
" let &showbreak=repeat(' ', 3)
" set linebreak

if !has('gui_running')
  set termguicolors
endif

set mouse+=n

if has('nvim')
  set inccommand=split
endif

" lua ハイライトを ON
" let g:vimsyn_embed = 'l'

" :h file-searching
set tags=./tags;/

" CursorHold の時間
set updatetime=500

" 
" set showtabline=0

" set cursorline


if executable("rg")
  " set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ "!*/.mypy_cache/*"\ "!.node_modules/*"\ "!tags*"
  " set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ '!tags*'

  " --no-heading はデフォルトでONだから、いらない
  " set grepprg=rg\ --vimgrep\ --smart-case\ --glob\ '!tags*'
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" " 自動でならないようにする
" set winfixheight

" ウィンドウを分割しても、ウィンドウサイズを変更しない
" set noequalalways

set helplang=ja,en

" set laststatus=3
" " https://www.reddit.com/r/neovim/comments/tgyddx/heres_a_snippet_for_thicker_vertical_and/
lua << EOF
  vim.opt.fillchars = {
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft  = '┫',
    vertright = '┣',
    verthoriz = '╋',
  }
EOF

" 折返した行をその行のインデントで表示する
set breakindent
set breakindentopt=min:50,shift:4,sbr
set showbreak=›\ 

" nvim-scrollbar で zj が入力されてしまうため、それの対処
set nofoldenable

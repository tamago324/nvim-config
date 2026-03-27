scriptencoding utf-8

let g:plug_install_dir = expand('$MYVIMFILES/.plugged')

if empty(glob(stdpath('config') .. '/autoload/plug.vim'))
  call system('curl -fLo ' .. stdpath('config') .. '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

packadd cfilter

call plug#begin(g:plug_install_dir)

" 必須
Plug 'cohama/lexima.vim'
Plug 'svermeulen/vim-cutlass'
Plug 'machakann/vim-sandwich'
Plug 'kevinhwang91/nvim-bqf'
  Plug 'stevearc/quicker.nvim'
Plug 'thinca/vim-quickrun'
  Plug 'statiolake/vim-quickrun-runner-nvimterm'
  Plug 'lambdalisue/vim-quickrun-neovim-job'
Plug 'simeji/winresizer'

" terminal (weztermとの連携) 遅延が気になるため、OFFにしておく
"Plug 'mrjones2014/smart-splits.nvim'

" color
Plug 'catppuccin/nvim', { 'branch': 'vim', 'as': 'catppuccin' }

" statusline
Plug 'nvim-lualine/lualine.nvim'

" operator
Plug 'kana/vim-operator-replace'
Plug 'kana/vim-operator-user',

" object
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
" Plug 'osyo-manga/vim-textobj-multiblock'    " ( とか [ とか { とかのテキストオブジェクト
" Plug 'rhysd/vim-textobj-anyblock'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'sgur/vim-textobj-parameter'
" Plug 'machakann/vim-textobj-delimited'    " スネークケースとかキャメルケースとかのテキストオブジェクト
Plug 'machakann/vim-textobj-functioncall'
Plug 'kana/vim-textobj-line'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'sindrets/diffview.nvim'
Plug 'lewis6991/gitsigns.nvim'

" ブラウザ系
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'

" ファイラー
Plug 'tamago324/lir.nvim'
Plug 'tamago324/lir-git-status.nvim'

" クリップボード
Plug 'rcmdnk/yankround.vim'
"Plug 'gbprod/yanky.nvim'

" コメント
Plug 'tyru/caw.vim'
"Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'Shougo/context_filetype.vim'

" 検索 / ジャンプ系
Plug 'haya14busa/vim-asterisk'
Plug 'hrsh7th/vim-searchx'
Plug 'hrsh7th/vim-eft'
Plug 'andymass/vim-matchup'
Plug 'tamago324/vim-search-pulse'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'monaqa/modesearch.vim'
Plug 'rlane/pounce.nvim'

" tree-sitter
Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'nvim-treesitter/nvim-treesitter-textobjects'
"Plug 'nvim-treesitter/playground'
Plug 'windwp/nvim-ts-autotag'
"Plug 'yioneko/nvim-yati'

" indent
Plug 'shellRaining/hlchunk.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'matsui54/denops-signature_help'
Plug 'RRethy/vim-illuminate'
Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim'
Plug 'tamago324/nlsp-settings.nvim'
Plug 'j-hui/fidget.nvim' " LSPのローディングをカッコよくする
Plug 'rachartier/tiny-inline-diagnostic.nvim' " ErrorLens
Plug 'lewis6991/hover.nvim' " hover
Plug 'smjonas/inc-rename.nvim' " rename
Plug 'aznhe21/actions-preview.nvim' " code actions + telescope
Plug 'pmizio/typescript-tools.nvim'

" fizzy finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ghq.nvim'
Plug 'danielfalk/smart-open.nvim'
Plug 'kkharji/sqlite.lua'
"Plug 'natecraddock/telescope-zf-native.nvim'

" formatter
Plug 'stevearc/conform.nvim'

" 補完
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
"Plug 'tamago324/cmp-necosyntax'
"Plug 'Shougo/neco-syntax'
"Plug 'hrsh7th/cmp-nvim-lua'

 Plug 'L3MON4D3/LuaSnip'
 Plug 'saadparwaiz1/cmp_luasnip'

" util
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'notomo/promise.nvim'
Plug 'vim-denops/denops.vim'

" markdown
Plug 'OXY2DEV/markview.nvim'
Plug 'preservim/vim-markdown'
Plug 'bullets-vim/bullets.vim'

" 裏で動いてくれるやつ
Plug 'kana/vim-niceblock'
Plug 'vim-jp/vimdoc-ja'
Plug 'junegunn/vim-plug'
" Plug 'kdav5758/NoCLC.nvim'
Plug 'lambdalisue/edita.vim'
" sudo apt install universal-ctags global
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'dhananjaylatkar/cscope_maps.nvim'
Plug 'lambdalisue/vim-protocol'
Plug 'mattn/vim-findroot'
Plug 'nacro90/numb.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lambdalisue/mr.vim'
Plug 'petertriho/nvim-scrollbar'
Plug 'dstein64/nvim-scrollview' " スクロールバーのところにdiagnosticsを表示
 Plug 'aiya000/aho-bakaup.vim'
Plug 'lambdalisue/vim-backslash'
" Plug 'mvllow/modes.nvim'
" Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'rcarriga/nvim-notify'
"Plug 'pocco81/auto-save.nvim'
Plug 'uga-rosa/ccc.nvim'


" 便利
Plug 'thinca/vim-prettyprint', { 'on': ['PP', 'PrettyPrint'] }
Plug 'thinca/vim-qfreplace', { 'on': 'Qfreplace' }
Plug 'lambdalisue/suda.vim'
Plug 'tyru/capture.vim', { 'on': 'Capture' }
"Plug 'mattn/sonictemplate-vim'
Plug 'Bakudankun/BackAndForward.vim'
Plug 'thinca/vim-ref'
Plug 'hrsh7th/vim-gindent'

Plug 'EthanJWright/vs-tasks.nvim'
Plug 't9md/vim-quickhl'

Plug 'stevearc/overseer.nvim'

Plug 'razak17/tailwind-fold.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

Plug 'mfussenegger/nvim-lint'

Plug 'kndndrj/nvim-dbee'
Plug 'MattiasMTS/cmp-dbee'

call plug#end()

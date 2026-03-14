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
"Plug 'Shougo/deol.nvim'
Plug 'kevinhwang91/nvim-bqf'
Plug 'thinca/vim-quickrun'
  Plug 'statiolake/vim-quickrun-runner-nvimterm'
  Plug 'lambdalisue/vim-quickrun-neovim-job'
Plug 'simeji/winresizer'

Plug 'sainnhe/edge'

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
"Plug 'sindrets/diffview.nvim'

" 便利
Plug 'Bakudankun/BackAndForward.vim'
Plug 'thinca/vim-ref'
Plug 'hrsh7th/vim-gindent'

" fuzzy finder
Plug 'nvim-lua/telescope.nvim'

" ファイラー
Plug 'tamago324/lir.nvim'
Plug 'tamago324/lir-git-status.nvim'

" クリップボード
Plug 'rcmdnk/yankround.vim'

" util
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'notomo/promise.nvim'

call plug#end()

" nvim -u {{_expr_:expand('%:~:p')}} -i NONE

set encoding=utf-8
scriptencoding utf-8

filetype plugin indent on
if has('vim_starting')
  let s:pluin_manager_dir='~/.config/nvim/.plugged/vim-plug'
  execute 'set runtimepath+=' . s:pluin_manager_dir
endif
call plug#begin('~/.config/nvim/.plugged')
Plug 'sainnhe/gruvbox-material'
Plug '{{_cursor_}}'
call plug#end()

set nobackup
set nowritebackup
set noswapfile
set updatecount=0
set backspace=indent,eol,start
language messages en_US.utf8

nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>qall!<CR>


set termguicolors

let g:gruvbox_material_enable_italic = 0
let g:gruvbox_material_disable_italic_comment = 1
let g:gruvbox_material_background = 'medium'

set bg=dark
colorscheme gruvbox-material

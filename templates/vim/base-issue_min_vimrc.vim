set encoding=utf-8

filetype plugin indent on
if has('vim_starting')
  let s:pluin_manager_dir='~/.config/nvim/.plugged/vim-plug'
  execute 'set runtimepath+=' . s:pluin_manager_dir
endif
call plug#begin('~/.config/nvim/.plugged')
Plug '{{_cursor_}}'
call plug#end()

set nobackup
set nowritebackup
set noswapfile
set updatecount=0
set backspace=indent,eol,start
language messages en_US.utf8

" nvim -u {{_expr_:expand('%:p:~')}} -i NONE

set encoding=utf-8
scriptencoding utf-8

syntax enable
filetype plugin indent on

set nocompatible

call plug#begin('~/vimfiles/plugged')

call plug#end()

set nobackup
set nowritebackup
set noswapfile
set updatecount=0
set backspace=indent,eol,start

nnoremap <silent> <Space>q :<C-u>quit<CR>
nnoremap <silent> <Space>Q :<C-u>quit!<CR>

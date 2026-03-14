scriptencoding utf-8
UsePlugin 'BackAndForward.vim'

let g:backandforward_config = {}
let g:backandforward_config.auto_map = v:false
let g:backandforward_config.define_commands = v:false

nmap <Left> <Plug>(backandforward-back)
nmap <Right> <Plug>(backandforward-forward)

scriptencoding utf-8
UsePlugin 'vim-textobj-user'

" e entire
" , parameter
" v segmend
" c funccall
" b sandwitch bracket

" TextObj Entire
let g:textobj_entire_no_default_key_mappings=1
vmap ae <Plug>(textobj-entire-a)
omap ae <Plug>(textobj-entire-a)
vmap ie <Plug>(textobj-entire-i)
omap ie <Plug>(textobj-entire-i)

" parameter
let g:vim_textobj_parameter_mapping = ','

" " delimited
" let g:textobj_delimited_no_default_key_mappings = 1
" xmap id <Plug>(textobj-delimited-forward-i)
" xmap ad <Plug>(textobj-delimited-forward-a)
" omap id <Plug>(textobj-delimited-forward-i)
" omap ad <Plug>(textobj-delimited-forward-a)
" 
" xmap iD <Plug>(textobj-delimited-forward-i)
" xmap aD <Plug>(textobj-delimited-forward-a)
" omap iD <Plug>(textobj-delimited-forward-i)
" omap aD <Plug>(textobj-delimited-forward-a)

" " funccall
" let g:textobj_functioncall_no_default_key_mappings = 1
" xmap ic <Plug><Plug>(textobj-functioncall-i)
" xmap ac <Plug><Plug>(textobj-functioncall-a)
" omap ic <Plug><Plug>(textobj-functioncall-i)
" omap ac <Plug><Plug>(textobj-functioncall-a)

let g:textobj_line_no_default_key_mappings = 1
vmap al <Plug>(textobj-line-a)
omap al <Plug>(textobj-line-a)
vmap il <Plug>(textobj-line-i)
omap il <Plug>(textobj-line-i)

" omap ab <Plug>(textobj-multiblock-a)
" omap ib <Plug>(textobj-multiblock-i)
" xmap ab <Plug>(textobj-multiblock-a)
" xmap ib <Plug>(textobj-multiblock-i)
"
"
" let g:textobj_multiblock_blocks = [
" \	[ "(", ")" ],
" \	[ "[", "]" ],
" \	[ "{", "}" ],
" \	[ '<', '>' ],
" \	[ '"', '"', 1 ],
" \	[ "'", "'", 1 ],
" \	[ "`", "`", 1 ],
" \]

" j: variable-segment
let g:loaded_textobj_variable_segment = 1

call textobj#user#plugin('variable', {
    \ '-': {
    \     'sfile': expand('<sfile>:p'),
    \     'select-a': 'aj',  'select-a-function': 'textobj#variable_segment#select_a',
    \     'select-i': 'ij',  'select-i-function': 'textobj#variable_segment#select_i',
    \ }})

scriptencoding utf-8
UsePlugin 'sonictemplate-vim'

let g:sonictemplate_vim_template_dir = [
\   expand('$MYVIMFILES/template'),
\]

" nnoremap <Space>;t :<C-u>Template 


" imap <expr> <C-j> pumvisible() ? '<C-e><plug>(sonictemplate-postfix)' : '<plug>(sonictemplate-postfix)'

let g:sonictemplate_key = '<C-y>x'

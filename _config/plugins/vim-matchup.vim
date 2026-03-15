scriptencoding utf-8

UsePlugin 'vim-matchup'

" ハイライトを少し遅らせる (hjkl の移動がスムーズになる？)
let g:matchup_matchparen_deferred = 1

" マッチ対象を表示させない
" let g:matchup_matchparen_offscreen = {}

" 指定のモードではハイライトさせない
let g:matchup_matchparen_nomode = 'i'
" let g:matchup_matchparen_nomode = ''

" popup で表示する
let g:matchup_matchparen_offscreen = {'method': 'popup'}

" retrun にマッチしないようにする
let g:matchup_delim_noskips = 1

" HTMLのタグは タグ名のみハイライトする
let g:matchup_matchpref = get(g:, 'matchup_matchpref', {})
let g:matchup_matchpref.html = get(g:matchup_matchpref, 'html', {})
let g:matchup_matchpref.html.tagnameonly = 1

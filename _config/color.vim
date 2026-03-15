scriptencoding utf-8


function! s:define_my_highlight() abort
  " if !exists('g:colors_name') | return | endif

  " hi TelescopeBorder guifg=#7c6f64
  " hi link TelescopeBorder StatusLineNC
  hi link TelescopeBorder Conceal
  hi link TelescopePromptBorder TelescopeBorder
  hi link TelescopeResultsBorder TelescopeBorder
  hi link TelescopePreviewBorder TelescopeBorder
  hi link TelescopeSelection CursorLine
  hi link TelescopeSelectionCaret TelescopeSelection
  hi link TelescopeResultsMethod TelescopeResultsConstant

  hi link NLspReferenceText LspReferenceText
  hi link NLspReferenceRead LspReferenceRead
  hi link NLspReferenceWrite LspReferenceWrite

  hi link FineCmdlineBorder Pmenu 

  hi link BiscuitColor Comment

  " hi link SeakChar Substitute
  hi link SearchxMarkerCurrent Comment
  hi SearchxMarker guifg=#a0c980 gui=bold
  hi FuzzyMotionChar guifg=#6cb6eb gui=bold
  hi FuzzyMotionSubChar guifg=#a0c980 gui=bold

  hi link PreviewDocFloatNormal Normal
  hi ScrollView guibg=#535a79


  hi CurrentWord ctermbg=237 guibg=#363a4e gui=underline
  hi link LirFloatCurdirWindowDirName CtrlPMatch
  " hi link LirFloatBorder Normal
  hi link LirFloatBorder Conceal

  hi link SignatureHelpVirtual DiffAdd

  hi link CmpItemKindValue CmpItemKindText
  " hi link CmpItemKindProperty CmpItemKindText

  hi link SpecialKey Blue

  hi link ScrollbarMarkError RedSign
  hi link ScrollbarMarkWarn YellowSign
  hi link ScrollbarMarkInfo BlueSign
  hi link ScrollbarMarkHint GreenSign
  hi link ScrollbarMarkMisc PurpleSign

  hi link DduMeFloatNormal Normal

  hi Visual guibg=#cd98dd guifg=#21222c
  hi ModesVisual guibg=#cd98dd guifg=#21222c

  hi YankRoundRegion guifg=#333333 guibg=#fedf81

  hi link CmpBorderedWindow_FloatBorder Normal

  hi link WinSeparator Conceal

  hi link LspPreviewHoverDocBorder Normal

  hi ContextVt guifg=#74798b

  " IncSearch      xxx ctermfg=235 ctermbg=110 guifg=#272934 guibg=#7fbded
  hi IncSearch guifg=#21232c guibg=#9bb9cf
  " hi IncSearch guifg=#21232c guibg=#9bb9cf gui=reverse

  " Search         xxx ctermfg=235 ctermbg=107 guifg=#272934 guibg=#a6d085
  hi Search guifg=#16171d guibg=#a1cd7e

  " hi default link HlSearchNear IncSearch
  " hi default link HlSearchLens WildMenu
  " hi default link HlSearchLensNear IncSearch
  " hi default link HlSearchFloat IncSearch

  " hi IndentBlanklineChar guifg=#535666
  hi IndentBlanklineChar guifg=#454754
  " hi IndentBlanklineContextChar guifg=#8a8e9e
  hi IndentBlanklineContextChar guifg=#74798b

  " 背景色をグレーにする
  hi PounceUnmatched  ctermfg=248 guifg=#777777
  
  hi PounceMatch      gui=underline,bold guifg=#555555 guibg=#FFAF60
  hi PounceGap        gui=underline,bold guifg=#555555 guibg=#AAAAAA
  hi PounceAccept     gui=underline,reverse,bold guifg=#555555 guibg=#AAAAAA
  hi PounceAcceptBest gui=underline,bold guifg=#555555 guibg=#AAEEAA

endfunction

augroup MyColorScheme
  autocmd!
  autocmd ColorScheme * call s:define_my_highlight()
  " autocmd ColorScheme edge call s:define_my_highlight()
augroup END

set termguicolors

set bg=dark

let g:edge_style = 'neon'
let g:edge_enable_italic = 0
let g:edge_disable_italic_comment = 1
" let g:edge_better_performance = 1
let g:edge_menu_selection_background = 'blue'
" let g:edge_disable_terminal_colors = 1


colorscheme edge

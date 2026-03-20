scriptencoding utf-8


" =====================
" カーソル下の highlight 情報を取得 (name のみ) 
" =====================
command! SyntaxInfo call GetSynInfo()

" http://cohama.hateblo.jp/entry/2013/08/11/020849
function! s:get_syn_id(transparent) abort
  " synID() で 構文ID が取得できる
  " XXX: 構文ID
  "       synIDattr() と synIDtrans() に渡すことで"構文情報"を取得できる
  " trans に1を渡しているため、実際に表示されている文字が評価対象
  let synid = synID(line('.'), col('.'), 1)
  if a:transparent
    " ハイライトグループにリンクされた構文IDが取得できる
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! s:get_syn_attr(synid) abort
  let name = synIDattr(a:synid, 'name')
  return { 'name': name }
endfunction

function! GetSynInfo() abort
  let base_syn = s:get_syn_attr(s:get_syn_id(0))
  echo 'name: ' . base_syn.name

  " 1 を渡すとリンク先が取得できる
  let linked_syn = s:get_syn_attr(s:get_syn_id(1))
  echo 'link to'
  echo 'name: ' . linked_syn.name
endfunction


" ====================
" TouchPluginLua:
" ====================
command! -nargs=1 TouchPluginLua call TouchPlugin(<f-args>, 'lua')
command! -nargs=1 TouchPluginVim call TouchPlugin(<f-args>, 'vim')

function! TouchPlugin(name, type) abort
  let l:dir = a:type ==# 'vim' ? g:vim_plugin_config_dir : g:lua_plugin_config_dir
  call vimrc#drop_or_tabedit(printf('%s/%s.%s', l:dir, a:name, a:type))
endfunction

" ====================
" PackGet:
" ====================
command! -nargs=1 PackGet call PackGet(<f-args>)
function! PackGet(name) abort
  let l:url = a:name =~# '^http' ? a:name : 'https://github.com/' .. a:name
  let l:plug_name = matchstr(a:name, '[^/]\+$')
  let l:dist = printf('%s/pack/plugs/opt/%s', g:vimfiles_path, l:plug_name)
  if isdirectory(l:dist)
    call nvim_echo([[printf("[PackGet] Already exists. '%s'", l:plug_name), 'WarningMsg']], v:false, {})
    return
  endif

  botright 10new
  nnoremap <silent><buffer> q <Cmd>quit!<CR>
  call termopen(['git', 'clone', l:url, l:dist])
endfunction

command! PLUGINSTALL call <SID>plug_install()
function! s:plug_install() abort
  exec 'source ' .. g:plug_script
  PlugInstall
endfunction

command! OpenThis execute '! wslview ' .. expand('%:p')

command! CopyKeymap call <SID>copy_prk_firmware()
function! s:copy_prk_firmware() abort
  echo system('cp ' .. expand('%:p') .. ' /run/media/tamago324/PRKFirmware/keymap.rb')
endfunction

command! TaskRun lua require("telescope").extensions.vstask.tasks()

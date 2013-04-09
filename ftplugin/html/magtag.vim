" magtag.vim
"
" file created in 2013/04/08 00:04:06.
" LastUpdated :2013/04/09 09:07:28.
" Author: iNo
" Version: 1.0
" Licence: MIT license
"
" Description: Insert <img> tag after cursor position with image width and height property.
"
" Installation: Put this file into $HOME/.vim/ftplugin/html directory.
" This vim script is required ImageMagick.
"
" Options:
" g:magtag_insert_pos 
" Insert img tag position. 0: after cursor (default), 1: before cursor
"
" g:magtag_use_xml
" Use xml tag (adding close slash). 0: not using, 1: using (default)
"
" Usage:
" :MagTag hoge.jpg
"

if !exists('g:magtag_insert_pos')
  let g:magtag_insert_pos = 0
endif

if !exists('g:magtag_use_xml')
  let g:magtag_use_xml = 1
endif

command! -nargs=1 -complete=file -bang MagTag call s:insertImgTag('<f-args>')

function! s:getInsertPos()
  if g:magtag_insert_pos == 0
    return 'a'
  else
    return 'i'
  endif
endfunction

function! s:getCloseTag()
  if g:magtag_use_xml == 0
    return '>'
  else
    return ' />'
  endif
endfunction

function! s:insertImgTag(imgfile)
  let imgTag = system('identify -format "<img src=\"' . a:imgfile . '\" width=\"%w\" height=\"%h\" alt=\"\"' . s:getCloseTag() . '" "' . a:imgfile . '"')

  if matchend(imgTag, '<img src=') < 0
    echo a:imgfile . ' not found!'
    return
  endif

  let pos = getpos('.')

  execute ':normal ' . s:getInsertPos() . imgTag
  call setpos('.', pos)
endfunction

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

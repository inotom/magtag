" magtag.vim
"
" file created in 2013/04/08 00:04:06.
" LastUpdated :2013/07/30 09:30:38.
" Author: iNo
" Version: 1.0
" Licence: MIT license
"
" Description: Insert image_tag helper tag after cursor position with image width and height property.
"
" Installation: Put this file into $HOME/.vim/ftplugin/eruby directory.
" This vim script is required ImageMagick.
"
" Options:
" g:magtag_insert_pos 
" Insert img tag position. 0: after cursor (default), 1: before cursor
"
" Usage:
" :MagTag hoge.jpg
"

if !exists('g:magtag_insert_pos')
  let g:magtag_insert_pos = 0
endif

command! -nargs=1 -complete=file -bang MagTag call s:insertImgTag('<f-args>')

function! s:getInsertPos()
  if g:magtag_insert_pos == 0
    return 'a'
  else
    return 'i'
  endif
endfunction

function! s:insertImgTag(imgfile)
  let imgTag = system('identify -format "<%= image_tag \"' . a:imgfile . '\", :width => %w, :height => %h :alt => \"\"" "' . a:imgfile . '"')

  if matchend(imgTag, '<%= image_tag ') < 0
    echo a:imgfile . ' not found!'
    return
  endif

  let pos = getpos('.')

  execute ':normal ' . s:getInsertPos() . imgTag
  call setpos('.', pos)
endfunction

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

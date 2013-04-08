" magtag.vim
"
" file created in 2013/04/08 00:04:06.
" LastUpdated :2013/04/09 00:40:12.
" Author: iNo
" Version: 1.0
" Licence: MIT license
"
" Description: Insert <img> tag after cursor position with image width and height property.
"
" Installation: Put this file into $HOME/.vim/ftplugin/html directory.
" This vim script is required ImageMagick.
"
" Usage:
" :MagTag hoge.jpg
"

if !exists('g:imgsize_insert_pos')
  let g:imgsize_insert_pos = 0
endif

command! -nargs=1 -complete=file -bang MagTag call s:insertImgTag('<f-args>')

function! s:getInsertPos()
  if g:imgsize_insert_pos == 0
    return 'a'
  else
    return 'i'
  endif
endfunction

function! s:insertImgTag(imgfile)
  let imgTag = system('identify -format "<img src=\"' . a:imgfile . '\" width=\"%w\" height=\"%h\" alt=\"\" />" "' . a:imgfile . '"')

  if matchend(imgTag, '<img src=') < 0
    echo a:imgfile . ' not found!'
    return
  endif

  let pos = getpos('.')

  execute ':normal ' . s:getInsertPos() . imgTag
  call setpos('.', pos)
endfunction

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

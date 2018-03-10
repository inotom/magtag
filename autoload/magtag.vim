"
" File: autoload/magtag.vim
" file created in 2014/08/17 13:53:45.
" LastUpdated:2018/03/10 14:13:50.
" Author: iNo <wdf7322@yahoo.co.jp>
" Version: 3.0
" License: MIT License {{{
"   Permission is hereby granted, free of charge, to any person obtaining
"   a copy of this software and associated documentation files (the
"   "Software"), to deal in the Software without restriction, including
"   without limitation the rights to use, copy, modify, merge, publish,
"   distribute, sublicense, and/or sell copies of the Software, and to
"   permit persons to whom the Software is furnished to do so, subject to
"   the following conditions:
"
"   The above copyright notice and this permission notice shall be included
"   in all copies or substantial portions of the Software.
"
"   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"

if !exists('g:loaded_magtag')
  runtime! plugin/magtag.vim
endif

let s:save_cpo = &cpo
set cpo&vim

function! magtag#insertTag(imageFile)
  let imgFile = substitute(a:imageFile, '\v(^"|"$)', "", "g")
  try
    if &filetype ==# 'html'
      call s:insertHtml(imgFile)
    elseif &filetype ==# 'php'
      call s:insertPhp(imgFile)
    elseif &filetype ==# 'slim'
      call s:insertSlim(imgFile)
    elseif &filetype ==# 'eruby'
      call s:insertEruby(imgFile)
    else
      call s:insertHtml(imgFile)
    endif
  catch /^File not found: .*/
    echoe v:exception
  finally
  endtry
endfunction

function! s:getInsertPos()
  return g:magtag_insert_pos == 0 ? 'a' : 'i'
endfunction

function! s:getDimentionCount(templateStr)
  return len(split(a:templateStr, '%d', 1)) - 1
endfunction

function! s:makeTagStr(templateStr, imgPath, size)
  let dimCount = s:getDimentionCount(a:templateStr)
  if dimCount == 1
    return printf(a:templateStr, a:imgPath, a:size[0])
  elseif dimCount == 2
    return printf(a:templateStr, a:imgPath, a:size[0], a:size[1])
  else
    return printf(a:templateStr, a:imgPath)
  endif
endfunction

function! s:getImageSize(imgFile)
  let size = []

  if executable('awk')
    if executable('sips')
      let size = split(system("sips -g pixelWidth -g pixelHeight " . a:imgFile . " | awk '/pixelWidth|pixelHeight/ {printf $2\"\t\"}'"), "\t")
    elseif executable('imgsize')
      let size = split(system("imgsize -n " . a:imgFile), ",")
    elseif executable('identify')
      let size = split(system("identify " . a:imgFile . " | awk '{printf $3}'"), "x")
    else
      throw 'sips or identify command required!'
      finish
    endif
  endif

  return size
endfunction

function! s:absPath(imgFile)
  return '/' . substitute(a:imgFile, '\v^(\.\/|\.\.\/)*', "", "")
endfunction

function! s:getTag(imgFile, fileType)
  let tagStr = ''
  let size = s:getImageSize(a:imgFile)

  if len(size) == 2
    if a:fileType ==# 'html'
      let tagStr = s:makeTagStr(g:magtag_html_template, a:imgFile, size)
    elseif a:fileType ==# 'php'
      let tagStr = s:makeTagStr(g:magtag_php_template, s:absPath(a:imgFile), size)
    elseif a:fileType ==# 'slim'
      let tagStr = s:makeTagStr(g:magtag_slim_template, s:absPath(a:imgFile), size)
    elseif a:fileType ==# 'eruby'
      let tagStr = s:makeTagStr(g:magtag_eruby_template, s:absPath(a:imgFile), size)
    endif
  endif

  return tagStr
endfunction

function! s:insertHtml(imgFile)
  let tagStr = s:getTag(a:imgFile, 'html')

  if match(tagStr, '<img ') != 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertPhp(imgFile)
  let tagStr = s:getTag(a:imgFile, 'php')

  if match(tagStr, '<img ') != 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertSlim(imgFile)
  let tagStr = s:getTag(a:imgFile, 'slim')

  if matchend(tagStr, '= ') != 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertEruby(imgFile)
  let tagStr = s:getTag(a:imgFile, 'eruby')

  if match(tagStr, '<%= ') != 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertTag(tagStr)
  execute ':normal ' . s:getInsertPos() . a:tagStr
  call setpos('.', getpos('.'))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

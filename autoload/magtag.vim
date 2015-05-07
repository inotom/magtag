"
" File: autoload/magtag.vim
" file created in 2014/08/17 13:53:45.
" LastUpdated:2015/05/07 11:52:11.
" Author: iNo <wdf7322@yahoo.co.jp>
" Version: 2.3
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

function! magtag#insertTag(imgFile)
  try
    if &filetype ==# 'html'
      call s:insertHtml(a:imgFile)
    elseif &filetype ==# 'slim'
      call s:insertSlim(a:imgFile)
    elseif &filetype ==# 'eruby'
      call s:insertEruby(a:imgFile)
    else
      call s:insertHtml(a:imgFile)
    endif
  catch /^File not found: .*/
    echoe v:exception
  finally
  endtry
endfunction

function! s:getInsertPos()
  return g:magtag_insert_pos == 0 ? 'a' : 'i'
endfunction

function! s:getCloseTag()
  return g:magtag_use_xml == 0 ? '>' : ' />'
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
  return '"/' . substitute(a:imgFile, '\v^"(\.\/|\.\.\/)*', "", "")
endfunction

function! s:getTag(imgFile, fileType)
  let tagStr = ''
  let size = s:getImageSize(a:imgFile)

  if len(size) == 2
    if a:fileType ==# 'html'
      let tagStr = '<img src=' . a:imgFile . ' width="' . size[0] . '" height="' . size[1] . '" alt=""' . s:getCloseTag()
    elseif a:fileType ==# 'slim'
      let tagStr = '= ' . g:magtag_eruby_helper_tag . ' ' . s:absPath(a:imgFile) . ', :width => ' . size[0] . ', :height => ' . size[1] . ', :alt => ""'
    elseif a:fileType ==# 'eruby'
      let tagStr = '<%= ' . g:magtag_eruby_helper_tag . ' ' . s:absPath(a:imgFile) . ', :width => ' . size[0] . ', :height => ' . size[1] . ', :alt => "" %>'
    endif
  endif

  return tagStr
endfunction

function! s:insertHtml(imgFile)
  let tagStr = s:getTag(a:imgFile, 'html')

  if matchend(tagStr, '<img src=') < 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertSlim(imgFile)
  let tagStr = s:getTag(a:imgFile, 'slim')

  if matchend(tagStr, '= ' . g:magtag_eruby_helper_tag . ' ') < 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertEruby(imgFile)
  let tagStr = s:getTag(a:imgFile, 'eruby')

  if matchend(tagStr, '<%= ' . g:magtag_eruby_helper_tag . ' ') < 0
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

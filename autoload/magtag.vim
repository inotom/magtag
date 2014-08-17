"
" File: autoload/magtag.vim
" file created in 2014/08/17 13:53:45.
" LastUpdated:2014/08/17 18:16:49.
" Author: iNo <wdf7322@yahoo.co.jp>
" Version: 2.0
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
    echo v:exception
  finally
  endtry
endfunction

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

function! s:insertHtml(imgFile)
  let tagStr = system('identify -format "<img src=\"' . a:imgFile . '\" width=\"%w\" height=\"%h\" alt=\"\"' . s:getCloseTag() . '" "' . a:imgFile . '"')

  if matchend(tagStr, '<img src=') < 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertSlim(imgFile)
  let tagStr = system('identify -format "= image_tag ''/' . a:imgFile . ''', :width => %w, :height => %h, :alt => ''''" "' . a:imgFile . '"')

  if matchend(tagStr, '= image_tag ') < 0
    throw 'File not found: ' . a:imgFile
    finish
  endif

  call s:insertTag(tagStr)
endfunction

function! s:insertEruby(imgFile)
  let tagStr = system('identify -format "<\%= ' . g:magtag_eruby_helper_tag . ' ''/' . a:imgFile . ''', :width => %w, :height => %h, :alt => '''' \%>" "' . a:imgFile . '"')

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

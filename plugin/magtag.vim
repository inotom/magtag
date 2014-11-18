"
" File: plugin/magtag.vim
" file created in 2014/08/17 14:40:13.
" LastUpdated:2014/11/18 12:56:20.
" Author: iNo <wdf7322@yahoo.co.jp>
" Version: 2.1
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

if exists('g:loaded_magtag')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


let g:loaded_magtag = 1

if !exists('g:magtag_insert_pos')
  let g:magtag_insert_pos = 0
endif

if !exists('g:magtag_use_xml')
  let g:magtag_use_xml = 1
endif

if !exists('g:magtag_eruby_helper_tag')
  let g:magtag_eruby_helper_tag = 'image_tag'
endif

command! -nargs=1 -complete=file Magtag call magtag#insertTag('<f-args>')


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

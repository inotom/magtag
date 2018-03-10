"
" File: plugin/magtag.vim
" file created in 2014/08/17 14:40:13.
" LastUpdated:2018/03/10 14:13:44.
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

if exists('g:loaded_magtag')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


let g:loaded_magtag = 1

if !exists('g:magtag_insert_pos')
  let g:magtag_insert_pos = 0
endif

if !exists('g:magtag_html_template')
  let g:magtag_html_template = '<img src="%s" width="%d" height="%d" alt="">'
endif

if !exists('g:magtag_php_template')
  let g:magtag_php_template = '<img src="<?php the_img( ''%s'' ); ?>" width="%d" height="%d" alt="">'
endif

if !exists('g:magtag_slim_template')
  let g:magtag_slim_template = '= image_tag "%s", width: %d, height: "%d", alt=""'
endif

if !exists('g:magtag_eruby_template')
  let g:magtag_eruby_template = '<%%= image_tag "%s", width: %d, height: "%d", alt="" %%>'
endif

command! -nargs=1 -complete=file Magtag call magtag#insertTag('<f-args>')


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

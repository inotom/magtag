"
" File: autoload/magtag.vim
" file created in 2014/08/17 13:53:45.
" LastUpdated:2018/03/11 11:42:23.
" Author: iNo <wdf7322@yahoo.co.jp>
" Version: 3.1
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

let s:check_prefixes = {
\ 'html': '<img ',
\ 'php': '<img ',
\ 'slim': '= ',
\ 'eruby': '<%= ',
\}

let s:templates = {
\ 'html': g:magtag_html_template,
\ 'php': g:magtag_php_template,
\ 'slim': g:magtag_slim_template,
\ 'eruby': g:magtag_eruby_template,
\}

function! magtag#insertTag(fpath)
  let imgPath = substitute(a:fpath, '\v(^"|"$)', "", "g")
  try
    call s:insertTag(imgPath, &filetype)
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

function! s:makeTagStr(imgPath, fileType)
  let templateStr = s:getTemplateStr(a:fileType)
  let imgSrc = s:getImageSrc(a:imgPath, a:fileType)
  let dimCount = s:getDimentionCount(templateStr)
  let size = s:getImageSize(a:imgPath, dimCount)

  if dimCount == 1
    return printf(templateStr, imgSrc, size[0])
  elseif dimCount == 2
    return printf(templateStr, imgSrc, size[0], size[1])
  else
    return printf(templateStr, imgSrc)
  endif
endfunction

function! s:getImageSize(imgPath, dimentionCount)
  if a:dimentionCount > 0
    return s:readImageSize(a:imgPath)
  endif
  return [0, 0]
endfunction

function! s:readImageSize(imgPath)
  let size = []

  if executable('awk')
    if executable('sips')
      let size = split(system("sips -g pixelWidth -g pixelHeight " . a:imgPath . " | awk '/pixelWidth|pixelHeight/ {printf $2\"\t\"}'"), "\t")
    elseif executable('imgsize')
      let size = split(system("imgsize -n " . a:imgPath), ",")
    elseif executable('identify')
      let size = split(system("identify " . a:imgPath . " | awk '{printf $3}'"), "x")
    else
      throw 'sips or identify command required!'
      finish
    endif
  endif

  return size
endfunction

function! s:absPath(imgPath)
  return '/' . substitute(a:imgPath, '\v^(\.\/|\.\.\/)*', "", "")
endfunction

function! s:getTemplateStr(fileType)
  if has_key(s:templates, a:fileType)
    return s:templates[a:fileType]
  endif
  return s:templates['html']
endfunction

function! s:getImageSrc(imgPath, fileType)
  if a:fileType ==# 'html'
    return a:imgPath
  endif
  return s:absPath(a:imgPath)
endfunction

function! s:isValidTag(tagStr, fileType)
  return has_key(s:check_prefixes, a:fileType) && match(a:tagStr, s:check_prefixes[a:fileType]) != 0
endfunction

function! s:insertTag(imgPath, fileType)
  let tagStr = s:makeTagStr(a:imgPath, a:fileType)

  if s:isValidTag(tagStr, a:fileType)
    throw 'File not found: ' . a:imgPath
    finish
  endif

  execute ':normal ' . s:getInsertPos() . tagStr
  call setpos('.', getpos('.'))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo

" vim:fdl=0 fdm=marker:ts=2 sw=2 sts=0:

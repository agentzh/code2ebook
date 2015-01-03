" AnsiHighlight: Allows for marking up a file, using ANSI color escapes when
" the syntax changes colors, for easy, faithful reproduction.
" Author: Matthew Wozniski (mjw@drexel.edu)
" Date: Fri, 01 Aug 2008 05:22:55 -0400
" Version: 1.0 FIXME
" History: FIXME see :help marklines-history
" License: BSD. Completely open source, but I would like to be
" credited if you use some of this code elsewhere.

" Copyright (c) 2008, Matthew J. Wozniski {{{1
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
" * Redistributions of source code must retain the above copyright
" notice, this list of conditions and the following disclaimer.
" * Redistributions in binary form must reproduce the above copyright
" notice, this list of conditions and the following disclaimer in the
" documentation and/or other materials provided with the distribution.
" * The names of the contributors may not be used to endorse or promote
" products derived from this software without specific prior written
" permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" Turn off vi-compatible mode, unless it's already off {{{1
if &cp
  set nocp
endif

let s:type = 'cterm'
if &t_Co == 0
  let s:type = 'term'
endif

" Converts info for a highlight group to a string of ANSI color escapes {{{1
function! s:GroupToAnsi(groupnum)
  if ! exists("s:ansicache")
    let s:ansicache = {}
  endif

  let groupnum = a:groupnum

  if groupnum == 0
    let groupnum = hlID('Normal')
  endif

  if has_key(s:ansicache, groupnum)
    return s:ansicache[groupnum]
  endif

  let name = synIDattr(groupnum, 'name', s:type)

  let retv = "\<Esc>["

  if exists('name')
    let retv .= name
  endif

  let retv .= ";"

  let s:ansicache[groupnum] = retv

  return retv
endfunction

function! AnsiHighlight(output_file)
  let retv = []

  for lnum in range(1, line('$'))
    let last = hlID('Normal')
    let output = s:GroupToAnsi(last)

        " Hopefully fix highlighting sync issues
    exe "norm! " . lnum . "G$"

    let line = getline(lnum)

    for cnum in range(1, col('.'))
      if synIDtrans(synID(lnum, cnum, 1)) != last
        let last = synIDtrans(synID(lnum, cnum, 1))
        let output .= s:GroupToAnsi(last)
      endif

      let output .= matchstr(line, '\%(\zs.\)\{'.cnum.'}')
      "let line = substitute(line, '.', '', '')
            "let line = matchstr(line, '^\@<!.*')
    endfor
    let retv += [output]
  endfor
  " Reset the colors to default after displaying the file
  "let retv[-1] .= "\<Esc>[0m"

  return writefile(retv, a:output_file)
endfunction

" See copyright in the vims cript above (for the vim script) and in
" vimcat.md for the whole script.
"
" The list of contributors is at the bottom of the vimpager script in this
" project.
"
" vim: sw=2 sts=2 et ft=vim

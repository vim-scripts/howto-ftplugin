"
" ftplugin for browsing HOWTO files
" <LocalLeader><CR> switches between TOC and HOWTO body (from <1> to <2> below)
" <LocalLeader><Space> goes to the next topic in the HOWTO (from <2> to <3>)
"
" Example:
" <<BEGIN>>
" Table of Contents
" 1. How can I help? <1>
"     1.1. Assisting with the Net-HOWTO
" ...
" -----------------------------------------------------------------------------
" Chapter 1. How can I help? <2>
" ...
" -----------------------------------------------------------------------------
" 1.1. Assisting with the Net-HOWTO <3>
" <<END>>
"
" Install Notes:
" - copy ftplugin/howto.vim to ~/.vim/ftplugin/
" - copy ftdetect/howto.vim to ~/.vim/ftdetect/
" - make sure the following line is in your vimrc
"   filetype plugin on
"
" Last Change: 2003 Dec 15
" Maintainer:  John Sumsion (jdsumsion at earthlink net)
" License:     This plugin is placed in the public domain
" Version History:
" 1.0 (15 Dec 2003) - initial upload
"

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

"
" MAPPINGS
"

" Add mappings, unless the user didn't want this.
if !exists("no_plugin_maps") && !exists("no_howto_maps")
  if !hasmapto('<Plug>Switch')
    map <buffer> <unique> <silent> <LocalLeader><CR> <Plug>Switch
    map <buffer> <unique> <silent> <LocalLeader><Space> <Plug>GotoNext
  endif
  nnoremap <buffer> <Plug>Switch :call <SID>SwitchBetweenHOWTO_TOC_Section()<CR>
  nnoremap <buffer> <silent> <Plug>GotoNext :call <SID>GotoNextHOWTO_Section()<CR>
endif

"
" FUNCTIONS
"

function! s:SwitchBetweenHOWTO_TOC_Section()
  " Finds any of the following:
  " Chapter 1. How can I help?
  " 1. How can I help?
  "         5.1.1. Current Kernel source(Optional).
  " 5.1.1. Current Kernel source(Optional).
  let HOWTO_SectionPattern = '\v^(Chapter | *)?((\d+\.)+.*)$'
  let current_line=getline('.')
  if (current_line =~ HOWTO_SectionPattern)
    " extract the HOWTO section (incl. section number and name)
    let section_number_name = substitute(current_line, HOWTO_SectionPattern, '\2', '')
    let escaped_section_name = escape(section_number_name, '\')
    call search('\V\(Chapter \| \*\)\?' . escaped_section_name, 'w')
  else
    " if not on a section line, look back for the first section line we see
    call search(HOWTO_SectionPattern, 'bW')
    let resulting_line=getline('.')
    if (resulting_line =~ HOWTO_SectionPattern)
      " call recursively to do the actual switching (we know it will succeed
      " because we have already checked to see if the current line matches)
      call SwitchBetweenHOWTO_TOC_Section()
    endif
  endif
endf

function! s:GotoNextHOWTO_Section()
  let HOWTO_SectionPattern = '\v^(Chapter | *)?((\d+\.)+.*)$'
  call search(HOWTO_SectionPattern, 'W')
endf


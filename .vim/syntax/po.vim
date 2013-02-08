" Vim syntax file
" Language:	po (gettext)
" Maintainer:	Nam SungHyun <namsh@kldp.org>
" Patchedby:	Sung-Hyun Nam <namsh@kldp.org>
" Last Change:	2001 Apr 26

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match  poComment	"^#.*$"
syn match  poSources	"^#:.*$"
syn match  poStatement	"^\(domain\|msgid\|msgstr\)"
syn match  poSpecial	contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match  poFormat	"%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlL]\|ll\)\=\([diuoxXfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
syn match  poFormat	"%%" contained
syn region poString	start=+"+ skip=+\\\\\|\\"+ end=+"+
			\ contains=poSpecial,poFormat

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_po_syn_inits")
  if version < 508
    let did_po_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink poComment	Comment
  HiLink poSources	PreProc
  HiLink poStatement	Statement
  HiLink poSpecial	Special
  HiLink poFormat	poSpecial
  HiLink poString	String

  delcommand HiLink
endif

let b:current_syntax = "po"

" vim:set ts=8 sts=2 sw=2 noet:

"
" ###########
"


" po.vimrc: VIM resource for 'po' file editing.

set   com=
set   path=.,..,../src,,

" find a non-translated msg string
nmap,fm :call FindNonTransMsg()<CR>z.
imap<C-G> <ESC>:call FindNonTransMsg()<CR>z.$i

" find fuzzy and remove
nmap,ff :call FindFuzzyErase()<CR>

" duplicate the original msg.
nmap,fd }?^msgstr<CR>f"ld}?^msgid<CR>f"ly/^msgstr<CR>nf"pNf"l

" erase the translated message
nmap,fe }?^msgstr<CR>f"lc}"<ESC>

" perform language dependent checks on strings
nmap,fc :!msgfmt --check %<CR>

" show statistics
nmap,fs :!msgfmt --statistics %<CR>

" commit current file
nmap,ci :!cvs ci -m '' %<LEFT><LEFT><LEFT>

" goto file which contains the current string
nmap,gf  {/^#: <CR>02f:l"aye0f w<C-W><C-F>:<C-R>a<CR>

function! FindNonTransMsg()
  let lnum = line(".") + 1
  let enum = line("$")
  let found = 0
  while lnum < enum
    let line = getline(lnum)
    let lnum = lnum + 1
    if line == "msgstr \"\""
      let blank = getline(lnum)
      if blank == ""
        let found = found + 1
        exec "normal " . lnum . "ggk"
        let lnum = enum
      endif
      let lnum = lnum + 1
    endif
  endwhile
  if found < 1
    echo "Cannot find non-translated msg"
  endif
endfun

func! FindFuzzyErase()
  let lnum = line(".") + 1
  let enum = line("$")
  while lnum < enum
    let line = getline(lnum)
    if line =~ "#, fuzzy"
      exec "normal " .lnum. "gg"
      if line =~ "#, fuzzy, "
	exec "normal ^ldt,"
      else
	exec "normal dd"
      endif
      /^msgstr
      exec "norm z.f\"l"
      echohl WarningMsg | echo "You may want to edit this" | echohl None
      return
    endif
    let lnum = lnum + 1
  endwhile
  echo "There's no fuzzy"
endfun


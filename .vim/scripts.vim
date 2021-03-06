" Vim support file to detect file types in scripts
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2003 May 10

" This file is called by an autocommand for every file that has just been
" loaded into a buffer.  It checks if the type of file can be recognized by
" the file contents.  The autocommand is in $VIMRUNTIME/filetype.vim.


" Only do the rest when the FileType autocommand has not been triggered yet.
if did_filetype()
  finish
endif

" Load the user defined scripts file first
" Only do this when the FileType autocommand has not been triggered yet
if exists("myscriptsfile") && file_readable(expand(myscriptsfile))
  execute "source " . myscriptsfile
  if did_filetype()
    finish
  endif
endif

" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpo
set cpo&vim

let s:line1 = getline(1)

if s:line1 =~ "^#!"
  " A script that starts with "#!".

  " Check for a line like "#!/usr/bin/env VAR=val bash".  Turn it into
  " "#!/usr/bin/bash" to make matching easier.
  if s:line1 =~ '^#!\s*\S*\<env\s'
    let s:line1 = substitute(s:line1, '\S\+=\S\+', '', 'g')
    let s:line1 = substitute(s:line1, '\<env\s\+', '', '')
  endif

  " Get the program name.
  " Only accept spaces in PC style paths: "#!c:/program files/perl [args]".
  " If there is no path use the first word: "#!perl [path/args]".
  " Otherwise get the last word after a slash: "#!/usr/bin/perl [path/args]".
  if s:line1 =~ '^#!\s*\a:[/\\]'
    let s:name = substitute(s:line1, '^#!.*[/\\]\(\i\+\).*', '\1', '')
  elseif s:line1 =~ '^#!\s*[^/\\ ]*\>\([^/\\]\|$\)'
    let s:name = substitute(s:line1, '^#!\s*\([^/\\ ]*\>\).*', '\1', '')
  else
    let s:name = substitute(s:line1, '^#!\s*\S*[/\\]\(\i\+\).*', '\1', '')
  endif

  " Bourne-like shell scripts: sh ksh bash bash2
  if s:name =~ '^\(bash\|bash2\|ksh\|sh\)\>'
    call SetFileTypeSH(s:line1)	" defined in filetype.vim

    " csh and tcsh scripts
  elseif s:name =~ '^t\=csh\>'
    set ft=csh

    " Z shell scripts
  elseif s:name =~ '^zsh\>'
    set ft=zsh

    " TCL scripts
  elseif s:name =~ '^\(tclsh\|wish\|expectk\|itclsh\|itkwish\)\>'
    set ft=tcl

    " Expect scripts
  elseif s:name =~ '^expect\>'
    set ft=expect

    " Gnuplot scripts
  elseif s:name =~ '^gnuplot\>'
    set ft=gnuplot

    " Makefiles
  elseif s:name =~ 'make\>'
    set ft=make

    " Perl
  elseif s:name =~ 'perl'
    set ft=perl

    " PHP
  elseif s:name =~ 'php'
    set ft=php

    " Python
  elseif s:name =~ 'python'
    set ft=python

    " Ruby
  elseif s:name =~ 'ruby'
    set ft=ruby

    " BC calculator
  elseif s:name =~ '^bc\>'
    set ft=bc

    " sed
  elseif s:name =~ 'sed\>'
    set ft=sed

    " OCaml-scripts
  elseif s:name =~ 'ocaml'
    set ft=ocaml

    " Awk scripts
  elseif s:name =~ 'awk\>'
    set ft=awk

    " Website MetaLanguage
  elseif s:name =~ 'wml'
    set ft=wml

    " Scheme scripts
  elseif s:name =~ 'scheme'
    set ft=scheme

  endif
  unlet s:name

else
  " File does not start with "#!".

  let s:line2 = getline(2)
  let s:line3 = getline(3)
  let s:line4 = getline(4)
  let s:line5 = getline(5)

  " Bourne-like shell scripts: sh ksh bash bash2
  if s:line1 =~ '^:$'
    call SetFileTypeSH(s:line1)	" defined in filetype.vim

    " Z shell scripts
  elseif s:line1 =~ '^#compdef\>' || s:line1 =~ '^#autoload\>'
    set ft=zsh

  " ELM Mail files
  elseif s:line1 =~ '^From [a-zA-Z][a-zA-Z_0-9\.=-]*\(@[^ ]*\)\= .*[12][09]\d\d$'
    set ft=mail

    " Mason
  elseif s:line1 =~ '^<[%&].*>'
    set ft=mason

    " Vim scripts (must have '" vim' as the first line to trigger this)
  elseif s:line1 =~ '^" *[vV]im$'
    set ft=vim

    " MOO
  elseif s:line1 =~ '^\*\* LambdaMOO Database, Format Version \%([1-3]\>\)\@!\d\+ \*\*$'
    set ft=moo

    " Diff file:
    " - "diff" in first line (context diff)
    " - "Only in " in first line
    " - "--- " in first line and "+++ " in second line (unified diff).
    " - "*** " in first line and "--- " in second line (context diff).
    " - "# It was generated by makepatch " in the second line (makepatch diff).
    " - "Index: <filename>" in the first line (CVS file)
  elseif s:line1 =~ '^diff\>' || s:line1 =~ '^Only in '
	\ || (s:line1 =~ '^--- ' && s:line2 =~ '^+++ ')
	\ || (s:line1 =~ '^\*\*\* ' && s:line2 =~ '^--- ')
	\ || s:line1 =~ '^\d\+\(,\d\+\)\=[cda]\d\+\>'
	\ || s:line2 =~ '^# It was generated by makepatch '
	\ || s:line1 =~ '^Index:\s\+\f\+$'
	\ || s:line1 =~ '^==== //\f\+#\d\+'
    set ft=diff

    " PostScript Files (must have %!PS as the first line, like a2ps output)
  elseif s:line1 =~ '^%![ \t]*PS'
    set ft=postscr

    " M4 scripts: Guess there is a line that starts with "dnl".
  elseif s:line1 =~ '^\s*dnl\>'
	\ || s:line2 =~ '^\s*dnl\>'
	\ || s:line3 =~ '^\s*dnl\>'
	\ || s:line4 =~ '^\s*dnl\>'
	\ || s:line5 =~ '^\s*dnl\>'
    set ft=m4

    " AmigaDos scripts
  elseif $TERM == "amiga"
	\ && (s:line1 =~ "^;" || s:line1 =~ '^\.[bB][rR][aA]')
    set ft=amiga

    " SiCAD scripts (must have procn or procd as the first line to trigger this)
  elseif s:line1 =~? '^ *proc[nd] *$'
    set ft=sicad

    " Purify log files start with "****  Purify"
  elseif s:line1 =~ '^\*\*\*\*  Purify'
    set ft=purifylog

    " XML
  elseif s:line1 =~ '<?\s*xml.*?>'
    set ft=xml

    " XHTML (e.g.: PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN")
  elseif s:line1 =~ '\<DTD\s\+XHTML\s'
    set ft=xhtml

    " XXD output
  elseif s:line1 =~ '^\x\{7}: \x\{2} \=\x\{2} \=\x\{2} \=\x\{2} '
    set ft=xxd

    " RCS/CVS log output
  elseif s:line1 =~ '^RCS file:' || s:line2 =~ '^RCS file:'
    set ft=rcslog

    " CVS commit
  elseif s:line2 =~ '^CVS:'
    set ft=cvs

    " Send-pr
  elseif s:line1 =~ '^SEND-PR:'
    set ft=sendpr

    " SNNS files
  elseif s:line1 =~ '^SNNS network definition file'
    set ft=snnsnet
  elseif s:line1 =~ '^SNNS pattern definition file'
    set ft=snnspat
  elseif s:line1 =~ '^SNNS result file'
    set ft=snnsres

    " Virata
  elseif s:line1 =~ '^%.\{-}[Vv]irata'
	\ || s:line2 =~ '^%.\{-}[Vv]irata'
	\ || s:line3 =~ '^%.\{-}[Vv]irata'
	\ || s:line4 =~ '^%.\{-}[Vv]irata'
	\ || s:line5 =~ '^%.\{-}[Vv]irata'
    set ft=virata

    " Strace
  elseif s:line1 =~ '^[0-9]* *execve('
    set ft=strace

    " VSE JCL
  elseif s:line1 =~ '^\* $$ JOB\>' || s:line1 =~ '^// *JOB\>'
    set ft=vsejcl

    " TAK and SINDA
  elseif s:line4 =~ 'K & K  Associates' || s:line2 =~ 'TAK 2000'
    set ft=takout
  elseif s:line3 =~ 'S Y S T E M S   I M P R O V E D '
    set ft=sindaout
  elseif getline(6) =~ 'Run Date: '
    set ft=takcmp
  elseif getline(9) =~ 'Node    File  1'
    set ft=sindacmp

    " DNS zone files
  elseif s:line1.s:line2 =~ '$ORIGIN\|$TTL\|IN\s*SOA'
	\ || s:line1.s:line2.s:line3.s:line4 =~ 'BIND.*named'
    set ft=dns

    " BAAN
  elseif s:line1 =~ '|\*\{1,80}' && s:line2 =~ 'VRC '
	\ || s:line2 =~ '|\*\{1,80}' && s:line3 =~ 'VRC '
    set ft=baan

  " Valgrind
  elseif s:line1 =~ '^==\d\+== valgrind'
    set ft=valgrind

  " Renderman Interface Bytestream
  elseif s:line1 =~ '^##RenderMan'
    set ft=rib

  " Scheme scripts
  elseif s:line1 =~ 'exec\s\+\S*scheme' || s:line2 =~ 'exec\s\+\S*scheme'
    set ft=scheme

  " CVS diff
  else
    let lnum = 1
    while getline(lnum) =~ "^? " && lnum < line("$")
      let lnum = lnum + 1
    endwhile
    if getline(lnum) =~ '^Index:\s\+\f\+$'
      set ft=diff
    endif

  endif

  unlet s:line2 s:line3 s:line4 s:line5

endif

" Restore 'cpoptions'
let &cpo = s:cpo_save

unlet s:cpo_save s:line1

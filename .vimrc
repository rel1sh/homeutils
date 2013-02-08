" Alex's vimrc file.
" Taken from Bran Moolenaar's example file.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Tab size
set ts=4
set sw=4
set showmatch
set mat=5			" show match for 0.5 sec
set smartcase
set so=5			" keep 5 lines top/bottom visible (for scope)
set nomodeline
set laststatus=2
set statusline=%F%m%r%h%w\ frmt=%{&ff}\ ascii=\%03.3b\ pos=%04l,%04v\ len=%L



" wildmenu
set wildmenu

" Autocommands
autocmd BufEnter * :lcd %:p:h
					" switch to current dir

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir^=$HOME/tmp/backup		" override the backup file directory
  "set directory^=$HOME/tmp/backup		" override the swap file directory (?)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" GUI or Color mode
if &t_Co > 2 || has("gui_running")
  syntax enable 
  set nohlsearch
  set guioptions-=T

  colorscheme torte
  
  if (has("gui_running"))
	  set guifontset=-*-fixed-medium-r-normal--14-*-*-*-c-*-*-*,-*-*-medium-r-normal--14-*-*-*-c-*-*-*,-*-*-medium-r-normal--14-*-*-*-m-*-*-*,*
  endif 
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  "augroup vimrcEx
  "au!

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " This code would always jump to the last known cursor position.
  "  autocmd BufReadPost *
  "    \ if line("'\"") > 0 && line("'\"") <= line("$") |
  "    \   exe "normal g`\"" |
  "    \ endif

  "  augroup END

  " Preserve noeol (missing trailing eol) when saving file. In order
  " to do this we need to temporarily 'set binary' for the duration of 
  " file writing, and for DOS line endings, add the CRs manually.
  " For Mac line endings, also must join everything to one line since it doesn't
  " use a LF character anywhere and 'binary' writes everything as if it were Unix.

  " This works because 'eol' is set properly no matter what file format is used,
  " even if it is only used when 'binary' is set.
  " @ http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files

  augroup automatic_noeol
  au!

  au BufWritePre  * call TempSetBinaryForNoeol()
  au BufWritePost * call TempRestoreBinaryForNoeol()

  fun! TempSetBinaryForNoeol()
    let s:save_binary = &binary
    if ! &eol && ! &binary
      setlocal binary
      if &ff == "dos" || &ff == "mac"
        undojoin | silent 1,$-1s#$#\=nr2char(13)
      endif
      if &ff == "mac"
        let s:save_eol = &eol
        undojoin | %join!
        " mac format does not use a \n anywhere, so don't add one when writing in
        " binary (uses unix format always)
        setlocal noeol
      endif
    endif
  endfun

  fun! TempRestoreBinaryForNoeol()
    if ! &eol && ! s:save_binary
      if &ff == "dos"
        undojoin | silent 1,$-1s/\r$/
      elseif &ff == "mac"
        undojoin | %s/\r/\r/g
        let &l:eol = s:save_eol
      endif
      setlocal nobinary
    endif
  endfun
  
  augroup END

else

  "set autoindent		" always set autoindenting on

endif " has("autocmd")


" Call PHP rc when editing PHP files
"autocmd BufRead *.php source /home/alex/.vim/vimrc-php

let php_noindent_switch=1
let php_folding=0
set formatoptions=croql

set autoindent

function ShortTabLine()
  let ret = ''
  for i in range(tabpagenr('$'))
    " select the color group for highlighting active tab
      if i + 1 == tabpagenr()
      let ret .= '%#errorMsg#'
    else
      let ret .= '%#TabLine#'
     endif
   
     " find the buffername for the tablabel
        let buflist = tabpagebuflist(i+1)
        let winnr = tabpagewinnr(i+1)
        let buffername = bufname(buflist[winnr - 1])
        let filename = fnamemodify(buffername,':t')
     " check if there is no name
     if filename == ''
       let filename = 'noname'
     endif
     " only show the first 6 letters of the name  and
     " .. if the filename is more than 8 letters long
     if strlen(filename) >=8
         let ret .= '['. filename[0:5].'..]'
     else
          let ret .= '['.filename.']'
     endif
  endfor

  " after the last tab fill with TabLineFill and reset tab page #
   let ret .= '%#TabLineFill#%T'
   return ret
endfunction

set tabline=%!ShortTabLine()


"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Sep 09
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc


set foldmethod=marker " define folder method as manual
set fileencodings=utf-8,default,latin1
"set foldmethod=indent " define folder method as manual
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nobackup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

set ts=2                " makes tabulation to work as 4 spaces
set shiftwidth=2
set expandtab
set nohls "no highlits for search
set wrap
set nohls
set nocin
set smartindent
set smarttab
"shows encoding of the file
set statusline=%<%f%h%m%r%=%b\ %{&encoding}\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2
set ignorecase smartcase

set incsearch

"set keywordprg=/usr/bin/ispell "makes ispell a default spellchecker for kommand K
set vb "makes visual bell instead of sound
"to turn synthax color on
"set term=builtin_beos-ansi

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

nmap <unique> <Leader>s ysiW

map R :!ruby % <cr>
map S :!spec % <cr>
"map <silent> <Leader>P :Project<CR>
"map L :!ispell % <cr>
"map K :!ispell <cr>
" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  highlight Comment ctermfg=Blue
  "hi Comment term=bold ctermfg=1 guibg=White
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 " autocmd BufRead *.txt set tw=78

 autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
 autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
 autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
 autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
 autocmd User Rails Rcommand spm spec/models -glob=**/* -suffix=_spec.rb -default=model()
 autocmd User Rails Rcommand sph spec/helpers -glob=**/* -suffix=_helper_spec.rb -default=controller()
 autocmd User Rails Rcommand spc spec/controllers -glob=**/* -suffix=_controller_spec.rb -default=controller()
 autocmd User Rails Rcommand spv spec/views -glob=**/* -suffix=_view_spec.rb
 autocmd User Rails Rcommand spf spec/fixtures -glob=**/* -suffix=.yml
 autocmd User Rails Rcommand cfg config -glob=**/* -suffix=.rb


 augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For C and C++ files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd FileType *      set formatoptions=tcql nocindent comments&
  autocmd FileType c,cpp  set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
 augroup END

 augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  " set binary mode before reading the file
  autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
  autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
  autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
  autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
  autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
  autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
  autocmd FileAppendPost		*.gz call GZIP_write("gzip")
  autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

  " After reading compressed file: Uncompress text in buffer with "cmd"
  fun! GZIP_read(cmd)
    let ch_save = &ch
    set ch=2
    execute "'[,']!" . a:cmd
    set nobin
    let &ch = ch_save
    execute ":doautocmd BufReadPost " . expand("%:r")
  endfun

  " After writing compressed file: Compress written file with "cmd"
  fun! GZIP_write(cmd)
    if rename(expand("<afile>"), expand("<afile>:r")) == 0
      execute "!" . a:cmd . " <afile>:r"
    endif
  endfun

  " Before appending to compressed file: Uncompress file with "cmd"
  fun! GZIP_appre(cmd)
    execute "!" . a:cmd . " <afile>"
    call rename(expand("<afile>:r"), expand("<afile>"))
  endfun

 augroup END

 " This is disabled, because it changes the jumplist.  Can't use CTRL-O to go
 " back to positions in previous files more than once.
 if 0
  " When editing a file, always jump to the last cursor position.
  " This must be after the uncompress commands.
   autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
 endif

endif " has("autocmd")




set encoding=utf-8
set termencoding=utf-8

map <F8> :execute RotateEnc()<CR>
map <F7> :let &fileencoding=&encoding<CR>
map <F6> :%s/├Т/"/ge<CR>:%s/├У/"/ge<CR> :%s/├Х/'/ge<CR>
" some funcs

let b:encindex=0
function! RotateEnc()
    let y = -1
    while y == -1
        let encstring = "#utf-8#koi8-r#default#latin1#"
        let x = match(encstring,"#",b:encindex)
        let y = match(encstring,"#",x+1)
        let b:encindex = x+1
        if y == -1
            let b:encindex = 0
        else
            let str = strpart(encstring,x+1,y-x-1)
            return ":set encoding=".str
        endif
    endwhile
endfunction

function! Find(name)
 let l:_name = substitute(a:name, "\\s", ".*", "g")
 let l:list=system("find . -iname '*' | grep  \"".l:_name."\" |grep -v \"class$\" | grep -v \".swp$\" | grep -v \"\.svn\" | grep -v \"\.git\" | grep -v vendor | perl -ne 'print \"$.\\t$_\"'")
 let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
 if l:num < 1
   echo "'".a:name."' not found"
   return
 endif

 if l:num != 1
   echo l:list
   let l:input=input("Which ? (<enter>=nothing)\n")

   if strlen(l:input)==0
     return
   endif

   if strlen(substitute(l:input, "[0-9]", "", "g"))>0
     echo "Not a number"
     return
   endif

   if l:input<1 || l:input>l:num
     echo "Out of range"
     return
   endif

   let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
 else
   let l:line=l:list
 endif

 let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
 execute ":e ".l:line
endfunction

command! -nargs=1 Find :call Find("<args>")
command W w !sudo tee % >/dev/null

function Openf()
  edit <cfile>
  bfirst
endfunction

"python << EOL
"import vim, StringIO,sys
"def PyExecReplace(line1,line2):
"    r = vim.current.buffer.range(int(line1),int(line2))
"    redirected = StringIO.StringIO()
"    sys.stdout = redirected
"    exec('\n'.join(r[:]) + '\n')
"   sys.stdout = sys.__stdout__
"    output = redirected.getvalue().split('\n')
"    r[:] = output[:-1] # the -1 is to remove the final blank line
"    redirected.close()
"EOL
"command -range Pyer python PyExecReplace(<f-line1>,<f-line2>)
"------ this clears out the old colors before we begin
"highlight Constant    NONE
"highlight Delimiter   NONE
"highlight Directory   NONE
"highlight Error       NONE
"highlight ErrorMsg    NONE
"highlight Identifier  NONE
"highlight LineNr      NONE
"highlight ModeMsg     NONE
"highlight MoreMsg     NONE
"highlight Normal      NONE
"highlight NonText     NONE
"highlight PreProc     NONE
"highlight Question    NONE
"highlight Search      NONE
"highlight Special     NONE
"highlight SpecialKey  NONE
"highlight Statement   NONE
"highlight StatusLine  NONE
"highlight Title       NONE
"highlight Todo        NONE
"highlight Type        NONE
"highlight Visual      NONE
"highlight WarningMsg  NONE
"
""----- these are the new superior colors
"highlight Normal      ctermfg=white guifg=#dce6ff guibg=#0a0f46
"highlight Comment     term=bold ctermfg=5 ctermbg=0 guifg=Purple guibg=Black
"highlight Constant    term=underline ctermfg=6 guifg=#FF2f8f
"highlight Delimiter   term=bold cterm=bold ctermfg=1 gui=bold guifg=Red
"highlight Directory   term=bold ctermfg=DarkBlue guifg=Blue
"highlight Error       term=standout cterm=bold ctermbg=1 ctermfg=2 gui=bold guifg=red
"highlight ErrorMsg    term=standout cterm=bold ctermfg=1 gui=bold guifg=red
"highlight Identifier  term=underline ctermfg=3 guifg=yellow
"highlight LineNr      term=underline cterm=bold ctermfg=3 guifg=Brown
"highlight ModeMsg     term=bold cterm=bold ctermfg=3 ctermbg=1 guifg=yellow2 guibg=red
"highlight MoreMsg     term=bold cterm=bold ctermfg=2 gui=bold guifg=Green
"highlight NonText     term=bold ctermfg=2 guifg=green3
"highlight PreProc     term=underline ctermfg=14 guifg=cyan
"highlight Question    term=standout cterm=bold ctermfg=2 gui=bold guifg=Green
"highlight Search      term=reverse ctermbg=2 ctermfg=4 guibg=Yellow
"highlight Special     term=bold ctermfg=5 guifg=SlateBlue
"highlight SpecialKey  term=bold ctermfg=DarkBlue guifg=Blue
"highlight Statement   term=bold ctermfg=2 gui=bold guifg=green3
"highlight StatusLine  term=reverse cterm=bold ctermfg=3 ctermbg=4 guifg=wheat guibg=#2f4f4f
"highlight StatusLineNC term=bold ctermfg=2 ctermbg=5 guifg=#071f1f guibg=#5f9f9f
"highlight Title       term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
"highlight Todo        term=bold ctermfg=red ctermbg=yellow guifg=red guibg=yellow1 gui=bold
"highlight Type        term=underline cterm=bold ctermfg=3 guifg=yellow gui=bold
"highlight Visual      term=reverse cterm=bold ctermfg=6 ctermbg=5 guifg=yellow guibg=blue
"highlight WarningMsg  term=standout cterm=bold ctermfg=1 ctermbg=4 guifg=Red

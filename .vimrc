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
" set spell spelllang=en_us

set incsearch

"set keywordprg=/usr/bin/ispell "makes ispell a default spellchecker for kommand K
set vb "makes visual bell instead of sound
"to turn synthax color on
"set term=builtin_beos-ansi
ab #!! #!/usr/bin/env ruby<newline><newline>
ab dbg require 'ruby-debug'; debugger
filetype plugin indent on

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

nmap <unique> <Leader>s ysiW

map R :!ruby % <cr>
map S :!spec % <cr>
map } :tabn <cr>
map { :tabp <cr>
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
  "set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

 " In text files, always limit the width of text to 78 characters
 " autocmd BufRead *.txt set tw=78

 autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
 autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
 autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
 autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
 autocmd User Rails Rnavcommand spm spec/models -glob=**/* -suffix=_spec.rb -default=model()
 autocmd User Rails Rnavcommand sph spec/helpers -glob=**/* -suffix=_helper_spec.rb -default=controller()
 autocmd User Rails Rnavcommand spc spec/controllers -glob=**/* -suffix=_controller_spec.rb -default=controller()
 autocmd User Rails Rnavcommand spv spec/views -glob=**/* -suffix=_view_spec.rb
 autocmd User Rails Rnavcommand spf spec/fixtures -glob=**/* -suffix=.yml
 autocmd User Rails Rnavcommand cfg config -glob=**/* -suffix=.rb


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
command -bar -nargs=1 OpenURL :!open <args>

function Openf()
  edit <cfile>
  bfirst
endfunction

" Increment the number below for a dynamic #include guard
let s:autotag_vim_version=1

if exists("g:autotag_vim_version_sourced")
   if s:autotag_vim_version == g:autotag_vim_version_sourced
      finish
   endif
endif

let g:autotag_vim_version_sourced=s:autotag_vim_version

" This file supplies automatic tag regeneration when saving files
" There's a problem with ctags when run with -a (append)
" ctags doesn't remove entries for the supplied source file that no longer exist
" so this script (implemented in python) finds a tags file for the file vim has
" just saved, removes all entries for that source file and *then* runs ctags -a

if has("python")

python << EEOOFF
import os
import string
import os.path
import fileinput
import sys
import vim
import time

# Just in case the ViM build you're using doesn't have subprocess
if sys.version < '2.4':
   def do_cmd(cmd, cwd):
      old_cwd=os.getcwd()
      os.chdir(cwd)
      (ch_in, ch_out) = os.popen2(cmd)
      for line in ch_out:
         pass
      os.chdir(old_cwd)

   import traceback
   def format_exc():
      return ''.join(traceback.format_exception(*list(sys.exc_info())))

else:
   import subprocess
   def do_cmd(cmd, cwd):
      p = subprocess.Popen(cmd, shell=True, stdout=None, stderr=None, cwd=cwd)

   from traceback import format_exc

def echo(str):
   str=str.replace('\\', '\\\\')
   str=str.replace('"', "'")
   vim.command("redraw | echo \"%s\"" % str)

def diag(verbosity, threshold, msg, args = None):
   if msg and args:
      msg = msg % args
   if verbosity >= threshold:
      echo(msg)

def goodTag(line, excluded):
   if line[0] == '!':
      return True
   else:
      f = string.split(line, '\t')
      if len(f) > 3 and not f[1] in excluded:
         return True
   return False

class AutoTag:
   __maxTagsFileSize = 1024 * 1024 * 7
   __threshold = 1

   def __init__(self, excludesuffix="", ctags_cmd="ctags", verbosity=0, tags_file=None):
      self.tags = {}
      self.excludesuffix = [ "." + s for s in excludesuffix.split(".") ]
      verbosity = long(verbosity)
      if verbosity > 0:
         self.verbosity = verbosity
      else:
         self.verbosity = 0
      self.sep_used_by_ctags = '/'
      self.ctags_cmd = ctags_cmd
      self.tags_file = tags_file
      self.count = 0

   def findTagFile(self, source):
      self.__diag('source = "%s"' % (source, ))
      ( drive, file ) = os.path.splitdrive(source)
      while file:
         file = os.path.dirname(file)
         #self.__diag('drive = "%s", file = "%s"' % (drive, file))
         tagsFile = os.path.join(drive, file, self.tags_file)
         #self.__diag('tagsFile "%s"' % tagsFile)
         if os.path.isfile(tagsFile):
            st = os.stat(tagsFile)
            if st:
               size = getattr(st, 'st_size', None)
               if size is None:
                  self.__diag("Could not stat tags file %s" % tagsFile)
                  return None
               if AutoTag.__maxTagsFileSize and size > AutoTag.__maxTagsFileSize:
                  self.__diag("Ignoring too big tags file %s" % tagsFile)
                  return None
            return tagsFile
         elif not file or file == os.sep or file == "//" or file == "\\\\":
            #self.__diag('bail (file = "%s")' % (file, ))
            return None
      return None

   def addSource(self, source):
      if not source:
         self.__diag('No source')
         return
      if os.path.basename(source) == self.tags_file:
         self.__diag("Ignoring tags file %s" % (self.tags_file,))
         return
      (base, suff) = os.path.splitext(source)
      if suff in self.excludesuffix:
         self.__diag("Ignoring excluded suffix %s for file %s" % (source, suff))
         return
      tagsFile = self.findTagFile(source)
      if tagsFile:
         relativeSource = source[len(os.path.dirname(tagsFile)):]
         if relativeSource[0] == os.sep:
            relativeSource = relativeSource[1:]
         if os.sep != self.sep_used_by_ctags:
            relativeSource = string.replace(relativeSource, os.sep, self.sep_used_by_ctags)
         if self.tags.has_key(tagsFile):
            self.tags[tagsFile].append(relativeSource)
         else:
            self.tags[tagsFile] = [ relativeSource ]

   def stripTags(self, tagsFile, sources):
      self.__diag("Stripping tags for %s from tags file %s", (",".join(sources), tagsFile))
      backup = ".SAFE"
      for l in fileinput.input(files=tagsFile, inplace=True, backup=backup):
         l = l.strip()
         if goodTag(l, sources):
            print l
      os.unlink(tagsFile + backup)

   def updateTagsFile(self, tagsFile, sources):
      tagsDir = os.path.dirname(tagsFile)
      self.stripTags(tagsFile, sources)
      if self.tags_file:
         cmd = "%s -f %s -a " % (self.ctags_cmd, self.tags_file)
      else:
         cmd = "%s -a " % (self.ctags_cmd,)
      for source in sources:
         if os.path.isfile(os.path.join(tagsDir, source)):
            cmd += " '%s'" % source
      self.__diag("%s: %s", (tagsDir, cmd))
      do_cmd(cmd, tagsDir)

   def rebuildTagFiles(self):
      for (tagsFile, sources) in self.tags.items():
         self.updateTagsFile(tagsFile, sources)

   def __diag(self, msg, args = None):
      diag(self.verbosity, AutoTag.__threshold, msg, args)
EEOOFF

function! AutoTag()
python << EEOOFF
try:
    if long(vim.eval("g:autotagDisabled")) == 0:
        at = AutoTag(vim.eval("g:autotagExcludeSuffixes"), vim.eval("g:autotagCtagsCmd"), long(vim.eval("g:autotagVerbosityLevel")), str(vim.eval("g:autotagTagsFile")))
        at.addSource(vim.eval("expand(\"%:p\")"))
        at.rebuildTagFiles()
except:
    diag(1, -1, format_exc())
EEOOFF
    if exists(":TlistUpdate")
        TlistUpdate
    endif
endfunction

if !exists("g:autotagDisabled")
   let g:autotagDisabled=0
endif
if !exists("g:autotagVerbosityLevel")
   let g:autotagVerbosityLevel=0
endif
if !exists("g:autotagExcludeSuffixes")
   let g:autotagExcludeSuffixes="tml.xml.text.txt"
endif
if !exists("g:autotagCtagsCmd")
   let g:autotagCtagsCmd="ctags"
endif
if !exists("g:autotagTagsFile")
   let g:autotagTagsFile="tags"
endif
augroup autotag
   au!
   autocmd BufWritePost,FileWritePost * call AutoTag ()
augroup END

endif " has("python")

" vim:shiftwidth=3:ts=3

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

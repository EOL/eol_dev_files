" vim: set foldmarker={,} foldlevel=0 foldmethod=marker ts=2 shiftwidth=2 spell:
"  configuration file from Encyclopedia of Life team
"	 based on .vimrc of Steve Francia.
"  To use it copy this file to
"    for Unix and OS/2:  ~/.vimrc
"    for MS-DOS and Win32:  $VIM\_vimrc
"  za - unfold a fold, zR unfold all 

" Setup Bundle Support {
" The next two lines ensure that the ~/.vim/bundle/ system works
	runtime! autoload/pathogen.vim
	silent! call pathogen#runtime_append_all_bundles()
" }

" Matchit Macro {
" Expands % character to move between not only matching () or {} but also def, if, while etc.
	runtime macros/matchit.vim
" }

" Tabs, Indentations {
	set ts=2            " makes tabulation to work as 2 spaces
	set shiftwidth=2	  " sets indentation 2 spaces
	set ai			        " always set autoindenting on
	set nocin "no indent c-style
	set expandtab       " tabs from spaces use CTRL_V_TAB to insert real tab
	set smartindent
	set smarttab
" }

" Word Completion {
	set complete=.,b,t,w
	" codes to add to the autocomplete sequence
	" .      Current file 
	" b      Files in loaded buffers, not in a window 
	" d      Definitions in the current file and in files included by a #include directive 
	" i      Files included by the current file through the use of a #include directive 
	" k      The file defined by the ‘dictionary’ option (discussed later in this chapter) 
	" kfile  The file named {file} 
	" t      The “tags” file. (The ] character can be used as well.) 
	" u      Unloaded buffers 
	" w      Files in other windows
	set wildmenu " in command mode allows to see other options of completion
	set wildmode=list:longest " in command mode bash-like completion to the unubigious part
" }

" General {
	set nocompatible	  " Use Vim defaults (much better!)

	set wrap
	set fileencodings=utf-8,default,latin1
  set encoding=utf-8
  set termencoding=utf-8
	set viminfo='20,\"50	" read/write a .viminfo file, don't store more
				" than 50 lines of registers
	set history=50		" keep 50 lines of command line history
	set bs=indent,eol,start	" allow backspacing over everything in insert mode
	set shortmess+=filmnrxoOtT     	" abbrev. of messages (avoids 'hit enter')
	filetype plugin indent on  	" Automatically detect file types.
	syntax on 					" syntax highlighting
	set mouse=a					" automatically enable mouse usage
	set vb "makes visual bell instead of sound
	
	" Setting up the directories {
		" set backup 						" backups are nice ...
		" set backupdir=$HOME/.vimbackup  " but not when they clog .
		set nobackup		"backups are nice but not if files are huge
		set directory=$HOME/.vimswap 	" Same for swap files
		set viewdir=$HOME/.vimviews 	" same but for view files
		
		" Creating directories if they don't exist
		" silent execute '!mkdir -p $HOME/.vimbackup'
		silent execute '!mkdir -p $HOME/.vimswap'
		silent execute '!mkdir -p $HOME/.vimviews'
		" au BufWinLeave * silent! mkview  "make vim save view (state) (folds, cursor, etc)
		" au BufWinEnter * silent! loadview "make vim load view (state) (folds, cursor, etc)
	" }
" }

" Status Bar {
	set ruler		" show the cursor position all the time
	"shows encoding of the file
	set statusline=%<%f%h%m%r%=%b\ %{&encoding}\ 0x%B\ \ %l,%c%V\ %P
	set laststatus=2
" }

" Search {
	set nohls "no highlits for search
	set incsearch "search incrementally
	set ignorecase smartcase " ignore case if only small case letters are in search pattern
" }

" Folding {
	set foldmethod=marker " define fold method as manual
	set foldlevel=0
	hi Folded guibg=black guifg=green
	hi FoldColumn guibg=black guifg=green
  " if has("autocmd")
  "  autocmd FileType ruby setlocal foldmethod=syntax
  "  autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2
  " endif
" }

" Mappings {
  " visual select of a line without trailing spaces
  map vv ^vg_ 
  map R :!ruby % <cr>
  map S :!spec % <cr>
" }

" Commands {
  " allows to save buffer with sudo
  command W w !sudo tee % >/dev/null
" }

" Rails {
  if has("autocmd")
    " autocmd FileType ruby setlocal foldmethod=syntax
    " autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2
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
  endif
" }

" Rotate encoding {
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
" }

" Augroups {
  if has("autocmd")

   " In text files, always limit the width of text to 78 characters
   " autocmd BufRead *.txt set tw=78


   augroup pyprog
     au!
     autocmd FileType * set ts=2 shiftwidth=2
     autocmd FileType py set ts=4 shiftwidth=4
   augroup END

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
" }

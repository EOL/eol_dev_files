" my filetype file
    if exists("did_load_filetypes")
        finish
    endif
    augroup filetypedetect
    au! BufRead,BufNewFile *.cfc setfiletype cf
    au! BufRead,BufNewFile *.haml setfiletype haml 
    au! BufRead,BufNewFile *.treetop setfiletype treetop
    augroup END

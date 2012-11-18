syntax on
filetype plugin on
filetype plugin indent on
set cindent
set expandtab
set tabstop=4
set shiftwidth=4
set number
set autoindent
set paste
set backspace=indent,eol,start
set textwidth=0
set ruler
set wildmenu
set commentstring=\ #\ %s
set foldlevel=0
set clipboard+=unnamed
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1,so-2022-jp,sjis

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

let g:pydiction_location ='/home/maplebeats/.vim/tools/pydiction/complete-dict'
let g:pydiction_menu_height = 20

let b:javascript_fold=1
let javascript_enable_domhtmlcss=1

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au BufRead,BufNewFile *.js set ft=javascript.jquery
au BufRead,BufNewFile *.js set syntax=jquery

autocmd FileType python set omnifunc=pythoncomplete#Complete  

"进行版权声明的设置
"添加或更新头
map <F4> :call TitleDet()<cr>'s
function AddTitle()
    call append(0,"/*============================================
    =================================")
    call append(1,"#")
    call append(2,"# Author: maplebeats")
    call append(3,"#")
    call append(4,"# gtalk/mail: maplebeats@gmail.com")
    call append(5,"#")
    call append(6,"# Last modified: ".strftime("%Y-%m-%d %H:%M"))
    call append(7,"#")
    call append(8,"# Filename: ".expand("%:t"))
    call append(9,"#")
    call append(10,"# Description: ")
    call append(11,"#")
    call append(12,"===========================================
    ==================================*/")
    echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endf
"更新最近修改时间和文件名
function UpdateTitle()
    normal m'
    execute '/# *Last modified:/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
    normal ''
    normal mk
    execute '/# *Filename:/s@:.*$@\=":\t\t".expand("%:t")@'
    execute "noh"
    normal 'k
    echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction
"判断前10行代码里面，是否有Last modified这个单词，
"如果没有的话，代表没有添加过作者信息，需要新添加；
"如果有的话，那么只需要更新即可
function TitleDet()
    let n=1
    "默认为添加
    while n < 10
        let line = getline(n)
        if line =~ '^\#\s*\S*Last\smodified:\S*.*$'
            call UpdateTitle()
            return
        endif
        let n = n + 1
    endwhile
    call AddTitle()
endfunction
set backup " Enable backup
set backupdir=~/.vim/backup " Set backup directory
set directory=~/.vim/swap,/tmp " Set swap file directory

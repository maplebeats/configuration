set number
set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1,so-2022-jp,sjis
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set wrap
set backup " Enable backup
set backupdir=~/.vim/backup " Set backup directory
set directory=~/.vim/swap,/tmp " Set swap file directory
set mouse=a " 鼠标可用
set pastetoggle=<F12> " 粘贴模式切换 

let g:pydiction_location ='/home/maplebeats/.vim/tools/pydiction/complete-dict'
let g:pydiction_menu_height = 20

"vundle
set nocompatible " be iMproved
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'The-NERD-tree'

syntax on
filetype on
filetype plugin on
filetype plugin indent on " vundle required

au FileType python set omnifunc=python3complete#Complete
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"au FileType html set omnifunc = htmlcomplete#CompleteTags
"au FileType css set omnifunc = csscomplete#CompleteCSS
au FileType txt set setlocal spell spelllang=en_us
au BufRead,BufNewFile *.js set ft=javascript.jquery
au BufRead,BufNewFile *.js set syntax=jquery

"search
set magic " Enable magic matching
set showmatch " Show matching bracets
set hlsearch " Highlight search things
set smartcase " Ignore case when searching
set ignorecase

" map
" <FN>
map <F5> :call ScriptsRun()<CR>
nnoremap <silent> <F9> :NERDTreeToggle<CR>
function! ScriptsRun()
    exec "w"
    if &filetype == 'sh'
        exec "!sh %"
    elseif &filetype == 'python'
        exec "!python3 %"
    elseif &filetype == 'html'
        exec "!xdg-open %"
    endif
endfunction

"tabs
nnoremap tp :tabprevious<CR>
nnoremap tn :tabnext<CR>
nnoremap to :tabnew<CR>
nnoremap tc :tabclose<CR>

nmap <silent> <C-k> <C-W><C-k>
nmap <silent> <C-j> <C-W><C-j>
nmap <silent> <C-h> <C-W><C-h>
nmap <silent> <C-l> <C-W><C-l>

"disable direction keys
map <UP> <NOP>
map <DOWN> <NOP>
map <LEFT> <NOP>
map <RIGHT> <NOP>
inoremap <UP> <NOP>
inoremap <DOWN> <NOP>
inoremap <LEFT> <NOP>
inoremap <RIGHt> <NOP>

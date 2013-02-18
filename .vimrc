set number

set encoding=utf-8
set fileencodings=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set wrap

set backup " Enable backup
set backupdir=~/.vim/backup " Set backup directory
set directory=/tmp,~/.vim/swap " Set swap file directory

set mouse=a " 鼠标可用
set selection=exclusive
set selectmode=mouse,key

set guioptions-=T "remove toolsbar
set guioptions-=m "remove menubar
set guioptions=acit

"set foldmethod=indent "flod
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set laststatus=2
set ruler
set iskeyword+=_,$,@,%,#,-  " 带有符号的单词不要被换行分割
set wildmenu

"vundle
set nocompatible " be iMproved
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'The-NERD-tree'
Bundle 'fcitx.vim'
Bundle 'DoxygenToolkit.vim'
Bundle 'The-NERD-Commenter'
Bundle 'SuperTab'
Bundle 'Pydiction'

"Doxygen setting
let g:DoxygenToolkit_authorName="maplebeats"
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
"Pydiction
let g:pydiction_location ='/home/maplebeats/.vim/tools/pydiction/complete-dict'
let g:pydiction_menu_height = 20

syntax on
filetype on
filetype plugin on
filetype plugin indent on " vundle required

au FileType python set omnifunc=python3complete#Complete
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"au FileType html set omnifunc = htmlcomplete#CompleteTags
"au FileType css set omnifunc = csscomplete#CompleteCSS
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
map <F10> :call SpellToggle()<CR>
map <F11> :call FoldToggle()<CR>
set pastetoggle=<F12> " 粘贴模式切换 Tips: the mode can affect fcitx


function! SpellToggle()
    if &spelllang == 'en_us'
        echo "spell off"
        setlocal spell spelllang=
    else
        echo "spell on"
        setlocal spell spelllang=en_us
    endif
endfunction

function! ScriptsRun()
    exec "w"
    if &filetype == 'sh'
        exec "!sh %"
    elseif &filetype == 'python'
        exec "!python %"
    elseif &filetype == 'html'
        exec "!xdg-open %"
    elseif &filetype == 'c'
        exec "w"
        exec "!gcc % -o %<"
        exec "!./%<"
    elseif &filetype == 'javascript.jquery'
        exec "!gjs %"
    endif
endfunction

function! FoldToggle()
    if &foldmethod == 'indent'
        set foldmethod=marker
    else
        set foldmethod=indent "flod
    endif
    echo &foldmethod
endfunction

"tabs
nnoremap tp :tabprevious<CR>
nnoremap tn :tabnext<CR>
nnoremap to :tabnew<CR>
nnoremap tc :tabclose<CR>
"Open a new tab page and edit the file name under the cursor
nnoremap gf <C-w>gf 
" Buffers/Tab操作快捷方式!
"
"nnoremap <s-h> :bprevious<cr>
"nnoremap <s-l> :bnext<cr>
"nnoremap <s-j> :tabnext<cr>
"nnoremap <s-k> :tabprev<cr>

nmap <silent> <C-k> <C-W><C-k>
nmap <silent> <C-j> <C-W><C-j>
nmap <silent> <C-h> <C-W><C-h>
nmap <silent> <C-l> <C-W><C-l>

" 插入模式下上下左右移动光标
inoremap <c-h> <left>
inoremap <c-l> <right>
inoremap <c-j> <c-o>gj
inoremap <c-k> <c-o>gk

"disable direction keys
map <UP> <NOP>
map <DOWN> <NOP>
map <LEFT> <NOP>
map <RIGHT> <NOP>
inoremap <UP> <NOP>
inoremap <DOWN> <NOP>
inoremap <LEFT> <NOP>
inoremap <RIGHt> <NOP>

"Set mapleader
let mapleader = ","

"Fast reloading of the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
"Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

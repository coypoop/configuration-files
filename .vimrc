set t_Co=256
let g:zenburn_high_Contrast=1
set nocompatible
set bs=2
set viminfo='100,<5000,s100,f1,/100,:100
set history=1000
set ruler
set hidden
set wrap

set wildmenu
set wildmode=list:longest

set ignorecase
set smartcase

set title

set scrolloff=3
set cursorline
"set rnu

set ai
set tabstop=2
set shiftwidth=2
set expandtab

set nohlsearch

set ttymouse=xterm2
set mouse=a

set guioptions=aieg
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10

syntax on
filetype plugin indent on

"set grepprg=grep\ -nH\ $*

vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/

set statusline=%<%f\ %{fugitive#statusline()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

noremap <silent> <Leader>vs :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>


"Copy/Paste shortcuts (C-v C-c) in paste mode
set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>
vnoremap <C-c> "+y

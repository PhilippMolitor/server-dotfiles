" basics
set title
set number
set relativenumber
set showmatch
set wrap
set cursorline
set ignorecase
set incsearch
syntax on

" colorscheme
colorscheme slate

" tabs
set softtabstop=2
set expandtab
set autoindent
set shiftwidth=2
set tabstop=2

" enable mouse interaction
set selectmode+=mouse
set mouse=a

" disable swapfiles
set noswapfile
set nobackup
set nowritebackup

" write with root privileges
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" restore cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


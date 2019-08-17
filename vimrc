set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
set relativenumber

Plugin 'mileszs/ack.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'niquola/vim-pg'
Plugin 'vim-scripts/paredit.vim'
Plugin 'nicwest/vim-http'
Plugin 'tpope/vim-fugitive'

call vundle#end()
filetype plugin indent on

call pathogen#infect()
syntax on
colorscheme bw
let mapleader=","
set number
set clipboard=unnamedplus
set path+=**
set wildmenu
set mouse=a
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*out/*

autocmd filetype cpp nnoremap <F4> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').''<CR>

autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>

nnoremap <C-j> :1,8d<CR>:%!python -m json.tool<CR>
nnoremap <C-h> :Http<CR>

let g:netrw_banner=0
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
let g:vim_http_split_vertically=1
let g:vim_http_tempbuffer=1
map <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1

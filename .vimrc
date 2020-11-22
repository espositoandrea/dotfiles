set modeline
set tabstop=4
set shiftwidth=4
set number relativenumber
set noexpandtab
set cc=80
set mouse-=a
set tw=79

" Remap movement between splits from <C-w>MOVEMENT to <C-MOVEMENT>
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" When reindenting, keep the selection
vnoremap < <gv
vnoremap > >gv

" Plugins
call plug#begin()
Plug 'vim-latex/vim-latex'
Plug 'junegunn/goyo.vim'
Plug 'vim-airline/vim-airline'
Plug 'ap/vim-css-color'
call plug#end()

" Status bar (vim-airline)
let g:airline_powerline_fonts = 1

" Fix for Goyo background
autocmd! User GoyoLeave nested set background=dark

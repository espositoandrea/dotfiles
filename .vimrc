set modeline
set tabstop=4
set shiftwidth=4
set number relativenumber
set noexpandtab
set mouse-=a
set tw=79
set fo-=t
set cc=80
highlight ColorColumn ctermbg=234

" When activating list, show tabs and other non-visible characters as defined
set lcs=tab:├─,eol:⏎,trail:·,nbsp:⎵
nnoremap <F3> :set list!<CR>

let &t_SI = "\<esc>[5 q"  " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"  " blinking underline in replace mode
let &t_EI = "\<esc>[1 q"  " default cursor (usually blinking block) otherwise

" Remap movement between splits from <C-w>MOVEMENT to <C-MOVEMENT>
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l

" When reindenting, keep the selection
vnoremap < <gv
vnoremap > >gv

" When

" Plugins
call plug#begin()
	" Plug 'vim-latex/vim-latex'
	Plug 'junegunn/goyo.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'ap/vim-css-color'
	Plug 'mattn/emmet-vim'
	Plug 'preservim/nerdcommenter'
	Plug 'joom/latex-unicoder.vim'
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

" Status bar (vim-airline)
let g:airline_powerline_fonts = 1

" Markdown Preview
let g:mkdp_browser = 'surf'

" NerdCommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1

let g:unicoder_cancel_normal = 1
let g:unicoder_cancel_insert = 1
let g:unicoder_cancel_visual = 1
nnoremap <C-q> :call unicoder#start(0)<CR>
inoremap <C-q> <Esc>:call unicoder#start(1)<CR>
vnoremap <C-q> :<C-u>call unicoder#selection()<CR>

" Fix for Goyo background
autocmd! User GoyoLeave nested set background=dark

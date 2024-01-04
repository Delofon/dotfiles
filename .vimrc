call plug#begin()

Plug 'christoomey/vim-tmux-navigator'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()

set background=dark

set nowrap

set ttimeout
set ttimeoutlen=100
set clipboard=unnamedplus

set showcmd

set number
set relativenumber
set tabstop=4 shiftwidth=4 expandtab
set autoindent
set viminfo='20,<1000
syntax on

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

map <space> <leader>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz
noremap <silent> <leader>pv :Ex!<cr>
nnoremap <silent> ZZ :w <bar> Ex!<cr>
nnoremap <silent> ZQ :earlier 1f <bar> Ex!<cr>

let g:netrw_banner = 0

function! NetrwConfig()
    set number
    set relativenumber

    nmap <buffer> l <cr>
    nmap <buffer> <silent> h u
endfunction

augroup netrw
    autocmd!
    autocmd filetype netrw call NetrwConfig()
augroup END



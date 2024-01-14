call plug#begin()

Plug 'christoomey/vim-tmux-navigator'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-sensible'

call plug#end()

set background=dark

set mouse=a
set showcmd

set number
set relativenumber
set nowrap
set tabstop=4 shiftwidth=4 expandtab
set autoindent
set viminfo='20,<1000
set clipboard=unnamedplus
syntax on

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

map <space> <leader>

nnoremap Q <nop>

nnoremap dw bdw
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz
noremap <silent> <leader>pv :Ex!<cr>
nnoremap <silent> ZZ :w <bar> Ex!<cr>
nnoremap <silent> ZQ :earlier 1f <bar> Ex!<cr>

noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

nnoremap <silent> <leader>cf :LspCodeAction<cr>

let g:netrw_banner = 0
let g:netrw_sizestyle = "h"

function! NetrwConfig()
    set number
    set relativenumber

    nmap <buffer> l <cr>
    nmap <buffer> <silent> h u
    nmap <buffer> ZZ :q<cr>
    nmap <buffer> ZQ :q<cr>
endfunction

augroup netrw
    autocmd!
    autocmd filetype netrw call NetrwConfig()
augroup END


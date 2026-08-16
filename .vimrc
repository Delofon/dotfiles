call plug#begin()

Plug 'christoomey/vim-tmux-navigator'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-sensible'
Plug 'ludovicchabant/vim-gutentags'

call plug#end()

set background=dark

set mouse=a
set showcmd

set number
set relativenumber
set nowrap
set list
set tabstop=4 shiftwidth=4 expandtab
set autoindent
set viminfo='20,<1000
set clipboard=unnamedplus " less thinking when copying to/from X

syntax on
let c_gnu=1

function! Untabify()
    let pos = getpos('.')

    %s/\t/    /ge
    norm! ggVG=

    call setpos('.', pos)
    norm! zz
endfunction
function! Tabify()
    let pos = getpos('.')

    %s/    /\t/ge
    norm! ggVG=

    call setpos('.', pos)
    norm! zz
endfunction

" narrow cursor for insert, block cursor for normal or visual
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

map <space> <leader>

nnoremap Q <nop>

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzz
nnoremap N Nzz
noremap <silent> <leader>pv :Ex!<cr>
"nnoremap <silent> ZZ :w <bar> Ex!<cr>
"nnoremap <silent> ZQ :e! <bar> Ex!<cr>
nnoremap <silent> <leader>wq :w  <bar> Ex!<cr>
nnoremap <silent> <leader>q  :e! <bar> Ex!<cr>
nnoremap cw ciw
nnoremap dw daw
nnoremap cW ciW
nnoremap dW daW
nnoremap <leader>tt :call Untabify()<cr>
nnoremap <leader>ut :call Tabify()<cr>

noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

let g:netrw_banner = 0
let g:netrw_sizestyle = "h"
let g:netrw_keepdir = 0

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


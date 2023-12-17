set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'ryanoasis/vim-devicons'

call vundle#end()
filetype plugin indent on

set timeoutlen=200
set clipboard=unnamedplus

set number
set relativenumber
set tabstop=4 shiftwidth=4 expandtab
set autoindent
set viminfo='20,<1000
syntax on

let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"


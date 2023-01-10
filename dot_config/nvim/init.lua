-- [[ ~/.config/nvim/init.lua ]]

--2 try

-- vimscript make map easier
vim.cmd([[
mapclear!

" map leader to space
let mapleader = " "
"2 try
noremap gp yypkgccj

" brew tap daipeihust/tap && brew install im-select
inoremap <C-c> <C-c>:!im-select com.apple.keylayout.ABC<CR><CR>
nnoremap <leader>vf va{Vo
" special copy and paste
vnoremap <leader>y "*y
nnoremap <leader>y "*y

noremap <leader>w :w<CR>
" quick .rc
noremap cv :silent! luafile %<CR>:silent! source %<CR>

" move with center
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
noremap n nzzzv
noremap N Nzzzv
noremap { {zz
noremap } }zz
noremap <C-j> }zz
noremap <C-k> {zz

" highlight when yank
au TextYankPost * silent! lua vim.highlight.on_yank()

" plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
call plug#begin()
Plug 'mhinz/vim-startify'
Plug 'jghauser/mkdir.nvim'

Plug 'wakatime/vim-wakatime', Cond(!exists('g:vscode'))
Plug 'github/copilot.vim', Cond(!exists('g:vscode'))

Plug 'echasnovski/mini.nvim'

Plug  'kana/vim-textobj-user' 
Plug 'kana/vim-textobj-entire'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible' 
Plug 'tpope/vim-commentary'
call plug#end()

" set up variables
let g:t_co = 256
let g:background = "dark"

" set up options
set number
set relativenumber
set scrolloff=7
set signcolumn=number

syntax on
set termguicolors

set ignorecase
set smartcase
set nohlsearch

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set splitright
set splitbelow
]])
require('mini.completion').setup() -- auto show completion
require('mini.cursorword').setup() -- highlight current word
require('mini.pairs').setup() -- ()[]{}""''

set nocompatible              " be iMproved, required
let mapleader=" "
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
"Plugin 'leafgarland/typescript-vim'
"Plugin 'Quramy/tsuquyomi'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/vimproc.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-eunuch'
Plugin 'vim-scripts/genutils'
Plugin 'vim-scripts/PushPop.vim'
Plugin 'mileszs/ack.vim'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" jk will switch between modes
:imap jk <Esc>

" Set indentation
:set tabstop=2
:set expandtab
:set shiftwidth=2
:set autoindent
:set smartindent
:set cindent

" :W will write with sudo permissions
command W sil exec 'w !sudo tee ' . shellescape(@%, 1) . ' >/dev/null'

" syntax highlight
syntax on
colorscheme seattle

" fix press enter or command to continue
let g:bufferline_echo=0

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction

" indentation
set backspace=2
set tabstop=4 softtabstop=0 expandtab shiftwidth=2 smarttab

" enable filetype detection:
filetype on
filetype plugin on
filetype indent on " file type based indentation

" for C-like  programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c,cpp,java set formatoptions+=ro
autocmd FileType c set omnifunc=ccomplete#Complete

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" " needed, and have indentation at 8 chars to be sure that all indents are
" tabs
" " (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

set number
set ignorecase

set statusline=%t       "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set statusline+=%{ObsessionStatus()}
set laststatus=2

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
:endfunction

set list listchars=trail:.,extends:>
autocmd FileWritePre * call TrimWhiteSpace()
autocmd FileAppendPre * call TrimWhiteSpace()
autocmd FilterWritePre * call TrimWhiteSpace()
autocmd BufWritePre * call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>

" for jsx format with .js files
let g:jsx_ext_required = 0

" ctrl-p.vim will now respect .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']

function! MkdirIfNone (dir)
  if empty(glob(a:dir))
    if exists('*mkdir')
      call mkdir(a:dir, 'p')
      echo 'created directory ' . a:dir
    endif
  endif
endfunction

" set ctrlp to use cwd
let g:ctrlp_working_path_mode = 'rwa'

autocmd InsertLeave * :set nonumber relativenumber
autocmd InsertEnter * :set number norelativenumber

" set up ack.vim
" need to install ack and ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
set cursorline
set colorcolumn=80

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

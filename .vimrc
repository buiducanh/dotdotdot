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

" line number
set number

" syntax highlight
syntax on

" fix press enter or command to continue
let g:bufferline_echo=0

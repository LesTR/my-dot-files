set nocompatible
set exrc
set number
set history=1000
set backspace=indent,start,eol
set nojoinspaces
set ruler
set showcmd
set showmatch
set hlsearch
set smartindent
set shiftwidth=3
set smarttab
set noexpandtab
set tabstop=2
"set mouse=a
set wildmenu
set hls
set nowritebackup
set termencoding=utf-8
"set termencoding=latin2
"set background=light
set background=dark
set listchars=tab:>.,eol:.,nbsp:_
set incsearch

set showbreak=~~


" pathogen bundles
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()


" minibuffer Explorer settings:new
let g:miniBufExplMapCTabSwitchBufs = 1


"let g:miniBufExplVSplit = 20   " column width in chars
let g:miniBufExplMapWindowNavVim = 1
syntax on

" Tabs
map <S-j> :tabprev<CR>
map <S-K> :tabnext<CR>
map <S-T> :tabnew<CR>

" kopirovani a ukladani do glob bufferu
vmap <C-y> "+y
" vlozeni z globalni schranky
"map <C-v> "+gP
" ukladani souboru na bezne <Ctrl>-<s>
"map <C-s> :w<CR>
"imap <C-s> <Esc>:w<CR>i

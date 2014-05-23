" AUTOINSTALL VUNDLE
" Setting up Vundle - the vim plugin bundler
    let iCanHazVundle=1
    let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.vim/bundle
        silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
        let iCanHazVundle=0
    endif
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    Bundle 'gmarik/vundle'
    "Add your bundles here
    Plugin 'tpope/vim-fugitive'
"    Plugin 'Lokaltog/powerline'
    Plugin 'scrooloose/nerdtree'
    Plugin 'vim-scripts/twilight256.vim'
    Plugin 'gitvimdiff'
	 Plugin 'vim-coffee-script'
	 Plugin 'vim-javascript'
	 Plugin 'bling/vim-airline'

    "...All your other bundles...
    if iCanHazVundle == 0
        echo "Installing Bundles, please ignore key map error messages"
        echo ""
        :BundleInstall
    endif
" Setting up Vundle - the vim plugin bundler end
""""""""""""


set t_Co=256

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
"set smarttab
set noexpandtab
set tabstop=3
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

set smartcase
set ignorecase


" air-line configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
"colors twilight256


"set statusline=[%n]\ %<%F\ \ \ \ \ \ \ \ \ \ \ [%M%R%H%W%Y]\ [%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

" pathogen bundles
"filetype off
"call pathogen#helptags()
"call pathogen#runtime_append_all_bundles()


" minibuffer Explorer settings:new
let g:miniBufExplMapCTabSwitchBufs = 1


"let g:miniBufExplVSplit = 20   " column width in chars
"let g:miniBufExplMapWindowNavVim = 1
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

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
	"Plugin 'Lokaltog/powerline'
	Plugin 'bling/vim-airline'
	Plugin 'airblade/vim-gitgutter'
	Plugin 'tpope/vim-fugitive'
	Plugin 'scrooloose/nerdtree'
	Plugin 'vim-scripts/twilight256.vim'
"	Plugin 'wincent/Command-T'
"	Plugin 'terryma/vim-multiple-cursors'
	Bundle 'derekwyatt/vim-scala'
	Bundle 'kchmck/vim-coffee-script'
	Bundle 'geoffharcourt/vim-matchit'
	Bundle 'msanders/snipmate.vim'
	Bundle 'chase/vim-ansible-yaml'
	Bundle 'vim-scripts/RltvNmbr.vim'
	Bundle 'Glench/Vim-Jinja2-Syntax'
	Bundle 'ctrlpvim/ctrlp.vim'

	"...All your other bundles...
	if iCanHazVundle == 0
		echo "Installing Bundles, please ignore key map error messages"
		echo ""
		:BundleInstall
	endif
" Setting up Vundle - the vim plugin bundler end
""""""""""""

let mapleader=","

set t_Co=256
"set smartcase
"set nowrapscan
set nocompatible
set number
set numberwidth=5
set history=1000
set backspace=indent,start,eol
set nojoinspaces
set showcmd
set showmatch
set hlsearch
set smartindent
set shiftwidth=4
"set smarttab
set noexpandtab
set tabstop=4
"set mouse=a
set wildmenu
set hls
set nowritebackup
set termencoding=utf-8
set laststatus=2
set background=dark
set lazyredraw " redraw only when we need to.
"font for macvim
set guifont=Monaco\ for\ Powerline:h12

set listchars=tab:▸—,eol:.,nbsp:_
set incsearch
nnoremap <leader><space> :nohlsearch<CR>

set tabpagemax=30

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

let g:CommandTMaxHeight=20


set showbreak=~~

set statusline=[%n]\ %<%F\ \ \ \ \ \ \ \ \ \ \ [%M%R%H%W%Y]\ [%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

let g:gitgutter_enabled = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1


set runtimepath^=~/.vim/bundle/ctrlp.vim


filetype off


" minibuffer Explorer settings:new
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplVSplit = 20   " column width in chars
let g:miniBufExplMapWindowNavVim = 1
syntax on

inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
			\ "\<lt>C-n>" :
			\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
			\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
			\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>


fun! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun


" Only do this part when compiled with support for autocommands.
if has("autocmd")
  autocmd FileType c,cpp,java,php,ruby,python,js,coffee autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
  autocmd BufEnter * :syntax sync fromstart

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=120

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  "augroup END 
else

  set autoindent		" always set autoindenting on
endif " has("autocmd")

" func ListToggle {{{
function! ListToggle()
    if &list
        set nolist
    else
        set list
    endif
endfunction
" }}}

" func NumberToggle {{{
function! NumberToggle()
    if &number
        set nonu
    else
        set nu
    endif
endfunction
" }}}

" func PasteToggle {{{
function! PasteToggle()
    if &paste
        set nopaste
    else
        set paste
    endif
endfunction
" }}}

map <S-B> :cal ListToggle()<cr>
map <S-N> :cal NumberToggle()<cr>
map <S-P> :cal PasteToggle()<cr>
map <S-G> :GitGutterToggle<cr>

" Tabs movement
map <S-h> :tabprev<CR>
map <S-j> :tabfirst<CR>
map <S-k> :tablast<CR>
map <S-l> :tabnext<CR>
map <S-T> :tabnew<CR>


colors twilight256

" Show cursor line
set cursorline

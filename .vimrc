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

	"...All your other bundles...
	if iCanHazVundle == 0
		echo "Installing Bundles, please ignore key map error messages"
		echo ""
		:BundleInstall
	endif
" Setting up Vundle - the vim plugin bundler end
""""""""""""

""" to finish install of command-t
"make
":e command-t.vba
":so %
"cd ~/.vim/ruby/command-t
"ruby extconf.rb
"make



set t_Co=256
"set smartcase
"set nowrapscan
"set list
set nocompatible
"set exrc
set number
set numberwidth=5
set history=1000
set backspace=indent,start,eol
set nojoinspaces
"set ruler
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
"set termencoding=latin2
"set background=light
set background=dark
"font for macvim
set guifont=Monaco\ for\ Powerline:h12

set listchars=tab:▸—,eol:.,nbsp:_
set incsearch
"set scrolloff=1000              " center cursor vertically
"colors peachpuff
set tabpagemax=30
"set backup
"set backupdir=~/.vimbackups/

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

"set wildignore+=**/node_modules/*
"let g:ctrlp_custom_ignore = 'node_modules'
let g:CommandTMaxHeight=20

"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
"let g:Powerline_symbols = 'fancy'


set showbreak=~~

set statusline=[%n]\ %<%F\ \ \ \ \ \ \ \ \ \ \ [%M%R%H%W%Y]\ [%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}

let g:gitgutter_enabled = 0

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1


set runtimepath^=~/.vim/bundle/ctrlp.vim


" pathogen bundles
filetype off
"call pathogen#helptags()
"call pathogen#runtime_append_all_bundles()


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



"map <C-S-tab> :tabprev<cr>
"nmap <C-S-tab> :tabprev<cr>
"imap <C-S-tab> <ESC>:tabprev<cr>a

"map <S-tab> :tabnext<cr>
"nmap <S-tab> :tabnext<cr>
"imap <S-tab> <ESC>:tabnext<cr>a

"map <C-t> :tabnew 
"nmap <C-t> :tabnew 
"imap <C-t> <ESC>:tabnew 

"map <C-p> :CommandT<cr>
"nmap <C-p> :CommandT<cr>
"imap <C-p> <ESC>:CommandT<cr>a

"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>


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


"function! EnhanceCppSyntax()
"  syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
"  hi def link cppFuncDef Special
"endfunction

"autocmd Syntax cpp call EnhanceCppSyntax()

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
	GitGutterDisable
    else
        set nu
	GitGutterEnable
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

map <S-L> :cal ListToggle()<cr>
map <S-N> :cal NumberToggle()<cr>
map <S-P> :cal PasteToggle()<cr>


colors twilight256

"hi SpecialKey ctermfg=234
"hi Pmenu ctermbg=235 ctermfg=white

"hi LineNr       ctermbg=black          ctermfg=245
"hi Visual       ctermbg=235            ctermfg=246            cterm=bold
"hi Search       ctermbg=white          ctermfg=black
"hi StatusLine   ctermbg=white          ctermfg=black
"hi SignColumn   ctermbg=black






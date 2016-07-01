execute pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


" Leader
let mapleader = " "

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

let g:rspec_command = "!clear;bundle exec bin/rspec {spec}"
let g:rspec_runner = "os_x_iterm"
map <Leader>t :w<CR>:call RunCurrentSpecFile()<CR>
"map <Leader>t :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Save files on focus lost and allow hidden buffers
au FocusLost * :wa
set autowriteall
set autoread
set hidden

" Don't create backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Set hidden characters for list mode
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set list

" Don't wrap lines
set nowrap

" Show additional lines when on the last line
set scrolloff=3
set sidescrolloff=5
set display+=lastline
set showcmd
set laststatus=2

:iabbr teh the

"if filereadable(expand("~/.vimrc.bundles"))
"  source ~/.vimrc.bundles
"endif

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Use 2 spaces for all indentation
set tabstop=2
set shiftwidth=2
set expandtab
set number

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Always use vertical diffs
set diffopt+=vertical

set history=1000
set undolevels=1000

" Searching
set ignorecase
set smartcase
set incsearch
set gdefault
set hlsearch
nmap <silent> <leader><leader> :nohlsearch<CR>
nnoremap <tab> %
vnoremap <tab> %

" Key mappings

" Prevent recording when trying to quit
map q <nop>
inoremap jk <Esc>:w<CR>
nnoremap ; :

" Strip trailing whitespace
" nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<CR>

" Run rubocop on current file
nnoremap <leader>r :!rubocop -a %<CR>

" Ggrep whole project for the word under cursor
nnoremap <leader>g :Ggrep '<cword>'<CR>

" Ggrep
nnoremap <leader>g :Ggrep -i<space>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap gr gT
" Don't skip over wrapped lines when moving
nnoremap j gj
nnoremap k gk

nnoremap <Left> :vertical resize +5<CR>
nnoremap <Right> :vertical resize -5<CR>
nnoremap <Up> :resize +5<CR>
nnoremap <Down> :resize -5<CR>

nnoremap <leader>wq :wq<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>q :q<CR>

nnoremap <leader>1 :!<space>

" remap control space to control p
inoremap <C-@> <C-p>

set wildignore=*/log/*,*/tmp/*
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files=0
let g:ctrlp_max_height = 18
nnoremap <Leader>ff :CtrlP<CR>

" ctrl-p use git indexing
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']

" Fugitive shortcuts
nnoremap <leader>G :Git<space>
nnoremap <leader>gst :Gstatus<CR>
nnoremap <leader>gp :Gpull<CR>
nnoremap <leader>gpush :Gpush<space>
nnoremap <leader>gls :!git ls<CR>
nnoremap <leader>gl :!git ls<CR>

nnoremap <leader>so :so ~/.vimrc<CR>
" Color scheme
syntax enable
set background=dark
colorscheme solarized

set colorcolumn=110

" Powerline fonts for status bar icons
" let g:airline_powerline_fonts = 1
let g:airline_left_sep=''                           " No separator as they seem to look funky
let g:airline_right_sep=''                          " No separator as they seem to look funky
" let g:airline#extensions#branch#enabled = 0         " Do not show the git branch in the status line
let g:airline#extensions#syntastic#enabled = 1      " Do show syntastic warnings in the status line
"let g:airline#extensions#tabline#show_buffers = 0   " Do not list buffers in the status line
let g:airline_section_x = ''                        " Do not list the filetype or virtualenv in the status line
let g:airline_section_y = ''                        " Replace file encoding and file format info with file position
let g:airline_section_z = ''                        " Do not show the default file position info
let g:airline#extensions#virtualenv#enabled = 0


nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

function! VisualFindAndReplace()
  :OverCommandLine%s/
  :w
endfunction
function! VisualFindAndReplaceWithSelection() range
  :'<,'>OverCommandLine s/
  :w
endfunction

nnoremap <Leader>fr :call VisualFindAndReplace()<CR>
xnoremap <Leader>fr :call VisualFindAndReplaceWithSelection()<CR>

function! QuickfixToggle()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open = 0
    execute g:quickfix_return_to_window . "wincmd w"
  else
    let g:quickfix_return_to_window = winnr()
    copen
    let g:quickfix_is_open = 1
  endif
endfunction

"nnoremap <C-m> <C-w>\| <C-w>_
"nnoremap <C-n> <C-w>=
nnoremap <C-w>t :tabe<CR>

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif


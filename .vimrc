" dein
" ################################################################
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
" ################################################################

" display settings
syntax on
colorscheme molokai
let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ }
set laststatus=2
set background=dark
set number
set ruler
set cursorline
set showmatch
set colorcolumn=80
" set term=screen-256color

" move cursor settings
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescroll=16
set sidescroll=1

" files process settings
set hidden
set confirm
set autoread
set nobackup
set noswapfile

" search/replace settings
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
set gdefault

" tab/indent settings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set cindent
set autoindent
if has("autocmd")
  " enable filetype
  filetype plugin on
  " use indent matching file type
  filetype indent on
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType rust        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType markdown    setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haskell     setlocal sw=2 sts=2 ts=2 et
endif

" os/env settings
set clipboard=unnamed,unnamedplus
set shellslash
set wildmenu

" command-mode settings
set wildmenu wildmode=list:longest,full
set history=10000

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
nnoremap ; :

" ==============================================================================
" .vimrc - Vim 設定
" ==============================================================================

" ------------------------------------------------------------------------------
" プラグイン管理 (dein.vim)
" ------------------------------------------------------------------------------
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

" ------------------------------------------------------------------------------
" コード補完・プラグイン設定 (neocomplete / emmet)
" ------------------------------------------------------------------------------
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#auto_completion_start_length = 1
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

" emmet-vim のプレフィックスキー
let g:user_emmet_leader_key = '<C-e>'

" ------------------------------------------------------------------------------
" 表示・UI設定
" ------------------------------------------------------------------------------
syntax on
set laststatus=2
set background=dark
set number
set ruler
set cursorline
set showmatch
set colorcolumn=80

" ------------------------------------------------------------------------------
" カーソル移動・スクロール
" ------------------------------------------------------------------------------
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set scrolloff=8
set sidescroll=1

" ------------------------------------------------------------------------------
" ファイル処理・バックアップ
" ------------------------------------------------------------------------------
set hidden
set confirm
set autoread
set nobackup
set noswapfile

" ------------------------------------------------------------------------------
" 検索・置換
" ------------------------------------------------------------------------------
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
set gdefault

" ------------------------------------------------------------------------------
" インデント・ファイルタイプ別設定
" ------------------------------------------------------------------------------
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smartindent
set cindent
set autoindent

if has("autocmd")
  filetype plugin indent on
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType rust       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType markdown   setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haskell    setlocal sw=2 sts=2 ts=2 et
endif

" ------------------------------------------------------------------------------
" OS連携・コマンドライン補完・キーマップ
" ------------------------------------------------------------------------------
set clipboard=unnamed,unnamedplus
set shellslash
set wildmenu wildmode=list:longest,full
set history=10000

" 括弧の自動補完と改行展開
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" ';' でコマンドラインモードに入る
nnoremap ; :

" Some plugins require this to be set before they are loaded.
set nocompatible

""" Plugins
call plug#begin('~/.vim/bundles')

" From joar
Plug 'vim-scripts/Unicode-RST-Tables'
Plug 'elzr/vim-json'
Plug 'motemen/git-vim'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'dag/vim-fish'
Plug 'joar/vim-colors-solarized'

" From lydell
Plug 'AndrewRadev/inline_edit.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'ap/vim-css-color'
Plug 'ap/vim-you-keep-using-that-word'
Plug 'bkad/CamelCaseMotion'
Plug 'groenewege/vim-less'
Plug 'jamessan/vim-gnupg'
Plug 'marijnh/tern_for_vim', { 'do': 'npm install' }
Plug 'mileszs/ack.vim'
Plug 'myint/indent-finder'
Plug 'othree/yajs.vim'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/seoul256.vim'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-lengthmatters'

Plug 'kchmck/vim-coffee-script'

call plug#end()


""" Settings
" UI
if has('gui_running') " in gvim
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set cursorline
    set relativenumber
    " let g:seoul256_background = 234
    set guifont=Inconsolata\ 11

    colorscheme solarized
    set background=light
else " in terminal
    colorscheme seoul256
    let g:seoul256_background = 234
    set t_Co=16
    set background=dark
endif


" IO
set autoread
set directory-=.
set undofile
set undodir=~/.tmp

" Search
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Indent
set expandtab
set shiftwidth=4
set tabstop=4
set autoindent
filetype indent off

" Misc
set backspace=indent,eol,start
set completeopt+=longest
set display=lastline
set formatoptions-=t
set formatoptions+=j
set list
set listchars=tab:▸\ ,extends:>,precedes:<,nbsp:·
set nojoinspaces
set nostartofline
set nrformats-=octal
set showcmd
set splitbelow
set splitright
set textwidth=80
set wildmenu
set wildmode=list:longest,full

" Mappings
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" <leader>
map <space> <leader>
nnoremap , :
nnoremap <leader>W :wq<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>! :qa!<cr>
nnoremap <leader>d :bd<cr>
nnoremap <leader>L :source ~/.vimrc<cr>
nnoremap <leader>b :buffers<CR>:buffer<Space>

cnoreabbrev W w
cnoreabbrev Wq wq

""" Helper functions
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

""" fzf
map <leader>n :FZF<cr>
map <leader>? :FZF<space>
map <silent> <leader>l :execute 'FZF'
    \ ChompedSystem('repo-root --cwd=' . shellescape(expand('%')))<cr>

function! FZF()
  return printf('xterm -T fzf'
    \ .' -bg "\%s" -fg "\%s"'
    \ .' -fa "%s" -fs %d'
    \ .' -geometry %dx%d+%d+%d -e bash -ic %%s',
    \ synIDattr(hlID("Normal"), "bg"), synIDattr(hlID("Normal"), "fg"),
    \ 'Monospace', getfontname()[-2:],
    \ &columns, &lines/2, getwinposx(), getwinposy())
endfunction
let g:Fzf_launcher = function('FZF')

""" Status line
set laststatus=2
set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
set statusline+=%{CapsLockStatusline()}
set statusline+=%{&fileformat=='unix'?'':'['.&fileformat.']'}
set statusline+=%{strlen(&fileencoding)==0\|\|&fileencoding=='utf-8'?'':'['.&fileencoding.']'}
set statusline+=%r "[RO]
set statusline+=%y "[javascript]
set statusline+=[%{&expandtab?'spaces:'.&shiftwidth:'tabs:'.&tabstop}]
set statusline+=%4p%% "50%


""" Autocommands
augroup vimrc
autocmd!
autocmd BufNewFile,BufFilePre,BufRead *.md setlocal filetype=markdown
autocmd FileType javascript setlocal omnifunc=tern#Complete
augroup END

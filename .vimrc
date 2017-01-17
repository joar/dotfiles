" Some plugins require this to be set before they are loaded.
set nocompatible

" Hack to work around YCM build issue on one of my computers.
let python = has('patch-7.4.53') ? 'python3' : 'python2'

""" Plugins
call plug#begin('~/.vim/bundles')

" From joar
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/Unicode-RST-Tables'
Plug 'elzr/vim-json'
Plug 'motemen/git-vim'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'dag/vim-fish'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'joar/vim-colors-solarized'
" Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope'

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
Plug 'othree/yajs.vim'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sleuth'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/seoul256.vim'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/YouCompleteMe', { 'do': python . ' ./install.py' }
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-lengthmatters'

Plug 'kchmck/vim-coffee-script'

call plug#end()

" Enable modeline
set modeline


""" Settings
" UI
set relativenumber
set background=dark

" Colorscheme
let g:terminal_italic = 0
set termguicolors
colorscheme solarized


if has('nvim') " in nvim
elseif has('gui_running') " in gvim
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    set cursorline

    set guifont=Inconsolata\ 11
else " in terminal
endif


" IO
set autoread
set directory-=.

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand('~/.vimundo')
    " Create undo_dir if it doesn't exist
    call system('mkdir ' . undo_dir)
    " Save undo history in undo_dir
    execute "set undodir=".undo_dir
    set undofile
endif

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
set indentkeys=

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

" Ctrl-{a,c,v} stand-in
" Copy register " to * and +
nnoremap <a-y> :let @*=@"\|let @+=@"<cr>
" Map visual mode <a-y> to a yank and then <a-y> in normal mode
vmap <a-y> y<a-y>
" Map insert mode <a-r> to a paste from system clipboard
inoremap <a-r> <c-o>:set paste<cr><c-r>+<c-o>:set nopaste<cr>

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


""" YCM
let g:ycm_path_to_python_interpreter = '/usr/bin/' . python
let g:ycm_filetype_blacklist = {}
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_key_list_select_completion = ['<tab>']
let g:ycm_key_list_previous_completion = ['<s-tab>']
let g:ycm_key_invoke_completion = '<c-tab>'
let g:ycm_key_detailed_diagnostics = ''
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_semantic_triggers = {
  \   'elm' : ['.'],
  \ }
    nnoremap <silent> <leader>g :YcmCompleter GoTo<cr>


""" Status line
set laststatus=2
set statusline=
set statusline+=%-4(%m%) "[+]
set statusline+=%f:%l:%c "dir/file.js:12:5
set statusline+=%=%<
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

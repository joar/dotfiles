" Some plugins require this to be set before they are loaded.
set nocompatible

let python = '/usr/bin/python3'

""" Plugins
call plug#begin('~/.vim/bundles')

" From joar
Plug 'rust-lang/rust.vim' " rust syntax
Plug 'vim-scripts/Unicode-RST-Tables' " proper reST tables
Plug 'elzr/vim-json' " JSON syntax
Plug 'motemen/git-vim'  " ?
Plug 'evanmiller/nginx-vim-syntax'  " nginx syntax
Plug 'dag/vim-fish'  " fish syntax
Plug 'Glench/Vim-Jinja2-Syntax'  " jinja2 syntax
" Fork of frankier/neovim-colors-solarized-only with clearly colored comments
Plug 'joar/vim-colors-solarized'
Plug 'justinmk/vim-sneak' " jumps to any location specified by two characters
Plug 'unblevable/quick-scope' " highlights targets for `f`, `F` and family
Plug 'hynek/vim-python-pep8-indent'
Plug 'brooth/far.vim' " Find and replace in multiple files
Plug 'cespare/vim-toml' " cargo TOML files
" Plug 'tpope/fugitive' " git
Plug 'kien/ctrlp.vim' " buffer/file/tag finder
Plug 'vito-c/jq.vim' " jq syntax
Plug 'danro/rename.vim'  " rename file
" Plug 'stephpy/vim-yaml'  " better YAML syntax^W^W^W worse YAML syntax
" Replaced by vim-signify
" Plug 'airblade/vim-gitgutter' " git gutter, shows changed lines in a 'gutter'
Plug 'mhinz/vim-signify'  " show git changes
Plug 'fatih/vim-go' " go development plugin

" From lydell
Plug 'AndrewRadev/inline_edit.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/undoquit.vim'
Plug 'ap/vim-css-color'
Plug 'ap/vim-you-keep-using-that-word'
Plug 'bkad/CamelCaseMotion'
Plug 'groenewege/vim-less' " LESS syntax
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
Plug 'junegunn/vim-easy-align'  " Indentation, alignment
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr' " find and replace
Plug 'ntpeters/vim-better-whitespace'
Plug 'tommcdo/vim-exchange'
Plug 'Valloric/YouCompleteMe', { 'do': python . ' ./install.py' }
Plug 'wellle/targets.vim'
Plug 'whatyouhide/vim-lengthmatters'  " highlights text that overflows textwidth

Plug 'kchmck/vim-coffee-script'

call plug#end()

" Appearance & Interface
" ------------------------------------------------------------------------------

set relativenumber
set colorcolumn=80   " mark the 80th column

" title
" ------------------------------------------------------------------------------

set titlestring=vim\ %{expand(\"%:~:.\")}\ \ -\ %{fnamemodify(getcwd(),\ \":~:.\")}
set title  " update terminal title to matc current file

" Cursor shape in terminal
" ------------------------------------------------------------------------------

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif

" insert mode - line
let &t_SI .= "\<Esc>[5 q"
" replace mode - underline
let &t_SR .= "\<Esc>[4 q"
" common - block
let &t_EI .= "\<Esc>[3 q"

" Colorscheme
" ------------------------------------------------------------------------------

set background=dark

let g:solarized_italic = 0  " disable italic text
set termguicolors  " enable true color
colorscheme solarized


" Quickscope
" ------------------------------------------------------------------------------
" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" let g:qs_first_occurrence_highlight_color = '#afff5f'
" XXX: None of these seem to work
let g:qs_first_occurrence_highlight_color = 155       " terminal vim

" Mouse in terminal
" ------------------------------------------------------------------------------
set mouse=a

" neovim's python
" ------------------------------------------------------------------------------

if has('nvim')
  "let g:python_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif

" vim GTK
" ------------------------------------------------------------------------------

if has('gui_running')
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=L
  set cursorline

  set background=light

  set guifont=Inconsolata\ 11
endif

" easy-align
" ------------------------------------------------------------------------------

xmap ga <Plug>(EasyAlign)

" Signify
" ------------------------------------------------------------------------------

let g:signify_realtime = 1
let g:signify_sign_show_count = 0

" Enable modeline
set modeline

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

" CtrlP
let g:ctrlp_working_path_mode = '0'

" Mappings
" ------------------------------------------------------------------------------

" Set sqlcomplete omni key to something else than the default '<C-C>'
let g:ftplugin_sql_omni_key = '<C-Ä>'

" unmap default C-g
imap <C-c> <Esc>

nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" HorizontalRuler
" ------------------------------------------------------------------------------

inoremap <silent> <c-s-l> a<bs><c-o>:call HorizontalRuler()<cr>

function! HorizontalRuler()
  let char = nr2char(getchar())
  let width = &textwidth - (col('.') - 1)

  execute 'normal! ' . width . 'a' . char
  " start insert at end of line
  execute 'startinsert!'
endfunction

" <leader> Mappings
" ------------------------------------------------------------------------------
map <space> <leader>

nnoremap <leader>c :center<cr>
nnoremap <leader>W :wq<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>! :qa!<cr>
nnoremap <leader>d :bd<cr>
nnoremap <leader>L :source ~/.vimrc<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>p :CtrlPMixed<cr>

" Command mode
" ------------------------------------------------------------------------------

" common typos
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
let g:ycm_path_to_python_interpreter = python
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

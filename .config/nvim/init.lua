local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local cmd = vim.cmd
local create_cmd = vim.api.nvim_create_user_command
create_cmd('PackerInstall', function()
  cmd [[packadd packer.nvim]]
  require('plugins').install()
end, {})
create_cmd('PackerUpdate', function()
  cmd [[packadd packer.nvim]]
  require('plugins').update()
end, {})
create_cmd('PackerSync', function()
  cmd [[packadd packer.nvim]]
  require('plugins').sync()
end, {})
create_cmd('PackerClean', function()
  cmd [[packadd packer.nvim]]
  require('plugins').clean()
end, {})
create_cmd('PackerCompile', function()
  cmd [[packadd packer.nvim]]
  require('plugins').compile()
end, {})

local map = vim.api.nvim_set_keymap


vim.cmd([[
    au BufRead,BufNewFile *.sql        nnoremap <buffer> gd :DBTGoToDefinition<CR>
]])

vim.cmd([[
" Appearance & Interface
" ------------------------------------------------------------------------------

set number  " Shows current line number
set relativenumber  " Show relative line numbers
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
try
  colorscheme solarized
catch
  echo "Failed to set color scheme"
endtry


" Quickscope
" ------------------------------------------------------------------------------
" let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
" highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" Mouse in terminal
" ------------------------------------------------------------------------------
set mouse=a

" neovim's python
" ------------------------------------------------------------------------------

if has('nvim')
  let g:python3_host_prog = '/usr/bin/python3'
endif

" Live preview of :substitute
" ------------------------------------------------------------------------------

if has('nvim')
  set inccommand=nosplit
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

nmap ga <Plug>(EasyAlign)

" ALE
" ------------------------------------------------------------------------------

let g:airline#extensions#ale#enabled = 1

let g:ale_linters = {}
let g:ale_linters['sh'] = ['shell', 'shellcheck']

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['eslint', 'prettier']

let g:ale_javascript_prettier_use_local_config = 1

let g:ale_sh_shellcheck_options = '-x'

let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1


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

" vim-multiple-cursors
" ------------------------------------------------------------------------------

let g:multi_cursor_use_default_mapping=0

let g:multi_cursor_next_key='<M-n>'
let g:multi_cursor_prev_key='<M-p>'
let g:multi_cursor_skip_key='<M-x>'
let g:multi_cursor_quit_key='<Esc>'

" Search
" ------------------------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch

" Indent
" ------------------------------------------------------------------------------
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
set wildmenu
set wildmode=list:longest,full

" Line length
" ----------------------------------------------------------------------------

set textwidth=80
let g:lengthmatters_highlight_one_column = 1

" CtrlP
" ------------------------------------------------------------------------------

let g:ctrlp_custom_ignore = 'node_modules\|.idea'
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_show_hidden = 1

" Mappings
" ==============================================================================

" Set sqlcomplete omni key to something else than the default '<C-C>'
let g:ftplugin_sql_omni_key = '<C-Ä>'


" Disable middle mouse paste
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

imap <C-c> <Esc>

nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" <leader> Mappings
" ------------------------------------------------------------------------------

map <space> <leader>

" Center text
nnoremap <leader>c :center<cr>
" Write and close
nnoremap <leader>W :wq<cr>
" Write buffer
nnoremap <leader>w :w<cr>
" Quit
nnoremap <leader>q :q<cr>
" Force quit all
nnoremap <leader>! :qa!<cr>
" Delete buffer - Deletes buffer and closes current pane
nnoremap <leader>d :bd<cr>
" Reload config
nnoremap <leader>L :source ~/.vimrc<cr>
" Switch buffers
nnoremap <leader>b :CtrlPBuffer<cr>
" Open file or buffer
nnoremap <leader>p :CtrlPMixed<cr>

" Source a visual range
vmap <leader>s y:@"<CR>

" Run ALEFix
nmap <leader>f <Plug>(ale_fix)

" Show next lint error
nmap <leader>n <Plug>(ale_next_wrap)

" Jump to definition
autocmd FileType javascript :nnoremap <buffer> <C-LeftMouse> <LeftMouse>:TernDef<CR>
" nnoremap <buffer> <C-LeftMouse> <LeftMouse>:TernDef<CR>

" ToggleBackground
nmap <leader>t :call ToggleBackground()<cr>

" Command mode
" ------------------------------------------------------------------------------

" common typos
cnoreabbrev W w
cnoreabbrev Wq wq

" Clipboard
" ------------------------------------------------------------------------------

" let g:clipboard = {
"       \ ''
"       \ '+' = 'xsel --nodetach -i -b'
"       \ '*': 'xsel --nodetach -i -p'
"       \ '+': 'xsel -o -b'
"       \ '*': 'xsel -o -p'
" Ctrl-{a,c,v} stand-in
" Copy register " to * and +
nnoremap <a-y> :let @*=@"\|let @+=@"<cr>
" Map visual mode <a-y> to a yank and then <a-y> in normal mode
vmap <a-y> y<a-y>
" Map insert mode <a-r> to a paste from system clipboard
inoremap <a-r> <c-o>:set paste<cr><c-r>+<c-o>:set nopaste<cr>

" Helper functions
" ------------------------------------------------------------------------------
function! ChompedSystem( ... )
    return substitute(call('system', a:000), '\n\+$', '', '')
endfunction

" Status line
" ==============================================================================
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

" UltiSnips
" ==============================================================================

let g:UltiSnipsEditSplit="context"
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/ultisnips', 'ultisnips']


" Functions
" ==============================================================================

" HorizontalRuler
" ------------------------------------------------------------------------------

inoremap <silent> <c-s-l> a<bs><c-\><c-o>:call HorizontalRuler()<cr>

function! HorizontalRuler()
  let wasAtEOL = (col('.') == col('$'))
  let char = nr2char(getchar())
  let width = &textwidth - (col('.') - 1)

  execute 'normal! ' . width . 'a' . char
  " start insert at end of line
  let bang = wasAtEOL ? '!' : ''
  execute 'startinsert' . bang
endfunction

" Copy abspath and line number to clipboard
" ------------------------------------------------------------------------------

nnoremap <leader>l :call CopyAbsPathAndLineNo()<cr>

function! CopyAbsPathAndLineNo()
  let @+=expand('%:p') . ':' . line('.')
endfunction

" ToggleBackground
" ------------------------------------------------------------------------------

nnoremap <c-e>b :call ToggleBackground()<cr>

function! ToggleBackground()
  if &background == 'light'
    set background=dark
  else
    set background=light
  end
endfunction

" Wayland clipboard provider that strips carriage returns (GTK3 issue).
" This is needed because currently there's an issue where GTK3 applications on
" Wayland contain carriage returns at the end of the lines (this is a root
" issue that needs to be fixed).
if exists('$WAYLAND_DISPLAY')
    " clipboard on wayland with newline fix
    let g:clipboard = {
        \   'name': 'WL-Clipboard with ^M Trim',
        \   'copy': {
        \      '+': 'wl-copy --foreground --type text/plain',
        \      '*': 'wl-copy --foreground --type text/plain --primary',
        \    },
        \   'paste': {
        \      '+': {-> systemlist('wl-paste --no-newline --type "text/plain;charset=utf-8" 2>/dev/null | sed -e "s/\\r\$//"', '', 1)},
        \      '*': {-> systemlist('wl-paste --no-newline --type "text/plain;charset=utf-8" --primary 2>/dev/null | sed -e "s/\r\\$//"', '', 1)},
        \   },
        \   'cache_enabled': 1,
        \ }
endif
]])

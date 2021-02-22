" plugins
let need_to_install_plugins = 0
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    let need_to_install_plugins = 1
endif

call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/The-NERD-tree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/indentpython.vim'
Plug 'lepture/vim-jinja'
Plug 'pangloss/vim-javascript'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'kien/ctrlp.vim'                     " Fast transitions on project files
Plug 'tpope/vim-surround'                 " Parentheses, brackets, quotes, XML tags, and more
Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'godlygeek/tabular'
Plug 'liuchengxu/vim-which-key'
"-----------------=== Snippets support ===--------------------
Plug 'honza/vim-snippets'                 " snippets repo
Plug 'preservim/nerdcommenter'            " comment
Plug 'mitsuhiko/vim-sparkup'              " Sparkup(XML/jinja/htlm-django/etc.) support
Plug 'SirVer/ultisnips'                   " Track the engine.
Plug 'honza/vim-snippets'                 " Snippets are separated from the engine. Add this if you want them:

Plug 'Raimondi/delimitMate'               "closing brackets
"-----------------=== Asynchronous Lint Engine==--------------------
Plug 'dense-analysis/ale'

"-----------------=== vim start screen ===-------------------
Plug 'mhinz/vim-startify'

"-----------------=== code virtual text  ==-------------------
Plug 'metakirby5/codi.vim'

"-----------------=== fzf ==-------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"----------------- A Vim Plugin for Lively Previewing LaTeX PDF Output
"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
"---------- syctex to go to location in latex
Plug 'peterbjorgensen/sved'




call plug#end()

filetype plugin indent on
syntax on

if need_to_install_plugins == 1
    echo "Installing plugins..."
    silent! PlugInstall
    echo "Done!"
    q
endif

" set leader
let mapleader = ","
let maplocalleader = "\\"
inoremap jj <ESC>
" always show the status bar
set laststatus=2

set encoding=utf-8
" enable 256 colors
set t_Co=256
set t_ut=

" turn on line numbering
set number
set relativenumber

" sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" sane editing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80
set expandtab
" starify for neovim
if !has('nvim')
    set viminfo+=~/.vim/viminfo
endif

"set viminfo='25,\"50,n~/.viminfo
set smarttab                                " set tabs for a shifttabs logic
set autoindent                              " indent when moving to the next line while writing code
set cursorline                              " shows line under the cursor's line
set showmatch                               " shows matching part of bracket pairs (), [], {}
set clipboard=unnamedplus                       " use system clipboard
map <C-y> :w !xclip -sel c <CR><CR>
" word movement
imap <S-Left> <Esc>bi
nmap <S-Left> b
imap <S-Right> <Esc><Right>wi
nmap <S-Right> w

" indent/unindent with tab/shift-tab
nmap <Tab> >>
imap <S-Tab> <Esc><<i
nmap <S-tab> <<

" mouse
set mouse=v
let g:is_mouse_enabled = 1
noremap <silent> <Leader>m :call ToggleMouse()<CR>
function ToggleMouse()
    if g:is_mouse_enabled == 1
        echo "Mouse OFF"
        set mouse=
        let g:is_mouse_enabled = 0
    else
        echo "Mouse ON"
        set mouse=a
        let g:is_mouse_enabled = 1
    endif
endfunction

" color scheme
syntax on
colorscheme onedark
filetype on
filetype plugin on
filetype plugin indent on

" lightline
set noshowmode
let g:lightline = {
        \ 'colorscheme': 'powerline',
        \ 'active': {
        \   'right': [ [  'TIME'],
        \            [ 'percent',  'lineinfo' ],
        \            [ 'fileformat', 'fileencoding', 'filetype'] ]
        \ },
        \ 'component': {
        \   'TIME':'%{strftime("%H:%M")}'
        \ },
        \ }

" code folding
set foldmethod=indent
set foldlevel=99

" wrap toggle
setlocal nowrap
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
    if &wrap
        echo "Wrap OFF"
        setlocal nowrap
        set virtualedit=all
        silent! nunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <Up>
        silent! iunmap <buffer> <Down>
        silent! iunmap <buffer> <Home>
        silent! iunmap <buffer> <End>
    else
        echo "Wrap ON"
        setlocal wrap linebreak nolist
        set virtualedit=
        setlocal display+=lastline
        noremap  <buffer> <silent> <Up>   gk
        noremap  <buffer> <silent> <Down> gj
        noremap  <buffer> <silent> <Home> g<Home>
        noremap  <buffer> <silent> <End>  g<End>
        inoremap <buffer> <silent> <Up>   <C-o>gk
        inoremap <buffer> <silent> <Down> <C-o>gj
        inoremap <buffer> <silent> <Home> <C-o>g<Home>
        inoremap <buffer> <silent> <End>  <C-o>g<End>
    endif
endfunction

" move through split windows
nmap <leader><Up> :wincmd k<CR>
nmap <leader><Down> :wincmd j<CR>
nmap <leader><Left> :wincmd h<CR>
nmap <leader><Right> :wincmd l<CR>

" move through buffers
nmap <leader>[ :bp!<CR>
nmap <leader>] :bn!<CR>
nmap <leader>x :bd<CR>

" restore place in file from previous session
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" file browser
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0
map <leader>n :call NERDTreeToggle()<CR>
function NERDTreeToggle()
    NERDTreeTabsToggle
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
    else
        let g:nerdtree_open = 1
        wincmd p
    endif
endfunction


" tag list
map <leader>t :TagbarToggle<CR>

" copy, cut and paste
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" disable autoindent when pasting text
" source: https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
"" Search settings
"=====================================================
set incsearch	                            " incremental search
set hlsearch	                            " highlight search results
nnoremap <leader><space> :nohlsearch<CR>
"=====================================================
"" SnipMate settings
"=====================================================
let g:snippets_dir='~/.vim/vim-snippets/snippets'
"=====================================================
"" Python settings
"=====================================================

" YouCompleteMe
set completeopt-=preview

let g:ycm_global_ycm_extra_conf='~/.vim/ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0

let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

nmap <leader>g :YcmCompleter GoTo<CR>
nmap <leader>d :YcmCompleter GoToDefinition<CR>

"---------------- ale -----
let g:ale_sign_column_always = 1
"----------------- ale error ------
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

let g:ale_linters = {'python':['flake8', 'pydocstyle', 'bandit', 'mypy']} " 'flake8', 'pydocstyle', 'bandit', 'mypy'
let g:ale_fixers = {'*':['remove_trailing_lines', 'trim_whitespace'], 'python':['black','isort']}
let g:ale_fix_on_save = 1

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = ";"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsListSnippets = "<c-l>" "List possible snippets based on current file


let g:startify_bookmarks = [ {'c': '~/.vimrc'}, '~/.vimrc_bharath_backup' ]

let g:startify_commands = [{'help':'h startify'}]
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_change_to_dir = 1
let g:startify_session_savevars = [
           \ 'g:startify_session_savevars',
           \ 'g:startify_session_savecmds',
           \ 'g:random_plugin_use_feature'
           \ ]
"let g:startify_session_savecmds = [
"           \ 'silent !pdfreader ~/latexproject/main.pdf &'
"           \ ]
let g:startify_session_sort = 1
"===========================
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
"map <Leader>s<Plug>(easymotion-prefix)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
"------------------based on ColorScheme
"augroup qs_colors
"  autocmd!
"  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
"  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
"augroup END
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'],['{', '}']]
" Activation based on file type
augroup rainbow_python
  autocmd!
  autocmd FileType python,clojure,scheme RainbowParentheses
augroup END

" closing brackets
let delimitMate_expand_cr = 1
filetype indent plugin on
" which key
nnoremap <silent> <leader> :WhichKey ','<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '\\'<CR>
" By default timeoutlen is 1000 ms
set timeoutlen=500

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_python = 1

" Add your own custom formats or override the defaults
"let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Always enable preview window on the right with 60% width
let g:fzf_preview_window = 'right:60%'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" https://leetschau.github.io/python-ide-based-on-vim.html
" set statusline=\PATH:\ %r%F\ \ \ \ \LINE:\ %l/%L/%P\ TIME:\ %{strftime('%c')}
"
" latex
" let g:livepreview_previewer = 'evince'
"let g:livepreview_previewer = 'zathura'
"autocmd Filetype tex setl updatetime=1
"let g:livepreview_engine = 'xelatex'

" wildmenu
set wildmenu
set wildmode=longest:list,full
""""""""""""""""""
"-------------synctex for going form pdf to latex-----"
"first run xelatex --synctex=1 example.tex
""F4 to open location in pdf"
" ctrl + click to go to latex location
nmap <F4> :call SVED_Sync()<CR>
"
"autocmd BufWritePost *.tex silent! execute "!xelatex --synctex=1 % >/dev/null 2>&1" | redraw!
autocmd BufWritePost *.tex execute "!xelatex --synctex=1 %"

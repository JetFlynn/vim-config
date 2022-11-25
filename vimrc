"""
""" COMMON SETTINGS
"""

" Get directory for
let s:dirname = expand("<sfile>:p:h")

" Enable VI improved features
set nocompatible

" Enable file autocomands
filetype plugin on

" Increase default history from 20 to 500
set history=1000

" Do not close buffers, just hide them
set hidden

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Stop vim from creating automatic backups
set noswapfile
set nobackup
set nowb

" Lowering timeout after pressing esc
set ttimeout
set ttimeoutlen=0
set timeoutlen=1000

" Automatic syntax highlight
syntax on

" Fix syntax disappearing
autocmd BufEnter * :syntax sync fromstart

" Reload files modified outside of Vim
set autoread

" Replace tabs with spaces
set expandtab

" Make tabs 2 spaces wide
set tabstop=2
set shiftwidth=2

" Show line numbers
set number

" Set show matching parenthesis
set showmatch

" Ignore case when searching
set ignorecase

" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set smartcase

" Highlight all occurrences of a search
set hlsearch

" Show search matches as you type
set incsearch

" Allow true colors
set termguicolors

" Highlight column 121 to help keep lines of code 120 characters or less
set colorcolumn=121

" Remove trailing spaces when saving a file
autocmd BufWritePre * :%s/\s\+$//e

" Show tabs and trailing spaces
set list listchars=tab:→\ ,trail:·

" Set color scheme "
colorscheme gruvbox
set background=dark

" Fifferent Insert mode cursor
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Open new splits to right and below
set splitbelow
set splitright

" Tabs index
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif

" Search for current selection
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

"""
""" KEYBOARD
"""

" Set up leader key
let mapleader = " "

" Hotkey to access current vimrc
command Vimrc e $MYVIMRC

" Htkey for current buffer path
command Path let @+ = './' . expand("%")

" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

" Window
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Efficient esc
inoremap kj <Esc>

" Tabs
map <leader>tn :tabnew<CR>
map <leader>t/ :tabonly<CR>

"""
""" PLUGINS
"""

call plug#begin()

" Handy navigation keybindings
Plug 'tpope/vim-unimpaired'

" Extend % functionality
runtime macros/matchit.vim

" Colorscheme
Plug 'morhetz/gruvbox'

" Conquer Of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Emmet
Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key=','

" LF and Ranger
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'francoiscabrol/ranger.vim'
map <leader>r :Ranger<CR>
map <leader>e :Lf<CR>

" Async linter
Plug 'w0rp/ale'
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Suround
Plug 'tpope/vim-surround'

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
map <leader>p :Files<CR>
map <leader>b :Buffers<CR>
map <leader>/ :Ag<CR>
map <leader>l :Lines<CR>
map <leader>; :BLines<CR>
map <leader>h: :History:<CR>
map <leader>h/ :History/<CR>
map <leader>c :BCommits<CR>
map <leader>w :Windows<CR>

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" Git
Plug 'iberianpig/tig-explorer.vim'
Plug 'tpope/vim-fugitive'
map <leader>gb :Git blame<CR>
map <leader>gs :Git<CR>
map <leader>ge :Gedit<CR>
map <leader>gd :Gdiff<CR>
map <leader>gc :Gcommit<CR>
Plug 'airblade/vim-gitgutter'
autocmd BufWritePost * GitGutter " Run gutter on save

" snake case to camelcase and vise versa
Plug 'tpope/vim-abolish'

" Indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
map <leader>i :IndentGuidesToggle<CR>

" Cool navigation with tmux
Plug 'christoomey/vim-tmux-navigator'

" Even more cool integration with tmux
Plug 'benmills/vimux'

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>
" Zoom the tmux runner pane
map <Leader>vz :VimuxZoomRunner<CR>

" Faster copy to clipboard
noremap <Leader>y "+y

"""
""" Specific plugins and hacks
"""

""" Ruby

" gf for rails
Plug 'tpope/vim-rails'
" Htkey for current path for rspec
command Rspec let @+ = 'icom rspec ./' . expand("%")
" Htkey for fast access migrations
ca Emig :Emigration
" fix rubocop highlight problems
highlight AleWarning guibg=#6e2000
" Helper for ruby end word
Plug 'tpope/vim-endwise'

call plug#end()

""" Alacritty fix

" fix alacritty
if &term == "alacritty"
  let &term = "xterm-256color"
endif

"""
""" COMMON SETTINGS
"""

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

" Highlight column 81 to help keep lines of code 80 characters or less
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

" Relative numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

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

" Window
map <leader>wv :vsplit<CR>
map <leader>wh :split<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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

" Autocomplete
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>

" Emmet
Plug 'mattn/emmet-vim'
let g:user_emmet_leader_key=','

" Ranger
Plug 'francoiscabrol/ranger.vim'
map <leader>r :Ranger<CR>

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

" Syntax highlight
Plug 'sheerun/vim-polyglot'

" Git
Plug 'iberianpig/tig-explorer.vim'
Plug 'tpope/vim-fugitive'
map <leader>gb :Gblame<CR>
map <leader>gs :Gstatus<CR>
map <leader>ge :Gedit<CR>
map <leader>gd :Gdiff<CR>
map <leader>gc :Gcommit<CR>
Plug 'airblade/vim-gitgutter'
autocmd BufWritePost * GitGutter " Run gutter on save

" Add tags file autoupdate with regards to gitignore
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_file_list_command = 'rg --files'

" Indent guides
Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
map <leader>i :IndentGuidesToggle<CR>

"""
""" Specific plugins
"""

" gf for rails
Plug 'tpope/vim-rails'

" gf for node
Plug 'moll/vim-node'

" Helper for ruby end word
Plug 'tpope/vim-endwise'

call plug#end()

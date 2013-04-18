" Tab settings
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Show matched parens only while typing
let g:loaded_matchparen=1
set showmatch

" APPEARANCE
" Mark trailing white space
autocmd BufReadPost *
            \ highlight ExtraWhitespace ctermbg=red guibg=red |
            \ match ExtraWhitespace /\s\+$/

" Search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" Input settings
set showcmd
set mouse=a
set virtualedit=all

" Vim-latex configs
if has("win32")
    set shellslash
endif
set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'

" When opening a buffer place cursor on last known position
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g'\"" |
            \ endif

" Unbind the cursor keys
for prefix in ['i', 'n', 'v']
    for key in ['<Up>', '<Down>', '<Left>', '<Right>']
        exe prefix . "noremap " . key . " <Nop>"
    endfor
endfor

" Following options only apply to gvim
if has("gui_running")
    set t_Co=256
    colorscheme wombat256mod
    set guioptions-=T
    set guioptions+=c
    set guifont=Terminus\ 10
    set mousehide
endif

" Enable pythogen
exe pathogen#infect()
exe pathogen#helptags()

" Remap Q to 'reformat paragraph' to avoid ex mode
nmap Q gqap

" Set indentation and syntax highlighting
set autoindent
set smartindent
filetype plugin indent on
syntax on

" In insert mode set a mark at the 80 chars border
" Note that this has to be done  a f t e r  enabling syntax highlighting so
" the colour setting is not overridden
highlight ColorColumn ctermbg=4 guibg=#1A1A1A
augroup ColorcolumnOnlyInInsertMode
    autocmd!
    autocmd InsertEnter * setlocal colorcolumn=80
    autocmd InsertLeave * setlocal colorcolumn=0
augroup END

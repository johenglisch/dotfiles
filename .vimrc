" appearance
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
let g:loaded_matchparen=1
set showmatch

" search settings
set ignorecase
set smartcase
set incsearch
set nohlsearch

" input settings
set showcmd
set mouse=a
set virtualedit=all

" vim-latex configs
if has("win32")
    set shellslash
endif
set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'

" when opening a buffer place cursor on last known position
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

" following options only apply to gvim
if has("gui_running")
    colorscheme tango
    set guioptions-=T
    set guifont=Terminus\ 10
    set mousehide
endif

" set indentation and syntax highlighting
set autoindent
set smartindent
filetype plugin indent on
syntax on

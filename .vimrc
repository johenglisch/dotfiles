" EDITING {{{

" tab settings
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" input settings
set showcmd
set mouse=a
set virtualedit=all

" place cursor to last known position
augroup PositionCursor
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g'\"" |
                \ endif
augroup END
" }}}

" KEY BINDINGS {{{

" save buffer
nnoremap ZW :w!<CR>

" movement to line edges
nnoremap H ^
vnoremap H ^
nnoremap L $
vnoremap L $

" wrap text
nnoremap Q gq
vnoremap Q gq

" toggle folding
nnoremap <space> za
" note: fold everything = zM)
" unfold everything
nnoremap <backspace> zn

" unbind cursor keys
for prefix in ['i', 'n', 'v']
    for key in ['<up>', '<down>', '<left>', '<right>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor
" }}}

" APPEARANCE {{{

" show matched parens only while typing
let g:loaded_matchparen=1
set showmatch

" mark trailing white space
augroup TrailingWhitespace
    autocmd!
    autocmd BufReadPost *
                \ highlight ExtraWhitespace ctermbg=red guibg=red |
                \ match ExtraWhitespace /\s\+$/
augroup END

" gui settings
if has("gui_running")
    set t_Co=256
    colorscheme wombat256mod
    set guioptions-=T
    set guioptions+=c
    set guifont=Terminus\ 12
    set mousehide
endif

" set a mark at the 80 chars border in insert mode
augroup ColorcolumnOnlyInInsertMode
    autocmd!
    autocmd InsertEnter * set colorcolumn=80
    autocmd InsertLeave * set colorcolumn=0
augroup END
" }}}

" PLUGIN STUFF {{{

" pathogen
exe pathogen#infect()
exe pathogen#helptags()

" vim-latex config
if has("win32")
    set shellslash
endif
set grepprg=grep\ -nH\ $*
let g:tex_flavor = 'latex'

" indentation and syntax highlighting
set autoindent
set smartindent
filetype plugin indent on
syntax on

" set colour of the 80 char mark depending on bg
if &background ==# 'light'
    highlight ColorColumn ctermbg=LightBlue guibg=LightGrey
else
    highlight ColorColumn ctermbg=DarkBlue guibg=#1A1A1A
endif
" }}}

" vim:foldmethod=marker:nofoldenable:

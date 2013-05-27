" pep8-approved line wrapping
set textwidth=79

" noone is being folded until I blow this whistle
set nofoldenable

" include autocomplete (activate with C-x C-o)
set omnifunc=pythoncomplete#Complete

" ignore some files while ctrlp'ing
setlocal wildignore+=*.py[co]

" plugin shortcuts
nmap <Leader>t :TaskList<CR>
nmap <Leader>p :TlistToggle<CR>

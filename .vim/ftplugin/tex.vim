" indentation and tabs
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal smarttab
set linebreak

" improve speed
setlocal norelativenumber

" use C-n for cycling through label keywords
set iskeyword+=:

" folding
"let g:Tex_AutoFolding = 0
let g:Tex_FoldedEnvironments="abstract,titlepage"
let g:Tex_FoldedMisc="preamble,<<<"

" disable auto completion of quotation marks
let g:Tex_SmartKeyQuote = 0

" set leader symbol to the most useless character on the keyboard...
let g:Tex_Leader = "§"

" map my latexclean bash script to \lc
nmap <Leader>lc :!latexclean<CR>

" latex quick build (dvi->ps->pdf)
let g:Tex_MultipleCompileFormats = "dvi,ps"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_FormatDependency_ps = "dvi,ps"
let g:Tex_FormatDependency_pdf = "dvi,ps,pdf"
let g:Tex_CompileRule_dvi = "/usr/bin/latex --interaction=nonstopmode $*"
let g:Tex_CompileRule_ps = "/usr/bin/dvips -o $*.ps $*.dvi -Ppdf"
let g:Tex_CompileRule_pdf = "/usr/bin/ps2pdf $*.ps"
let g:Tex_ViewRule_dvi = "/usr/bin/okular $*.dvi 2>/dev/null"
let g:Tex_ViewRule_pdf = "/usr/bin/okular $*.pdf 2>/dev/null"

" ignore some warnings
let g:Tex_IgnoredWarnings =
			\"Underfull\n".
			\"Overfull\n".
			\"specifier changed to\n".
			\"You have requested\n".
			\"Missing number, treated as zero.\n".
			\"There were undefined references\n".
			\"Citation %.%# undefined\n".
			\"LaTeX Font Warning:\n"
let g:Tex_IgnoreLevel = 8

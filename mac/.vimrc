set ignorecase

"set clipboard+=unnamed
set clipboard+=unnamedplus

" Copy to clipboard
vnoremap  y  "+y
nnoremap  Y  "+yg_
nnoremap  y  "+y
"nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap p "+p
nnoremap P "+P
vnoremap p "+p
vnoremap P "+P

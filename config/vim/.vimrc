set nocompatible
set nowrap
set cursorline
set colorcolumn
set hlsearch
set norelativenumber
set go=gt
set go-=m
if has('gui_running')
    if has("win16") || has("win32") || has("win95") || has("win64")
        set guifont=Hack:h13:cANSI:qDRAFT,Fira_Mono:h13:cANSI:qDRAFT
    else
        set guifont=Courier_New:h13:cANSI:qDRAFT,Consolas:h13:cANSI:qDRAFT
    endif
endif
colorscheme desert

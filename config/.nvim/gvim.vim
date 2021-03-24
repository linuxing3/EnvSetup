" Description: A minimal, but feature rich, example neovim init file.
" Font
GuiFont Hack:h14
GuiTabline 0
syntax on
" Colortheme
colorscheme onedark
" line numbers
set nu
" copy and paste
set mouse=a
source $VIMRUNTIME/mswin.vim
vmap <LeftRelease> "*ygv
imap <S-insert> <C-R>

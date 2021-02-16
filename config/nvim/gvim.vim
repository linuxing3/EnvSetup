" URL: https://gist.github.com/linuxing3/0917b827b279021a8040c065aa1b72a5
" Authors: linuxing3
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

" URL: https://gist.github.com/linuxing3/0917b827b279021a8040c065aa1b72a5
" Authors: linuxing3
" Description: A minimal, but feature rich, example neovim init file.

" ===================================================================
" Plug Settings
" ===================================================================
call plug#begin('~/AppData/Local/nvim/plugged')

Plug 'mhinz/vim-startify'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/goyo.vim'

" theme
Plug 'joshdick/onedark.vim'
Plug 'iCyMind/NeoSolarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Cool Icons
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

" file manager
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf.vim'

" editor
Plug 'wincent/ferret'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pechorin/any-jump.vim'
Plug 'RRethy/vim-illuminate'

" tools
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins'}
Plug 'mattn/vim-gist'
Plug 'mattn/webapi-vim'

" languages
Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'

call plug#end()

" ===================================================================
" Basic Settings
" ===================================================================
set hidden
set nobackup
set nowritebackup
set cmdheight=2
" Better command-line completion
set wildmenu
" Show partial commands in the last line of the screen
set showcmd
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
" Use <F10> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F10>
"------------------------------------------------------------
" Indentation options 
" Indentation settings according to personal preference.
" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
	set signcolumn=number
else 
	set signcolumn=yes
endif

" ===================================================================
" spacemacs like keymapping
" ===================================================================
nmap <F2> :bprevious<CR>
nmap <F3> :bnext<CR>
nmap <F4> :NERDTreeToggle<CR>
nmap <F5> :Denite buffer<CR>
nmap <F6> :Gstatus<CR>
nmap <F7> :Git push<CR>
nmap <F8> :Git pull<CR>
nmap <F9> :w! ~\OneDrive\config\vim\init.vim<CR>
nmap <F11> <Plug>(coc-importantation)
nmap <F12> <Plug>(coc-definition)

" =======================================================
" which keys
" =======================================================
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
set timeoutlen=500

nnoremap <silent> <leader><leader> :

let g:which_key_map =  {}
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }

" `name` 是一个特殊字段，如果 dict 里面的元素也是一个 dict，那么表明一个 group，比如 `+file`, 就会高亮和显示 `+file` 。默认是 `+prefix`.

" =======================================================
" 基于已经存在的快捷键映射，直接使用一个字符串说明介绍信息即可
" =======================================================
" You can pass a descriptive text to an existing mapping.

let g:which_key_map.f = { 'name' : '+file' }

nnoremap <silent> <leader>ff :e .<CR>
let g:which_key_map.f.s = 'open-cwd'

nnoremap <silent> <leader>fs :update<CR>
let g:which_key_map.f.s = 'save-file'

nnoremap <silent> <leader>fd :e $MYVIMRC<CR>
let g:which_key_map.f.d = 'open-vimrc'

nnoremap <silent> <leader>oq  :copen<CR>
nnoremap <silent> <leader>ol  :lopen<CR>
let g:which_key_map.o = {
      \ 'name' : '+open',
      \ 'q' : 'open-quickfix'    ,
      \ 'l' : 'open-locationlist',
      \ }

" =======================================================
" 不存在相关的快捷键映射，需要用一个 list：
" 第一个元素表明执行的操作，第二个是该操作的介绍
" =======================================================
" Provide commands(ex-command, <Plug>/<C-W>/<C-d> mapping, etc.) and descriptions for existing mappings
let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'        , 'buffer 1']        ,
      \ '2' : ['b2'        , 'buffer 2']        ,
      \ 'b' : ['Buffers'   , 'fzf-buffer']    ,
      \ 'f' : ['bfirst'    , 'first-buffer']    ,
      \ 'h' : ['Startify'  , 'home-buffer']     ,
      \ 'k' : ['bk'        , 'delete-buffer']   ,
      \ 'l' : ['blast'     , 'last-buffer']     ,
      \ 'n' : ['bnext'     , 'next-buffer']     ,
      \ 'p' : ['bprevious' , 'previous-buffer'] ,
      \ '?' : ['Buffers'   , 'fzf-buffer']      ,
      \ }

let g:which_key_map.c = {
      \ 'name' : '+code'                                            ,
      \ 'f' : ['coc-format'     , 'formatting']       ,
      \ 'h' : ['coc-hover'          , 'hover']            ,
      \ 'r' : ['coc-reference'     , 'references']       ,
      \ 'R' : ['coc-rename'         , 'rename']           ,
      \ 's' : ['coc-document' , 'document-symbol']  ,
      \ 'S' : ['coc-documment'            , 'workspace-symbol'] ,
      \ 'g' : {
        \ 'name': '+goto',
        \ 'd' : ['coc-definition'     , 'definition']       ,
        \ 't' : ['coc-type-definition' , 'type-definition']  ,
        \ 'i' : ['coc-implementation'  , 'implementation']  ,
        \ },
      \ }

call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

" Double space for commands
" nnoremap <silent><nowait> <space><space>  :
" Windows
nnoremap <silent><nowait> <A-Up> :wincmd k<CR>
nnoremap <silent><nowait> <A-Down> :wincmd j<CR>
nnoremap <silent><nowait> <A-Left> :wincmd h<CR>
nnoremap <silent><nowait> <A-Right> :wincmd l<CR>
nnoremap <silent><nowait> <A-c> :wincmd c<CR>

" Buffers
nnoremap <silent><nowait> [b  :bprevious<CR>
nnoremap <silent><nowait> ]b  :bnext<CR>

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" =======================================================
" Files and buffers with fzf
" =======================================================
nnoremap <silent><nowait> <C-p> :Files<CR>
nnoremap <silent><nowait> <C-e> :Buffers<CR>
let g:fzf_action = {
	\ 'ctrl-e': 'edit',
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-x': 'split',
	\ 'ctrl-v': 'vsplit' }
" =======================================================
" coc settings
" =======================================================
" coc extension list
" ['coc-json', 'coc-git', 'coc-go', 'coc-typescript', 'coc-html', 'coc-java']
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-eslint', 'coc-prettier', 'coc-pairs', 'coc-snippets', 'coc-tsserver']
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
	\ pumvisible()? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump'])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>' " default c-j
let g:coc_snippet_prev = '<c-k>' " default

if has('nvim')
	inoremap <silent><expr> <c-@> coc#refresh()
else
	inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" keymapping
imap <c-l> <Plug>(coc-snippets-expand)
vmap <c-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
xmap <leader>x <Plug>(coc-convert-snippet)
nmap <silent> [g <Plug>(coc-diagnostic-pre)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-refrences)

" Use K to show documentation in preview window.
nmap <silent> K :call <SID>show_documentation()<CR> 
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else ()
		execute '!' . &keywordprg . " " . expand('<cword>')
	endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" gist settings
let g:gist_use_password_in_gitconfig = 1

set g:mapleader ' '
set g:maplocalleader ' '

" Quicker window manipulation
nmap <C-h> <C-w>h
nmap <C-l> <C-w>h
nmap <C-j> <C-w>h
nmap <C-k> <C-w>h
nmap <C-Right> <C-w>h
nmap <C-Left> <C-w>h

" Move visually
nmap j gj
nmap k gk

" Move text up and down
nmap <A-j> :m .+1<cr>==
nmap <A-k> :m .-2<cr>==
xmap <A-j> :move '>+1<cr>gv-gv
xmap <A-k> :move '>-2<cr>gv-gv

" Tired of reaching for ^ and $
nmap H ^
nmap L $
omap H ^
omap L $
xmap H ^
xmap L $

" Center search
nmap n nzz
nmap N Nzz

" Evil bindings
imap <C-n> <Down>
imap <C-p> <Up>
cmap <C-n> <Down>
cmap <C-p> <Up>
imap <C-f> <Right>
imap <C-b> <Left>
cmap <C-f> <Right>
cmap <C-b> <Left>
imap <C-e> <End>
cmap <C-e> <End>
imap <A-f> <Esc>wa
imap <A-b> <Esc>bi

" Better indenting
vmap < <gv
vmap > >gv

" Better escape
imap qi <Esc>
vmap qv <Esc>
tmap qt <C-\><C-n>

" Paste in insert mode
imap <C-v> <C-r>"

" Better number dial
nmap = <C-a>
nmap - <C-x>

" Abbreviates
cnoreabbrev h vert help
cnoreabbrev E edit

" Misc
" Always paste without replacing clipboard contents
vmap p "_dP
" Open help for cword
nmap ?? :vert help <C-r><C-w><cr>
" Run last command
nmap !! :<Up><cr>
" Regain <C-f>
cmap <C-i> <C-f>

nmap <leader>q <cmd>quit<cr>
xmap <leader>q <cmd>quit<cr>
tmap <leader>q <cmd>quit<cr>
nmap <leader>w <cmd>write<cr>
nmap <leader>h <cmd>nohlsearch<cr>
nmap <leader>a <cmd>$tabnew<cr>
nmap <leader>l <cmd>source %<cr>

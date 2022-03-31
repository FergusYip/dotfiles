syntax on
set number
set autoindent
set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set backspace=indent,eol,start
set mouse=a

call plug#begin('~/.vim/plugged')

" Plug 'mattn/emmet-vim'
Plug 'dracula/vim', { 'as': 'dracula' }
" Plug 'scrooloose/nerdtree'
" Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

call plug#end()

if (has("termguicolors"))
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
 set termguicolors
endif

let g:dracula_colorterm = 0
colorscheme dracula

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

:imap jj <Esc>

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

if !exists('g:vscode')
    " ordinary neovim
    set spell spelllang=en_au
else
    " VSCode extension
    function! VSCodeNotifyVisual(cmd, leaveSelection, ...)
        let mode = mode()
        if mode ==# 'V'
            let startLine = line('v')
            let endLine = line('.')
            call VSCodeNotifyRange(a:cmd, startLine, endLine, a:leaveSelection, a:000)
        elseif mode ==# 'v' || mode ==# "\<C-v>"
            let startPos = getpos('v')
            let endPos = getpos('.')
            call VSCodeNotifyRangePos(a:cmd, startPos[1], endPos[1], startPos[2], endPos[2] + 1, a:leaveSelection, a:000)
        else
            call VSCodeNotify(a:cmd, a:000)
        endif
    endfunction

    xnoremap <C-S-P> <Cmd>call VSCodeNotifyVisual('workbench.action.showCommands', 1)<CR>
endif



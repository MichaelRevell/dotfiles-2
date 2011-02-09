" .vimrc
" Author: Steve Losh <steve@stevelosh.com>
" Source: http://bitbucket.org/sjl/dotfiles/src/tip/vim/
"
" This file changes a lot.  I'll try to document pieces of it whenever I have
" a few minutes to kill.

" Preamble -------------------------------------------------------------------- {{{

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on
set nocompatible

" }}}
" Basic options --------------------------------------------------------------- {{{

set encoding=utf-8
set modelines=0
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set relativenumber
set laststatus=2
set undofile
set undoreload=10000
set cpoptions+=J
set list
set listchars=tab:▸\ ,eol:¬
set shell=/bin/bash

" Save when losing focus
au FocusLost * :wa

" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" }}}
" Status line {{{

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)

" }}}
" Backups {{{

set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
set backup                        " enable backups

" }}}
" Leader {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" Color scheme (terminal) {{{

syntax on
set background=dark
colorscheme molokai

" }}}

" }}}
" Searching and Movement ------------------------------------------------------ {{{

nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

map <leader><space> :noh<cr>

runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

nnoremap Y y$
nnoremap D d$

" Directional Keys {{{

" Why stretch?
noremap h ;
noremap j h
noremap k gj
noremap l gk
noremap ; l

" Easy buffer navigation
" Note: For this section to make any sense you need to remap Ctrl-; to Ctrl-g at
"       the KEYBOARD level.  The reason is that for some reason the OS X doesn't
"       recognize the Ctrl+; combination as something special, so it just passes it
"       to Vim as a semicolon.
"
"       Yeah, it's dumb.
noremap <C-j>  <C-w>h
noremap <C-k>  <C-w>j
noremap <C-l>  <C-w>k
noremap <C-g>  <C-w>l
noremap <leader>w <C-w>v<C-w>l

" }}}

" }}}
" Folding --------------------------------------------------------------------- {{{

set foldlevelstart=0
nnoremap <Space> za
vnoremap <Space> za
nnoremap zO zCzO

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

" }}}
" Destroy infuriating keys ---------------------------------------------------- {{{

" Fuck you, help key.
set fuoptions=maxvert,maxhorz
inoremap <F1> <ESC>:set invfullscreen<CR>a
noremap <F1> :set invfullscreen<CR>

" Fuck you too, manual key.
nnoremap K <nop>

" Stop it, hash key.
inoremap # X<BS>#

" }}}
" Various filetype-specific stuff --------------------------------------------- {{{

" Cram {{{
au BufNewFile,BufRead *.t set filetype=cram
let cram_fold=1
autocmd Syntax cram setlocal foldlevel=1
" }}}
" Clojure {{{
au BufNewFile,BufRead *.clj nmap <localleader>ee 0;\et
au FileType clojure call TurnOnClojureFolding()
" }}}
" HTML and HTMLDjango {{{
au BufNewFile,BufRead *.html setlocal filetype=htmldjango
au BufNewFile,BufRead *.html setlocal foldmethod=manual
au BufNewFile,BufRead *.html nnoremap <buffer> <localleader>f Vatzf
au BufNewFile,BufRead *.html inoremap <buffer> <s-cr> <cr><esc>kA<cr>
au BufNewFile,BufRead *.html imap <buffer> <d-e><cr> <d-e><s-cr>
au BufNewFile,BufRead *.html imap <buffer> <d-e><space> <d-e>.<bs>
au BufNewFile,BufRead *.html nnoremap <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>
" }}}
" LessCSS {{{
au BufNewFile,BufRead *.less setlocal filetype=less
au BufNewFile,BufRead *.less setlocal foldmethod=marker
au BufNewFile,BufRead *.less setlocal foldmarker={,}
au BufNewFile,BufRead *.less setlocal nocursorline
au BufNewFile,BufRead *.less nnoremap <buffer> cc ddko
au BufNewFile,BufRead *.less nnoremap <buffer> <localleader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>
au BufNewFile,BufRead *.less inoremap <buffer> {<cr> {}<left><cr>.<cr><esc>kA<bs><space><space><space><space>
" }}}
" Javascript {{{
au BufNewFile,BufRead *.js setlocal foldmethod=marker
au BufNewFile,BufRead *.js setlocal foldmarker={,}
" }}}
" Confluence {{{
au BufRead,BufNewFile *.confluencewiki setlocal filetype=confluencewiki
au BufRead,BufNewFile *.confluencewiki setlocal wrap linebreak nolist
" }}}
" Fish {{{
au BufNewFile,BufRead *.fish setlocal filetype=fish
" }}}
" Markdown {{{
au BufNewFile,BufRead *.m*down setlocal filetype=markdown
au BufNewFile,BufRead *.m*down nnoremap <buffer> <localleader>1 yypVr=
au BufNewFile,BufRead *.m*down nnoremap <buffer> <localleader>2 yypVr-
au BufNewFile,BufRead *.m*down nnoremap <buffer> <localleader>3 I### <ESC>
" }}}
" Vim {{{
au FileType vim setlocal foldmethod=marker
" }}}
" Django {{{
au BufNewFile,BufRead urls.py      setlocal nowrap
au BufNewFile,BufRead urls.py      normal! zR
au BufNewFile,BufRead settings.py  normal! zR
au BufNewFile,BufRead dashboard.py normal! zR
" }}}
" Nginx {{{
au BufRead,BufNewFile /etc/nginx/conf/* set ft=nginx
au BufRead,BufNewFile /etc/nginx/sites-available/* set ft=nginx
au BufRead,BufNewFile /usr/local/etc/nginx/sites-available/* set ft=nginx
" }}}

" }}}
" Convenience mappings -------------------------------------------------------- {{{

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Ack
map <leader>a :Ack 

" Yankring
nnoremap <silent> <F6> :YRShow<cr>

" Formatting, TextMate-style
nnoremap <leader>q gqip

" Faster Make
nnoremap <leader>m :make<cr>

" Easier linewise reselection
nnoremap <leader>v V`]

" HTML tag closing
inoremap <C-_> <Space><BS><Esc>:call InsertCloseTag()<cr>a

" Faster Esc
inoremap jk <ESC>

" TextMate-Style Autocomplete
inoremap <ESC> <C-P>
inoremap <S-ESC> <C-N>

" Scratch
nmap <leader><tab> :Sscratch<cr><C-W>x<C-j>:resize 15<cr>

" Make selecting inside an HTML tag less dumb
nnoremap Vit vitVkoj
nnoremap Vat vatV

" Rainbows!
nmap <leader>R :RainbowParenthesesToggle<CR>

" Edit vim stuff
nnoremap <leader>ev <C-w>s<C-w>j<C-w>L:e $MYVIMRC<cr>
nnoremap <leader>es <C-w>s<C-w>j<C-w>L:e ~/.vim/snippets/<cr>

" Sudo to write
cmap w!! w !sudo tee % >/dev/null

" Easy filetype switching
nnoremap _dt :set ft=htmldjango<CR>
nnoremap _jt :set ft=htmljinja<CR>
nnoremap _cw :set ft=confluencewiki<CR>
nnoremap _pd :set ft=python.django<CR>

" }}}
" Plugin Settings ------------------------------------------------------------- {{{

" NERD Tree {{{
map <F2> :NERDTreeToggle<cr>
let NERDTreeIgnore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index', 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json']
" }}}
" HTML5 {{{
let g:event_handler_attributes_complete = 0
let g:rdfa_attributes_complete = 0
let g:microdata_attributes_complete = 0
let g:atia_attributes_complete = 0
" }}}
" Rope and Bike {{{
let g:bike_exceptions=1
source $HOME/.vim/sadness/sadness.vim

let ropevim_enable_shortcuts = 0
let ropevim_guess_project = 1
noremap <leader>rr :RopeRename<CR>
vnoremap <leader>rm :RopeExtractMethod<CR>
noremap <leader>roi :RopeOrganizeImports<CR>
" }}}
" Gundo {{{
nnoremap <F5> :GundoToggle<CR>
let g:gundo_debug = 1
let g:gundo_preview_bottom = 1
" }}}
" VimClojure {{{
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = $HOME . "/.vim/bundle/vimclojure/bin/ng"
let vimclojure#SplitPos = "right"
" }}}
" Syntastic {{{
let g:syntastic_enable_signs=1
let g:syntastic_disabled_filetypes = ['html', 'python']
" }}}

" }}}
" Synstack -------------------------------------------------------------------- {{{

function! SynStack() " {{{
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc " }}}
nmap <C-S> :call SynStack()<CR>

" }}}
" Tags! ----------------------------------------------------------------------- {{{

let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_WinWidth = 50
let Tlist_Show_One_File = 1

map <F4> :TlistToggle<cr>
map <leader>T :!/usr/local/bin/ctags --exclude='**/ckeditor' -R . $(test -f .venv && echo ~/lib/virtualenvs/`cat .venv`)<CR>

" }}}
" Text objects ---------------------------------------------------------------- {{{

" Shortcut for [] {{{

onoremap id i[
onoremap ad a[

" }}}
" Next () {{{
vnoremap <silent> inb :<C-U>normal! f(vib<cr>
onoremap <silent> inb :<C-U>normal! f(vib<cr>
vnoremap <silent> anb :<C-U>normal! f(vab<cr>
onoremap <silent> anb :<C-U>normal! f(vab<cr>
vnoremap <silent> in( :<C-U>normal! f(vi(<cr>
onoremap <silent> in( :<C-U>normal! f(vi(<cr>
vnoremap <silent> an( :<C-U>normal! f(va(<cr>
onoremap <silent> an( :<C-U>normal! f(va(<cr>
" }}}
" Next {} {{{
vnoremap <silent> inB :<C-U>normal! f{viB<cr>
onoremap <silent> inB :<C-U>normal! f{viB<cr>
vnoremap <silent> anB :<C-U>normal! f{vaB<cr>
onoremap <silent> anB :<C-U>normal! f{vaB<cr>
vnoremap <silent> in{ :<C-U>normal! f{vi{<cr>
onoremap <silent> in{ :<C-U>normal! f{vi{<cr>
vnoremap <silent> an{ :<C-U>normal! f{va{<cr>
onoremap <silent> an{ :<C-U>normal! f{va{<cr>
" }}}
" Next [] {{{
vnoremap <silent> ind :<C-U>normal! f[vi[<cr>
onoremap <silent> ind :<C-U>normal! f[vi[<cr>
vnoremap <silent> and :<C-U>normal! f[va[<cr>
onoremap <silent> and :<C-U>normal! f[va[<cr>
vnoremap <silent> in[ :<C-U>normal! f[vi[<cr>
onoremap <silent> in[ :<C-U>normal! f[vi[<cr>
vnoremap <silent> an[ :<C-U>normal! f[va[<cr>
onoremap <silent> an[ :<C-U>normal! f[va[<cr>
" }}}
" Next <> {{{
vnoremap <silent> in< :<C-U>normal! f<vi<<cr>
onoremap <silent> in< :<C-U>normal! f<vi<<cr>
vnoremap <silent> an< :<C-U>normal! f<va<<cr>
onoremap <silent> an< :<C-U>normal! f<va<<cr>
" }}}
" Next '' {{{
vnoremap <silent> in' :<C-U>normal! f'vi'<cr>
onoremap <silent> in' :<C-U>normal! f'vi'<cr>
vnoremap <silent> an' :<C-U>normal! f'va'<cr>
onoremap <silent> an' :<C-U>normal! f'va'<cr>
" }}}
" Next "" {{{
vnoremap <silent> in" :<C-U>normal! f"vi"<cr>
onoremap <silent> in" :<C-U>normal! f"vi"<cr>
vnoremap <silent> an" :<C-U>normal! f"va"<cr>
onoremap <silent> an" :<C-U>normal! f"va"<cr>
" }}}

" }}}
" Quickreturn ----------------------------------------------------------------- {{{

inoremap <c-cr> <esc>A<cr>
inoremap <s-cr> <esc>A:<cr>

" }}}
" Error toggle ---------------------------------------------------------------- {{{

nmap <silent> <f3> :ErrorsToggle<cr>
command! ErrorsToggle call ErrorsToggle()
function! ErrorsToggle() " {{{
  if exists("w:is_error_window")
    unlet w:is_error_window
    exec "q"
  else
    exec "Errors"
    lopen
    let w:is_error_window = 1
  endif
endfunction " }}}

" }}}
" Diff ------------------------------------------------------------------------ {{{

let g:HgDiffing = 0

function! s:HgDiffCurrentFile() " {{{
    if g:HgDiffing == 1
        if bufwinnr(bufnr('__HGDIFF__')) != -1
            exe bufwinnr(bufnr('__HGDIFF__')) . "wincmd w"
            bdelete
        endif

        diffoff!

        let g:HgDiffing = 0

        return
    endif

    let fname = bufname('%')
    let ftype = &ft
    diffthis

    vnew __HGDIFF__

    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    exec 'setlocal filetype='.ftype

    setlocal modifiable

    silent normal! ggdG
    silent exec ':r!hg cat ' . fname
    silent normal! ggdd

    setlocal nomodifiable

    diffthis

    wincmd l

    let g:HgDiffing = 1

    return
endfunction " }}}

command! HgDiffCurrent call s:HgDiffCurrentFile()
nmap <leader>d :HgDiffCurrent<cr>

" }}}
" MacVim ---------------------------------------------------------------------- {{{

if has('gui_running')
    set guifont=Menlo:h12

    set go-=T
    set go-=l
    set go-=L
    set go-=r
    set go-=R

    if has("gui_macvim")
        macmenu &File.New\ Tab key=<nop>
        map <leader>t <Plug>PeepOpen
        map <leader>r ,w<Plug>PeepOpen
    end

    let g:sparkupExecuteMapping = '<D-e>'

    highlight SpellBad term=underline gui=undercurl guisp=Orange
else
    set nocursorline
endif

" }}}

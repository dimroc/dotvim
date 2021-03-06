" Keybindings
" -----------

let mapleader = ","

" have W write as well for shift being held too long
command W w

" Shortcut to close all other tabs and windows
command Ont exec 'only|tabo'

" Generate Ctags for rails application AND bundled gems
command CtagsBundle exec '!ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)'
"command CtagsPython exec '!ctags -R --languages=python --exclude=.git --exclude=log .'
command CtagsPython exec
      \ "!ctags -R --fields=+l --languages=python --python-kinds=-iv $(python -c \"import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))\")"

" Shortcut to tabularize lines of code via a character using the whitespace after it.
" i.e. key: value
"      somelongerkey: value
" becomes key:           value
"         somelongerkey: value
" Usage: Tabz :
command! -nargs=1 -range Tabc exec <line1> . ',' . <line2> . 'Tabularize /' . escape(<q-args>, '\^$.[?*~') . ' \zs'

" Tabularize only against the first matching character.
command! -nargs=1 -range TabFirst exec <line1> . ',' . <line2> . 'Tabularize /^[^' . escape(<q-args>, '\^$.[?*~') . ']*\zs' . escape(<q-args>, '\^$.[?*~')

"set pastetoggle keybinding
set pastetoggle=<F2>

" Make Y consistent with D and C
map Y           y$

" Split screen
map <leader>v   :vsp<CR>

" Move between screens
map <leader>w   ^Ww
map <leader>=   ^W=
map <leader>j   ^Wj
map <leader>k   ^Wk

" Open .vimrc file in new tab. Think Command + , [Preferences...] but with Shift.
map <D-<>       :tabedit ~/.vimrc<CR>

" Reload .vimrc
map <leader>rv  :source ~/vim/vimrc<CR>

" Undo/redo - Doesn't MacVim already have this?
map <D-z>       :earlier 1<CR>
map <D-Z>       :later 1<CR>

" Auto-indent whole file
nmap <leader>=  gg=G``
map <silent> <F7> gg=G`` :delmarks z<CR>:echo "Reformatted."<CR>

" Jump to a new line in insert mode
imap <D-CR>     <Esc>o
imap <S-CR>     <Esc>o

" Fast scrolling
nnoremap <C-e>  3<C-e>
nnoremap <C-y>  3<C-y>

" File tree browser
map \           :NERDTreeToggle<CR>

" File tree browser showing current file - pipe (shift-backslash)
map \|          :NERDTreeFind<CR>

" Tab navigation shortcuts
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap H gT
nnoremap L gt
map <c-h> :tabp<CR>
map <c-l> :tabn<CR>

" Previous/next quickfix file listings (e.g. search results)
map <M-D-Down>  :cn<CR>
map <M-D-Up>    :cp<CR>
map <C-Down>    :cn<CR>
map <C-Up>      :cp<CR>
map <c-j>       :cn<CR>
map <c-k>       :cp<CR>

" Buffers
map <M-D-Left>  :bp<CR>
map <M-D-Right> :bn<CR>
map <leader>b   :FufBuffer<CR>

"indent/unindent visual mode selection with tab/shift+tab
vmap <tab> >gv
vmap <s-tab> <gv

" refresh the FuzzyFinder cache
map <leader>rf :FufRenewCache<CR>

" Ctrl P
if has("gui_macvim")
  map <leader>e   :CtrlP<CR>
  map <leader>f   :CtrlP<CR>
  map <D-N>       :CtrlP<CR>
  map <C-p>       :CtrlP<CR>
else
  map <leader>e   :FZF<CR>
  map <leader>f   :FZF<CR>
  map <leader>h   :History<CR>
  map <D-N>       :FZF<CR>
  map <C-p>       :FZF<CR>
endif

" Copy. Paste is going to be manually done with set paste, CMD v
vnoremap <C-c> :w !pbcopy<CR><CR>

" ctags with rails load path
map <leader>rt  :!rails runner 'puts $LOAD_PATH.join(" ")' \| xargs /usr/local/bin/ctags -R app/assets/javascripts<CR>
map <leader>T   :!rails runner 'puts $LOAD_PATH.join(" ")' \| xargs rdoc -f tags<CR>

" Git blame
map <leader>g   :Gblame<CR>

" Comment/uncomment lines
map <leader>/   <plug>NERDCommenterToggle

" In command-line mode, <C-A> should go to the front of the line, as in bash.
cmap <C-A> <C-B>

" Copy current file path to system pasteboard
map <silent> <D-C> :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>

" Disable middle mouse button, F1
map <MiddleMouse>   <Nop>
imap <MiddleMouse>  <Nop>
map <F1>            <Nop>
imap <F1>           <Nop>

" Easy access to the shell
map <Leader><Leader> :!

" grep current word
map <leader>a :call AgGrep()<CR>

" Visual grep current selection
vmap <leader>a :call AgVisual()<CR>

" Recalculate diff when it gets messed up.
nmap du :diffupdate<CR>

" Undotree
map <leader>u :UndotreeToggle<CR>

" Format a json file with Python's built in json.tool.
" from https://github.com/spf13/spf13-vim/blob/3.0/.vimrc#L390
nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>

" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

map <c-n> :tabe<CR>

cnoreabbrev Ack Ag

:command WQ wq
:command Wq wq
:command Q q

nmap \         <Plug>VinegarUp

" Bookmarks
map <leader>m :BookmarkAnnotate<CR>
map <leader>M :BookmarkShowAll<CR>

" Shortcuts for ALE
map <c-d> :ALENext<CR>
map <c-f> :ALEPrevious<CR>

" Ruby goto definition for Language Client and solargraph
:command RubyDef :call LanguageClient#textDocument_definition()<CR>
:command RubyRename :call LanguageClient#textDocument_rename()<CR>

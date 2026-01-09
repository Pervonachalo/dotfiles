"-----------------------------------------------------------------------------
 "Global Stuff
"-----------------------------------------------------------------------------

" Set filetype stuff to on
    set nocompatible
    syntax on                                   " подсветка синтаксиса
"	packloadall
"   syntax enable

    filetype on                                 " включить определение типа файла (~/.vim/filetype.vim)
    filetype plugin on                          " включить загрузку модулей
    filetype indent on                          " включить загрузку сценариев настройки отступов

"	map <Down> <NOP>							" отключаем перемещение при помощи клавиш со стрелками
"	map <Up> <NOP>
"	map <Left> <NOP>
"	map <Right> <NOP>


" Enable Zim Wiki Syntax
    "set syntax=zim

" Если терминал тёмный, то в vim нужно сказать:
    set background=dark
" Чтобы вернуть обратно:
"    set background=light

    set t_Co=256                                " включаем поддержку 256 цветов
"	set termctermcolors
" Устанавливаем цветовую схему: -->

    "solarized options 
"     let g:solarized_termcolors = 256
    "let g:solarized_visibility = "high"
    "let g:solarized_contrast = "high"
	" let g:solarized_termcolors=256
     " colorscheme solarized
    let g:onedark_termcolors=256
    colorscheme onedark
"	colorscheme gruvbox	



    "colorscheme desert
"     colorscheme desert256
    "colorscheme zenburn
    "colorscheme Iceberg
    "colorscheme wombat256
    "colorscheme wombat256mod
    "colorscheme hybrid
    "colorscheme euphrasia
" Устанавливаем цветовую схему: <--



    set termencoding=utf-8                  " кодировка по умолчанию
                                            " список кодировок, которые Vim будет перебирать при открытии файла
                                            " для явного указания кодировки файла используйте `:e ++enc=koi8-r foo.txt`                                            
    set fileencodings=utf-8,cp1251,usc-bom,default,latin1
    set encoding=utf-8
    set number                              " нумерация строк
"	set relativenumber
"	set cursorline         					" highlight current line
"	set cursorcolumn						" highlight current column

" " Переключение раскладки по Ctrl+^ -->
"     set keymap=russian-jcukenwin            " настраиваем переключение раскладок клавиатуры по Ctrl+^
"     set iminsert=0                          " раскладка по умолчанию для ввода - английская
"     set imsearch=0                          " раскладка по умолчанию для поиска - английская
" 	inoremap <C-l> <C-^>					" чтобы вместо Ctrl-^ нажимать	Ctrl-l
" 	highlight lCursor ctermfg=NONE ctermbg=Cyan
" 
" " Переключение раскладки по Ctrl+^ <--

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz


" Просмотр нетекстовых файлов в Vim -->
augroup MyGroup1
    au BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" - |fmt -csw78
    au BufReadPost *.doc silent %!antiword "%"
    au BufReadPost *.odt silent %!odt2txt "%"
    augroup END
" Просмотр нетекстовых файлов в Vim <--


" Проверка орфографии -->
"    setlocal spell spelllang=ru_yo,en_us
"	set spell spelllang=ru_yo,en_us
"	set spelllang=ru_yo,en_us
" Проверка орфографии <--

"set foldenable                              " выключаем фолдинг (сворачивание блоков кода)
"set foldmethod=indent                       " фолдинг по отступам
"set foldcolumn=1                            " колонка, чтобы показывать плюсики для скрытия блоков кода


" Tabstops are 4 spaces                     
set tabstop=4                           " количество пробелов для табуляции
set shiftwidth=4                        " количество пробелов в командах отступа, например >> или  <<

" set the search scan to wrap lines
set wrapscan                            " включить перенос строк
set linebreak                           " перенос строк по словам а не по буквам

" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase                          " игнорировать регистр
set smartcase                           " если искомое выражения содержит символы в верхнем регистре – ищет с учётом регистра, иначе – без учёта
 " Enable search highlighting
set hlsearch                            " включаем подсветку выражения, которое ищется в тексте (:nohlsearch отключает подсветку)
" Incrementally match the search
set incsearch                           " поиск по набору текста
 
" set the forward slash to be the slash of note.  Backslashes suck
set shellslash

" Make command line two lines high " высота командной строки
set cmdheight=1

set autoindent                              " автоотступ

" set visual bell -- i hate that damned beeping
set visualbell

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
" не выгружать буфер, когда переключаемся на другой
" это позволяет редактировать несколько файлов в один
" и тот же момент без необходимости сохранения каждый раз,
" когда переключаешься между ними
set hidden

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=ces$

"" Автоматически перечитывать конфигурацию VIM после сохранения
augroup MyGroup
autocmd! bufwritepost $MYVIMRC source $MYVIMRC
augroup END


"========
"проверить как собран vim, набрав команду:
"vim --version | grep clipboard

" При копировании добавить в иксовый буфер если vim собран с -clipboard, то:
"nmap yy yy:silent .w !xclip
"vmap y y:silent '<,'> w !xclip

" или если vim собран с +clipboard
" использовать иксовый буфер как основной
"set clipboard=unnamed " во избежание лишней путаницы использовать системный буфер обмена вместо буфера Vim
"set clipboard=unnamed,exclude:cons\\\|linux
"vmap <F2> "+y

"========




" Don't update the display while executing macros
set lazyredraw

" Show the current command in the lower right corner
set showcmd

" Show the current mode
set showmode

" Hide the mouse pointer while typing
set mousehide                           " скрывать мышь, когда печатаем


" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"      "," key and the "d" key.  If the "d" key isn't pressed before the
"      timeout expires, one of two things happens: The "," command is executed
"      if there is one (which there isn't) or the command aborts.
set timeoutlen=500

" Keep some stuff in the history
set history=128 " хранить больше истории команд

set undolevels=2048 " хранить историю изменений числом N


" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8                             " минимальное количество строк при скроле

" Allow the cursor to go in to "invalid" places
set virtualedit=all

" These things start comment lines
set comments=sl:/*,mb:\ *,ex:\ */,O://,b:#,:%,:XCOMM,n:>,fb:-

" Disable encryption (:X)
set key=

" Make the command-line completion better
set wildmenu                                    " показывать все возможные кандидаты для выбора при авто-завершении команд в командной строке
set wildcharm=<TAB>
set wildmode=list:longest,full                  " вывести весь список сразу доступных вариантов, а затем перебором

augroup MyGroup2
 au BufNewFile,BufRead *conkyrc* set filetype=conkyrc
 augroup END

" Вставлять скелет шаблона в созданный файл, работает только при создании файла
" через команду :е
augroup MyGroup3
autocmd! BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e
augroup END
" autocmd BufNewFile *.cpp r ~/.vim/skeleton/template.cpp

if empty(glob('~/.vim/autoload/plug.vim'))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'altercation/vim-colors-solarized'
" Plug 'itchyny/lightline.vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree' 
" Plug 'ycm-core/YouCompleteMe' " старый плагин
Plug 'valloric/youcompleteme'
" Plug 'lervag/vimtex'
Plug 'joanrivera/vim-zimwiki-syntax'
Plug 'jakykong/vim-zim'
" Plug 'flazz/vim-colorschemes'"Почти 1000 тем для Вима
" Plug 'xolox/vim-colorscheme-switcher' " Переключатель для этих и других тем
" Plug 'xolox/vim-misc'  " Плагин для переключателя тем
Plug 'jiangmiao/auto-pairs' "Insert or delete brackets, parens, quotes in pair. Вставляет или удаляет парные кавычки, скобки и тп. 
Plug 'jceb/vim-orgmode'
" Plug 'rip-rip/clang_complete'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
"Plug 'ryanoasis/vim-devicons'
Plug 'qpkorr/vim-renamer'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-repeat'

Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'
Plug 'farmergreg/vim-lastplace'
Plug 'ctrlpvim/ctrlp.vim' " Full path fuzzy file, buffer, mru, tag, ... finder for Vim. Нечёткий поиск 
Plug 'ap/vim-css-color'
Plug 'joshdick/onedark.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


"		Plugins settings:
"
" "for 'itchyny/lightline.vim'
" let g:lightline = {
"       \ 'colorscheme': 'solarized',
" 	  \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'FugitiveHead'
"       \ },
"       \ }

"for 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"for 'scrooloose/nerdtree' 
" autocmd vimenter * NERDTree
" map <C-n> :NERDTreeToggle<CR>
nnoremap <SPACE> <Nop>
let mapleader=' '
nnoremap <leader>e :NERDTreeFocus<CR>
nnoremap <leader>e :NERDTreeToggle<CR>
" autocmd VimEnter * NERDTree 
let NERDTreeShowHidden=1


"for 'valloric/youcompleteme'

" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_use_ultisnips_completer = 1
" let g:ycm_key_list_select_completion=[]
" let g:ycm_key_list_previous_completion=[]
" let g:ycm_clangd_binary_path = '/usr/lib/llvm-7/bin/clang' 
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/youcompleteme/ycm_extra_conf.py '
"let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd' 

"for 'rip-rip/clang_complete'
" let g:clang_library_path='/usr/lib/llvm-7/lib'
 

"for vim-airline
 " let g:airline#extensions#tabline#enabled = 1
 " let g:airline_powerline_fonts = 1


"for vim-airline-themes
" let g:airline_theme='solarized'

"for 'jakykong/vim-zim'установить язык, иначе меню на французском показывает
let g:zim_wiki_lang='en'

" ========================================================================
"=== Всегда показывать строку статуса tell VIM to always put a status line in, even if there is only one window
set laststatus=2

" status bar colors
augroup MyGroup4
au InsertEnter * hi statusline ctermfg=black ctermbg=darkblue
au InsertLeave * hi statusline ctermfg=black ctermbg=Grey
hi statusline ctermfg=black ctermbg=Grey
augroup END
" hi StatusLine ctermbg=whatever ctermfg=whatever



"" Формат строки состояния
"позиция курсора (строка,кол-во строк в файле, процент прочитанного в файле, символ в строке);буфера обмена, коды символа под курсором;
" fileformat - формат файла (unix, dos); fileencoding - кодировка файла; encoding - кодировка терминала; TYPE - тип файла,
" 
" Set the status line the way i like it
" set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]\ Format:%{&fileformat}\ File:%{&fileencoding}\ Enc:%{&encoding}\ Type=%y
set statusline=%f\ %m\ %r\ %{gitbranch#name()}\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]\ Format:%{&fileformat}\ File:%{&fileencoding}\ Enc:%{&encoding}\ Type=%y
" set stl=%#PmenuSel#\ %{StatuslineGit()}\ %#LineNr#\ %f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]\ Format:%{&fileformat}\ File:%{&fileencoding}\ Enc:%{&encoding}\ Type=%y
" set stl=%{StatuslineGit()}\ %f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]\ Format:%{&fileformat}\ File:%{&fileencoding}\ Enc:%{&encoding}\ Type=%y
 
" set statusline=
"  set statusline+=%#PmenuSel#
"  set statusline+=%{StatuslineGit()}
"  set statusline+=%{gitbranch#name()}
"  set statusline+=%#LineNr#
"  set statusline+=\ %f
"  set statusline+=%m\
"  set statusline+=%=
"  set statusline+=%#CursorColumn#
"  set statusline+=\ %y
"  set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
"  set statusline+=\[%{&fileformat}\]
"  set statusline+=\ %p%%
"  set statusline+=\ %l:%c
"  set statusline+=\

" ========================================================================


packadd termdebug
let g:termdebug_wide=1

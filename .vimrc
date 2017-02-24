"定义快捷键的前缀，即<Leader>
let mapleader=";"

" vundle 环境设置
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
"Plugin 'Shougo/neocomplcache.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'godlygeek/tabular'              " 等号对齐
Plugin 'vim-scripts/indexer.tar.gz'     " 自动生成ctags标签
Plugin 'tpope/vim-surround'     " 快速更改括号，引号
Plugin 'jiangmiao/auto-pairs'   " 快速括号引号优化输入
Plugin 'mattn/emmet-vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
Plugin 'c9s/perlomni.vim'
Plugin 'vim-scripts/phd'
Plugin 'Lokaltog/vim-powerline'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'kshenoy/vim-signature'
Plugin 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines'
Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/DfrankUtil'
Plugin 'vim-scripts/vimprj'
Plugin 'dyng/ctrlsf.vim'
Plugin 'terryma/vim-multiple-cursors'   " 多光标编辑
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/DrawIt'
Plugin 'SirVer/ultisnips'
Plugin 'derekwyatt/vim-protodef'
Plugin 'scrooloose/nerdtree'
Plugin 'fholgado/minibufexpl.vim'
"Plugin 'gcmt/wildfire.vim'     " 结对符号选择
Plugin 'sjl/gundo.vim'
Plugin 'Lokaltog/vim-easymotion'
"Plugin 'suan/vim-instant-markdown'  " 外国人写的md预览插件
Plugin 'lilydjwg/fcitx.vim'
Plugin 'iamcco/mathjax-support-for-mkdp'
Plugin 'iamcco/markdown-preview.vim'    " 中国人写的md预览插件，界面漂亮
" 插件列表结束
call vundle#end()
filetype plugin indent on

" 开启文件类型侦测
filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on


"{{{================自己的一些设置==================
"Quickly Run
""""""""""""""""""""""
command! TestRun call CompileRunGcc()
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!clang++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!clang++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        "        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'perl'
        exec "perl -w %"
        exec "!time perl % &"
    endif
endfunc

"文件编码格式检测检测--------
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" 自动加载
set autoread

" 自动保存
au FocusLost * :up

" windows 下 粘贴,剪切----------
behave mswin

" 开启实时搜索功能
set incsearch
" 搜索时大小写不敏感
set ignorecase
" 关闭兼容模式
set nocompatible
" vim 自身命令行模式智能补全
set wildmenu


" 让配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
"}}}

"........................ 定义快捷"{{{
"Omni补全快捷键
inoremap <leader>; <C-x><C-o>

" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至 vim
nmap <Leader>p "+p
" 定义快捷键关闭当前分割窗口
nmap <Leader>q :q<CR>
" 跳转至右方的窗口
nnoremap <C-l> <C-W>l
" 跳转至左方的窗口
nnoremap <C-h> <C-W>h
" 跳转至上方的子窗口
nnoremap <C-k> <C-W>k
" 跳转至下方的子窗口
nnoremap <C-j> <C-W>j
" 定义快捷键在结对符之间跳转
nmap <Leader>M %

" 插入模式光标移动优化
inoremap ì <RIGHT>
inoremap è <LEFT>
".................................""}}}

" 配色方案
if has('gui_running')
  set background=dark
  colorscheme solarized
  "colorscheme desert
  "colorscheme molokai
  "colorscheme phd
  "set lines=40 columns=141
else
  set background=dark
  colorscheme molokai
  "colorscheme desert
  "colorscheme phd
endif


" 设置状态栏主题风格
let g:Powerline_colorscheme='solarized256'

" 光标移动到底部时候保持一定距离
set scrolloff=3  

" ========================= Markdown支持=========="{{{
" 高亮
let g:vim_markdown_frontmatter=1

let g:mkdp_path_to_chrome = "google-chrome"
" 设置 chrome 浏览器的路径（或是启动 chrome（或其他现代浏览器）的命令）

let g:mkdp_auto_start = 0
" 设置为 1 可以在打开 markdown 文件的时候自动打开浏览器预览，只在打开
" markdown 文件的时候打开一次

let g:mkdp_auto_open = 0
" 设置为 1 在编辑 markdown 的时候检查预览窗口是否已经打开，否则自动打开预
" 览窗口
let g:mkdp_auto_close = 1
" 在切换 buffer 的时候自动关闭预览窗口，设置为 0 则在切换 buffer 的时候不
" 自动关闭预览窗口
let g:mkdp_refresh_slow = 0
" 设置为 1 则只有在保存文件，或退出插入模式的时候更新预览，默认为 0，实时
" 更新预览
let g:mkdp_command_for_global = 0
" 设置为 1 则所有文件都可以使用 MarkdownPreview 进行预览，默认只有 markdown
" 文件可以使用改命令

"快捷键
nmap <silent> <F8> <Plug>MarkdownPreview        " 普通模式
imap <silent> <F8> <Plug>MarkdownPreview        " 插入模式
nmap <silent> <F9> <Plug>StopMarkdownPreview    " 普通模式
imap <silent> <F9> <Plug>StopMarkdownPreview    " 插入模式
" =============================================="}}}


" =============界面============="{{{

" 禁止显示滚动条
"set guioptions-=l
"set guioptions-=L
"set guioptions-=r
"set guioptions-=R
" 禁止显示菜单和工具条
set guioptions-=m
set guioptions-=T


" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
set ruler

" 开启行号显示
set relativenumber
set number

" 高亮显示当前行/列
set cursorline
set cursorcolumn
" 高亮显示搜索结果
set hlsearch

" 禁止折行
set wrap
autocmd FileType c,cpp,java,perl,pytho set nowrap



" 设置 gvim 显示字体
set guifont=YaHei\ Consolas\ Hybrid\ 13.5

" ============================="}}}


" ============ 代码分析 ============"{{{

" *.cpp 和 *.h 间切换
nmap <silent> <Leader>sw :FSHere<cr>

" 开启语法高亮功能
syntax enable
" 允许用指定语法高亮配色方案替换默认方案
syntax on

" 缩进----
" 自适应不同语言的智能缩进
filetype indent on
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4

" 可视化缩进------------
" 随 vim 自启动
let g:indent_guides_enable_on_vim_startup=1
" 从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
" 色块宽度
let g:indent_guides_guide_size=1
" 快捷键 i 开/关缩进可视化
:nmap <silent> <Leader>i <Plug>IndentGuidesToggle


" 代码折叠------------------
command! Foldmaker set foldmethod=marker
command! Foldsyn set foldmethod=syntax
"set foldmethod=marker      " 自定义折叠
"set foldmethod=diff        " 未更改文本折叠
"set foldmethod=manual      " 自定义
"set foldmethod=indent      " 基于缩进
set foldmethod=syntax       " 基于语法进行代码折叠
" 启动 vim 时关闭折叠代码
set nofoldenable

" ================================="}}}


" =============== 文件目录 ================="{{{

" 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
nmap <Leader>fl :NERDTreeToggle<CR>
" 设置NERDTree子窗口宽度
let NERDTreeWinSize=32
" 设置NERDTree子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1


" 显示/隐藏 MiniBufExplorer 窗口
map <Leader>bl :MBEToggle<cr>
" buffer 切换快捷键
map <C-Tab> :MBEbn<cr>
map <C-S-Tab> :MBEbp<cr>

function 


" ==================查找====================
let g:ackprg = 'ag --nogroup --nocolor --column'
" 使用 ctrlsf.vim 插件在工程内全局查找光标所在关键字，设置快捷键。快捷键速记法：search in project
let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "m-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "mda",
        \ 'PurgeMarkers'       :  "m<BS>",
        \ 'GotoNextLineAlpha'  :  "']",
        \ 'GotoPrevLineAlpha'  :  "'[",
        \ 'GotoNextSpotAlpha'  :  "`]",
        \ 'GotoPrevSpotAlpha'  :  "`[",
        \ 'GotoNextLineByPos'  :  "]'",
        \ 'GotoPrevLineByPos'  :  "['",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "[+",
        \ 'GotoPrevMarker'     :  "[-",
        \ 'GotoNextMarkerAny'  :  "]=",
        \ 'GotoPrevMarkerAny'  :  "[=",
        \ 'ListLocalMarks'     :  "ms",
        \ 'ListLocalMarkers'   :  "m?"
        \ }

noremap <Leader>sp :CtrlSF<CR>
let g:ctrlsf_ackprg = 'ag' 
" ===========================================


"................tabbar
" 设置 tagbar 子窗口的位置出现在主编辑区的左边 
let tagbar_left=1 
" 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
nnoremap <Leader>tl :TagbarToggle<CR> 
" 设置标签子窗口的宽度 
let tagbar_width=32 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" 设置 ctags 对哪些代码标识符生成标签
let g:tagbar_type_cpp = {
    \ 'kinds' : [
         \ 'c:classes:0:1',
         \ 'd:macros:0:1',
         \ 'e:enumerators:0:0', 
         \ 'f:functions:0:1',
         \ 'g:enumeration:0:1',
         \ 'l:local:0:1',
         \ 'm:members:0:1',
         \ 'n:namespaces:0:1',
         \ 'p:functions_prototypes:0:1',
         \ 's:structs:0:1',
         \ 't:typedefs:0:1',
         \ 'u:unions:0:1',
         \ 'v:global:0:1',
         \ 'x:external:0:1'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
\ }

" perl的tagbar格式
let g:tagbar_type_perl = {
    \ 'ctagstype'   : 'Perl',
    \ 'kinds' : [
        \ 'p:packages:1:0',
        \ 'u:uses:1:0',
        \ 'r:requires:1:0',
        \ 'e:extends',
        \ 'w:roles',
        \ 'o:ours:1:0',
        \ 'c:constants:1:0',
        \ 'f:formats:1:0',
        \ 'a:attributes',
        \ 's:subroutines',
        \ 'x:around:1:0',
        \ 'l:aliases',
        \ 'd:pod:1:0',
    \ ],
\ }


" 正向遍历同名标签
nmap <Leader>tn :tnext<CR>
" 反向遍历同名标签
nmap <Leader>tp :tprevious<CR>

" 设置插件 indexer 调用 ctags 的参数
" 默认 --c++-kinds=+p+l，重新设置为 --c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v
" 默认 --fields=+iaS 不满足 YCM 要求，需改为 --fields=+iaSl
let g:indexer_ctagsCommandLineOptions="--c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+iaSl --extra=+q"

"Omni 补全
let OmniCpp_DefaultNamespaces = ["_GLIBCXX_STD"]
"set tags+=/usr/include/c++/4.8/stdcpp.tags
"set tags+=/usr/include/sys.tags
" 引入 C++ 标准库tags
set tags+=/data/misc/software/misc./vim/stdcpp.tags


".....................YCM补全......模板补全
" UltiSnips 的 tab 键与 YCM 冲突，重新设定

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<C-b>"
let g:UltiSnipsJumpBackwardTrigger="<C-z>"

" 模板文件位置 ～/.vim/bundle/ultiSnips/mysnippets
let g:UltiSnipsSnippetDirectories=["mysnippets"] 

"youcompleteme  默认tab  s-tab 和 ultisnips 冲突
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;
let g:ycm_key_invoke_completion = '<M-;>'

nnoremap <leader>jc :YcmCompleter GoToDeclaration<CR>
" 只能是 #include 或已打开的文件
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>

" 全局 .ycm_extra_conf.py 位置
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'  
:command! Initycm :!cp ~/.vim/.ycm_extra_conf.py . 
" YCM 补全菜单配色
" 菜单
highlight Pmenu ctermfg=2 ctermbg=black guifg=#005f87 guibg=#EEE8D5
" 选中项
highlight PmenuSel ctermfg=2 ctermbg=LightBlue guifg=#AFD700 guibg=#106900
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf=0
" 开启 YCM 标签补全引擎
let g:ycm_collect_identifiers_from_tags_files=1
" 引入 C++ 标准库tags
set tags+=/data/misc/software/misc./vim/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=2
" 语法关键字补全         
let g:ycm_seed_identifiers_with_syntax=1
" 开启 YCM 标签引擎
let g:ycm_collect_identifiers_from_tags_files=1
" YCM 错误提醒
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nmap <leader>y :YcmDiags<CR>

let g:ycm_cache_omnifunc = 1
let g:ycm_use_ultisnips_completer = 1



" 设置在下面几种格式的文件上屏蔽ycm
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'pandoc' : 1,
      \ 'infolog' : 1,
      \ 'mail' : 1
      \}

"设置关健字触发补全
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.', '(', '[', '&'],
  \   'objc' : [' ', '->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl,perl6' : ['->','$','@','&','\','::'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }

"....................cpp 接口与 代码文件同步
" 设置 pullproto.pl 脚本路径
let g:protodefprotogetter='~/.vim/bundle/vim-protodef/pullproto.pl'
" 成员函数的实现顺序与声明顺序一致
let g:disable_protodef_sorting=1

"..........emmet...html 快速填充 插件
let g:user_emmet_mode='inv'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"修改触发键，一般不建议
let g:user_emmet_leader_key='<C-y>'     " 进入emmet监听状态
"let g:user_emmet_expandabbr_key = '<Tab>'  " 展开键，默认是 英文逗号

" 自定义响应的文件类型
let g:user_emmet_settings = {
\ 'php' : {
\ 'extends' : 'html',
\ 'filters' : 'c',
\ },
\ 'xml' : {
\ 'extends' : 'html',
\ },
\ 'haml' : {
\ 'extends' : 'html',
\ },
\}


".............等号对齐工具
if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:\zs<CR>
    vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" 表格自动对齐函数, 暂时不打算启用在markdown上
autocmd FileType markdown inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
"----------------


"..............多光标编辑 vim-multiple-cursors
" Default mapping
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-p>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'

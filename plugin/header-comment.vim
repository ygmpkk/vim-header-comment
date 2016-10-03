" 
"  Copyright (C) 2012 Hapida AB
" 
"  File:    header-comment.vim
"  Author:  Björn-Egil Dahlberg
"  Created: 2012-09-22
"

let s:save_cpo = &cpo
set cpo&vim

" 是否自动插入到文件头部
let g:header_comment_auto_insert = get(g:, 'header_comment_auto_insert', 1)
" 作者
let g:header_comment_author = get(g:, 'header_comment_author', '')
" 版权
let g:header_comment_copyright = get(g:, 'header_comment_copyright', '')

let s:commentMap = {
    \ 'erl': { 'left': '#' },
    \ 'python': { 'begin': '# ', 'next': '# ', 'end': '# '},
    \ 'shell': { 'begin': '# ', 'next': '# ', 'end': '# '},
    \ 'c': { 'begin': '/* ', 'next': ' *', 'end': ' */' },
    \ 'java': { 'begin': '/* ', 'next': ' *', 'end': ' */' },
    \ 'objective-c': { 'begin': '/* ', 'next': ' *', 'end': ' */' },
    \ 'javascript': { 'begin': '/* ', 'next': ' *', 'end': ' */' }
    \ }
let g:header_comment_map = s:commentMap

if exists("g:header_comment_custom_map")
    call extend(s:commentMap, g:header_comment_custom_map)
endif

" Header
" fc = firstcomment,    ex. /*
" mc = middle comments  ex.  *
" lc = last comment     ex.  */
function! MakeFileHeader(fc,mc,lc)
    set paste
    let s:author = ""
    let s:copyright = ""
    if exists('g:header_comment_author')
        let s:author = g:header_comment_author
    else
        echo "g:header_comment_author is not defined in .vimrc"
    end
    if exists('g:header_comment_copyright')
        let s:copyright = g:header_comment_copyright
    else
        echo "g:header_comment_copyright is not defined in .vimrc"
    end

    let s:comment  = a:fc . "\r"
    let s:comment .= a:mc . " Copyright (C) " . strftime("%Y") . " " . s:copyright . "\r"
    let s:comment .= a:mc . "\r"
    let s:comment .= a:mc . " File:    " . expand('%:t') . "\r"
    let s:comment .= a:mc . " Author:  " . s:author . "\r"
    let s:comment .= a:mc . " Created: " . strftime("%Y-%m-%d") . "\r"
    let s:comment .= a:lc . "\r"
    echo s:comment
    exec "normal i" . s:comment
    set nopaste
endfunction

function! AutoInsertByFileType(filetype)
    let ft = a:filetype
    if ft =~ '\.' && !has_key(s:commentMap, ft)
        let filetypes = split(a:filetype, '\.')
        for i in filetypes
            if has_key(s:commentMap, i)
                let ft = i
                break
            endif
        endfor
    endif

    if has_key(s:commentMap, ft)
        let comment = s:commentMap[ft]
        let leftComment = comment['begin']
        let centerComment = comment['next']
        let rightComment = comment['end']
        call MakeFileHeader(leftComment, centerComment, rightComment)
    endif
endfunction

command! -nargs=0 -complete=customlist,AutoInsertByFileType HeaderCommentInsert :call AutoInsertByFileType(&filetype)

augroup HeaderComment
    autocmd!
    if g:header_comment_auto_insert == 1
        let cmd = 'autocmd BufNewFile *.%s call AutoInsertByFileType(%s)'
        exec printf(cmd, &filetype, &filetype)
    endif
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

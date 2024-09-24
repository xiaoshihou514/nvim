setlocal shiftwidth=2
setlocal tabstop=2
setlocal norelativenumber

function! NdpGotoLine()
    let l:word = expand('<cword>')

    " Check if the word is a number
    if l:word !~ '^\d\+$'
        echo "Word under the cursor is not a number."
        return
    endif

    let l:linenr = str2nr(l:word)
    if l:linenr < 0
        echo "Invalid line number: " . l:linenr
        return
    endif

    let l:i = 0
    let l:j = 0
    normal m'
    while l:i < l:linenr
        let l:j += 1
        if l:j > line('$')
            echo "Line number out of bound: " . l:linenr
            return
        endif

        let l:line = getline(l:j)
        if l:line !~ '^\s*--.*' && l:line !~ '^\s*$'
            let l:i += 1
        endif
    endwhile

    execute l:j
endfunction

map <Plug>NdpGotoLine :call NdpGotoLine()<cr>
nnoremap <buffer> gd <Plug>NdpGotoLine

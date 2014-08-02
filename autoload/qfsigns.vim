let s:save_cpo = &cpo
set cpo&vim

let g:qfsigns#Enabled   = ! exists('g:qfsigns#Enabled')   ? 1 : g:qfsigns#Enabled
let g:qfsigns#AutoJump  = ! exists('g:qfsigns#AutoJump')  ? 0 : g:qfsigns#AutoJump
let g:qfsigns#ErrorFlag = ! exists('g:qfsigns#ErrorFlag') ? 0 : g:qfsigns#ErrorFlag

function! qfsigns#Setup() "{{{
    let g:qfsigns#Config = {
    \    'id'    : '5050',
    \    'name'  : 'QFError',
    \    'linehl': 'SpellBad',
    \    'text'  : '>>',
    \    'texthl': 'SpellBad',}
    execute 'sign define '.get(g:qfsigns#Config,'name')
    \    .' linehl='.      get(g:qfsigns#Config,'linehl')
    \    .' texthl='.      get(g:qfsigns#Config,'texthl')
    \    .' text='.        get(g:qfsigns#Config,'text')
    lockvar! g:qfsigns#Config
endfunction "}}}

function! qfsigns#Qfsigns(clearonly) "{{{
    "Setup
    if !exists('g:qfsigns#Config')
        call qfsigns#Setup()
    endif
    "Remove signs
    execute 'sign unplace '.get(g:qfsigns#Config,'id').' buffer='.winbufnr(0)
    "Only delete signs
    if g:qfsigns#Enabled == 0 || a:clearonly == 1
        return
    endif
    "Setting signs
    let a:bufnr            = bufnr('%')
    let a:qfsignsErrorCheck = 0
    for a:qfrow in getqflist()
        if a:qfrow.bufnr == a:bufnr
            if a:qfrow.lnum > 0
                execute 'sign place '.get(g:qfsigns#Config,'id')
                \    .' line='.       a:qfrow.lnum
                \    .' name='.       get(g:qfsigns#Config,'name')
                \    .' buffer='.     winbufnr(0)
                let a:qfsignsErrorCheck = 1
            endif
        endif
    endfor
    " Cursor is moved at line setting sign.
    if a:qfsignsErrorCheck == 1
        if g:qfsigns#AutoJump == 1
            QfsingsJunmp
        elseif g:qfsigns#AutoJump == 2
            if g:qfsigns#ErrorFlag == 0
                split
            endif
            QfsingsJunmp
        endif
        let g:qfsigns#ErrorFlag = 1
    else
        let g:qfsigns#ErrorFlag = 0
    endif
endfunction "}}}

function! qfsigns#Jump() "{{{
    if g:qfsigns#ErrorFlag == 1
        execute 'sign jump '.get(g:qfsigns#Config,'id').' buffer='.winbufnr(0)
    endif
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo


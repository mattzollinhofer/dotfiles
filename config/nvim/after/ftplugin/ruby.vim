nnoremap <buffer> <C-]> <C-]>

function! s:GfWithLogFallback()
  try
    normal! gf
  catch
    let log_line = search('^## log: ', 'bn')
    let line_content = getline(log_line)
    let log_path = matchstr(line_content, '^## log: \zs.*')
    let file_dir = expand('%:p:h')
    let full_path = simplify(file_dir . '/' . log_path)
    execute 'edit ' . fnameescape(full_path)
  endtry
endfunction
nnoremap <buffer> gf :call <SID>GfWithLogFallback()<CR>

"" Author: vdeurzen <tim@kompiler.org>, w0rp <devw0rp@gmail.com>,
"" gagbo <gagbobada@gmail.com>
"" Description: clang-tidy linter for cpp files
"
"call ale#Set('cpp_clangtidy_executable', 'clang-tidy')
"" Set this option to check the checks clang-tidy will apply.
"call ale#Set('cpp_clangtidy_checks', [])
"" Set this option to manually set some options for clang-tidy to use as compile
"" flags.
"" This will disable compile_commands.json detection.
"call ale#Set('cpp_clangtidy_options', '')
"" Set this option to manually set options for clang-tidy directly.
"call ale#Set('cpp_clangtidy_extra_options', '')
"call ale#Set('c_build_dir', '')
"
"function! ale_linters#cpp#clangtidy#GetCommand(buffer, output) abort
"    let l:checks = join(ale#Var(a:buffer, 'cpp_clangtidy_checks'), ',')
"    let l:build_dir = ale#c#GetBuildDirectory(a:buffer)
"    let l:options = ''
"
"    " Get the extra options if we couldn't find a build directory.
"    if empty(l:build_dir)
"        let l:options = ale#Var(a:buffer, 'cpp_clangtidy_options')
"        let l:cflags = ale#c#GetCFlags(a:buffer, a:output)
"        let l:options .= !empty(l:options) ? ale#Pad(l:cflags) : l:cflags
"    endif
"
"    " Get the options to pass directly to clang-tidy
"    let l:extra_options = ale#Var(a:buffer, 'cpp_clangtidy_extra_options')
"
"    return '%e'
"    \   . (!empty(l:checks) ? ' -checks=' . ale#Escape(l:checks) : '')
"    \   . (!empty(l:extra_options) ? ' ' . ale#Escape(l:extra_options) : '')
"    \   . ' %s'
"    \   . (!empty(l:build_dir) ? ' -p ' . ale#Escape(l:build_dir) : '')
"    \   . (!empty(l:options) ? ' -- ' . l:options : '')
"endfunction
"
"call ale#linter#Define('cpp', {
"\   'name': 'clangtidy',
"\   'output_stream': 'stdout',
"\   'executable': {b -> ale#Var(b, 'cpp_clangtidy_executable')},
"\   'command': {b -> ale#c#RunMakeCommand(b, function('ale_linters#cpp#clangtidy#GetCommand'))},
"\   'callback': 'ale#handlers#gcc#HandleGCCFormat',
"\   'lint_file': 1,
"\})
" The vim-scripts above will invalidate the clang-tidy, I don't know the
" reason

call ale#Set('cpp_clangtidy_executable', 'clang-tidy')
call ale#Set('cpp_clangtidy_options', '')

function! ale_linters#cpp#clangtidy#GetCommand(buffer) abort
    let l:cd_command = 'clang-tidy'
    let l:compile_commands_option = ale#handlers#cppcheck#GetCompileCommandsOptions(a:buffer)
    let l:buffer_path_include = ''

    return l:cd_command
    \   . ale#Pad(ale#Var(a:buffer, 'cpp_clangtidy_options'))
    \   . l:buffer_path_include
    \   . ' %t'
endfunction

call ale#linter#Define('cpp', {
\   'name': 'clangtidy',
\   'output_stream': 'both',
\   'executable': {b -> ale#Var(b, 'cpp_clangtidy_executable')},
\   'command': function('ale_linters#cpp#clangtidy#GetCommand'),
\   'callback': 'ale#handlers#gcc#HandleGCCFormatWithIncludes',
\})

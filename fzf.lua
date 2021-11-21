--------------------------------------------------------------------------------
-- FZF integration for Clink.
--
-- Clink is available at https://chrisant996.github.io/clink
-- FZF is available from https://nicedoc.io/junegunn/fzf
--
-- To use this:
--
--  1.  Copy this script into your Clink scripts directory.
--
--  2.  Either put fzf.exe in a directory listed in the system PATH environment
--      variable, or run 'clink set fzf.exe_location <directoryname>' to tell
--      Clink where to find fzf.exe.
--
--  3.  The default key bindings are as follows, when using Clink v1.2.46 or
--      higher:
--[[

# Default key bindings for fzf with Clink.
"\C-t":        "luafunc:fzf_file"       # Ctrl+T lists files recursively; choose one or multiple to insert them.
"\C-r":        "luafunc:fzf_history"    # Ctrl+R lists history entries; choose one to insert it.
"\M-c":        "luafunc:fzf_directory"  # Alt+C lists subdirectories; choose one to 'cd /d' to it.
"\M-b":        "luafunc:fzf_bindings"   # Alt+B lists key bindings; choose one to invoke it.
"\e[27;5;32~": "luafunc:fzf_complete"   # Ctrl+Space uses fzf to filter match completions.

]]
--  4.  Optional:  You can use your own custom key bindings if you want.
--      Run 'clink set fzf.default_bindings false' and add key bindings to
--      your .inputrc file manually.  The default key bindings are listed
--      above in .inputrc format for convenience.
--
--  5.  Optional:  You can set the following environment variables to
--      customize the behavior:
--
--          FZF_CTRL_T_OPTS     = fzf options for fzf_file() function.
--          FZF_CTRL_R_OPTS     = fzf options for fzf_history() function.
--          FZF_ALT_C_OPTS      = fzf options for fzf_directory() function.
--          FZF_BINDINGS_OPTS   = fzf options for fzf_bindings() function.
--          FZF_COMPLETE_OPTS   = fzf options for fzf_complete() function.
--
--          FZF_CTRL_T_COMMAND  = command to run for collecting files for fzf_file() function.
--          FZF_ALT_C_COMMAND   = command to run for collecting directories for fzf_directory() function.

--------------------------------------------------------------------------------
-- Compatibility check.
if not io.popenrw then
    print('fzf.lua requires a newer version of Clink; please upgrade.')
    return
end

--------------------------------------------------------------------------------
-- Settings available via 'clink set'.

settings.add('fzf.height', '40%', 'Height to use for the --height flag')
settings.add('fzf.exe_location', '', 'Location of fzf.exe if not on the PATH')

if rl.setbinding then

    settings.add('fzf.default_bindings', true, 'Use default key bindings', 'If the default key bindings interfere with your own, you can turn off the\ndefault key bindings and add bindings manually to your .inputrc file.\n\nChanging this takes effect for the next session.')

    if settings.get('fzf.default_bindings') then
        rl.setbinding([["\C-t"]], [["luafunc:fzf_file"]])
        rl.setbinding([["\C-r"]], [["luafunc:fzf_history"]])
        rl.setbinding([["\M-c"]], [["luafunc:fzf_directory"]])
        rl.setbinding([["\M-b"]], [["luafunc:fzf_bindings"]])
        rl.setbinding([["\e[27;5;32~"]], [["luafunc:fzf_complete"]])
    end

end

--------------------------------------------------------------------------------
-- Helpers.

local diag = false
local fzf_complete_intercept = false

local function get_fzf(env)
    local height = settings.get('fzf.height')
    local command = settings.get('fzf.exe_location')
    if os.expandenv and command then
        -- Expand so that os.getshortpathname() can work even when envvars are
        -- present.
        command = os.expandenv(command)
    end
    if not command or command == '' then
        command = 'fzf.exe'
    else
        -- CMD.exe cannot use pipe redirection with a quoted program name, so
        -- try to use a short name.
        local short = os.getshortpathname(command)
        if short then
            command = short
        end
    end
    if command and command ~= '' and height and height ~= '' then
        command = command..' --height '..height
    end
    if env then
        local options = os.getenv(env)
        if options then
            command = command..' '..options
        end
    end
    return command
end

local function get_clink()
    local clink_alias = os.getalias('clink')
    if not clink_alias or clink_alias == '' then
        return ''
    end
    return clink_alias:gsub(' $[*]', '')
end

local function replace_dir(str, line_state)
    local dir = '.'
    if line_state:getwordcount() > 0 then
        local info = line_state:getwordinfo(line_state:getwordcount())
        if info then
            local word = line_state:getline():sub(info.offset, line_state:getcursor())
            if word and #word > 0 then
                dir = word
            end
        end
    end
    return str:gsub('$dir', dir)
end

--------------------------------------------------------------------------------
-- Functions for use with 'luafunc:' key bindings.

function fzf_complete(rl_buffer)
    fzf_complete_intercept = true
    rl.invokecommand('complete')
    if fzf_complete_intercept then
        rl_buffer:ding()
    end
    fzf_complete_intercept = false
    rl_buffer:refreshline()
end

function fzf_history(rl_buffer)
    local clink_command = get_clink()
    if #clink_command == 0 then
        rl_buffer:ding()
        return
    end

    -- Build command to get history for the current Clink session.
    local history = clink_command..' --session '..clink.getsession()..' history --bare'
    if diag then
        history = history..' --diag'
    end

    -- This intentionally does not use '--query' because that isn't safe:
    -- Depending on what the user has typed so far, passing it as an argument
    -- may cause the command to interpreted differently than expected.
    -- E.g. suppose the user typed:     "pgm.exe & rd /s
    -- Then fzf would be invoked as:    fzf.exe --query""pgm.exe & rd /s"
    -- And since the & is not inside quotes, the 'rd /s' command gets actually
    -- run by mistake!
    local r = io.popen(history..' | '..get_fzf("FZF_CTRL_R_OPTS")..' -i --tac')
    if not r then
        rl_buffer:ding()
        return
    end

    local str = r:read('*all')
    str = str and str:gsub('[\r\n]', '') or ''
    r:close()

    -- If something was selected, insert it.
    if #str > 0 then
        rl_buffer:beginundogroup()
        rl_buffer:remove(0, -1)
        rl_buffer:insert(str)
        rl_buffer:endundogroup()
    end

    rl_buffer:refreshline()
end

function fzf_file(rl_buffer, line_state)
    local ctrl_t_command = os.getenv('FZF_CTRL_T_COMMAND')
    if not ctrl_t_command then
        ctrl_t_command = 'dir /b /s /a:-s $dir'
    end

    ctrl_t_command = replace_dir(ctrl_t_command, line_state)

print('"'..ctrl_t_command..'"')
    local r = io.popen(ctrl_t_command..' | '..get_fzf('FZF_CTRL_T_OPTS')..' -i -m')
    if not r then
        rl_buffer:ding()
        return
    end

    local str = r:read('*line')
    str = str and str:gsub('[\r\n]+', ' ') or ''
    str = str:gsub(' +$', '')
    r:close()

    if #str > 0 then
        rl_buffer:insert(str)
    end

    rl_buffer:refreshline()
end

function fzf_directory(rl_buffer, line_state)
    local alt_c_opts = os.getenv('FZF_ALT_C_OPTS')
    if not alt_c_opts then
        alt_c_opts = ""
    end

    local alt_c_command = os.getenv('FZF_ALT_C_COMMAND')
    if not alt_c_command then
        alt_c_command = 'dir /b /s /a:d-s $dir'
    end

    alt_c_command = replace_dir(alt_c_command, line_state)

    local temp_contents = rl_buffer:getbuffer()
    local r = io.popen(alt_c_command..' | '..get_fzf('FZF_ALT_C_OPTS')..' -i')
    if not r then
        rl_buffer:ding()
        return
    end

    local str = r:read('*all')
    str = str and str:gsub('[\r\n]', '') or ''
    r:close()

    if #str > 0 then
        rl_buffer:beginundogroup()
        rl_buffer:remove(0, -1)
        rl_buffer:insert('cd /d '..str)
        rl_buffer:endundogroup()
        rl_buffer:refreshline()
        rl.invokecommand('accept-line')
        return
    end

    rl_buffer:refreshline()
end

function fzf_bindings(rl_buffer)
    if not rl.getkeybindings then
        rl_buffer:beginoutput()
        print('fzf_bindings() in fzf.lua requires a newer version of Clink; please upgrade.')
        return
    end

    local bindings = rl.getkeybindings()
    if #bindings <= 0 then
        rl_buffer:refreshline()
        return
    end

    local line
    local r,w = io.popenrw(get_fzf('FZF_BINDINGS_OPTS')..' -i')
    if r and w then
        -- Write key bindings to the write pipe.
        for _,kb in ipairs(bindings) do
            w:write(kb.key..' : '..kb.binding..'\n')
        end
        w:close()

        -- Read filtered matches.
        local ret = {}
        line = r:read('*line')
        r:close()
    end

    rl_buffer:refreshline()

    if line and #line > 0 then
        local binding = line:sub(#bindings[1].key + 3 + 1)
        rl.invokecommand(binding)
    end
end

--------------------------------------------------------------------------------
-- Match generator.

local function filter_matches(matches, completion_type, filename_completion_desired)
    if not fzf_complete_intercept then
        return
    end

    -- Start fzf.
    local r,w = io.popenrw(get_fzf("FZF_COMPLETE_OPTS"))
    if not r or not w then
        return
    end

    -- Write matches to the write pipe.
    for _,m in ipairs(matches) do
        w:write(m.match..'\n')
    end
    w:close()

    -- Read filtered matches.
    local ret = {}
    while (true) do
        local line = r:read('*line')
        if not line then
            break
        end
        for _,m in ipairs(matches) do
            if m.match == line then
                table.insert(ret, m)
            end
        end
    end
    r:close()

    -- Yay, successful; clear it to not ding.
    fzf_complete_intercept = false
    return ret
end

local interceptor = clink.generator(0)
function interceptor:generate(line_state, match_builder)
    if fzf_complete_intercept then
        clink.onfiltermatches(filter_matches)
    end
    return false
end

clink.onbeginedit(function ()
    fzf_complete_intercept = false
end)


# FZF integration for Clink

This script integrates the [FZF](https://github.com/junegunn/fzf) "fuzzy finder" with the [Clink](https://chrisant996.github.io/clink) command line editing enhancements for CMD.exe on Windows.

This also includes key bindings for git objects, powered by fzf (ported from [fzf-git.sh](https://github.com/junegunn/fzf-git.sh)).

> [!TIP]
> Consider using [clink-gizmos](https://github.com/chrisant996/clink-gizmos) instead, which includes this script as well as many other useful scripts.  If you use clink-gizmos, then you don't need clink-fzf -- clink-gizmos contains a collection of scripts, and clink-fzf contains a single script.

# How to install

1.  Copy the `fzf.lua` file into your Clink scripts directory (you can run `clink info` to find it, or see [Location of Lua Scripts](https://chrisant996.github.io/clink/clink.html#lua-scripts-location) in the Clink docs for more info).
    - You can also copy the `fzf_git*.*` files into your Clink scripts directory, to enable using fzf to browse git objects.
    - You can also copy the `fzf_rg.lua` file into your Clink scripts directory, to enable using ripgrep and fzf together to search files and do fuzzy filtering on the results.

2.  Either put `fzf.exe` in a directory listed in the system PATH environment variable, or run `clink set fzf.exe_location <put_full_exe_name_here>` to tell Clink where to find the FZF program.

3.  Set up key bindings.
    - To use the default key bindings, run `clink set fzf.default_bindings true`.
    - To use custom key bindings, add them to your .inputrc file (see [Key Bindings](#key-bindings)).

4.  Optionally install [ripgrep](https://github.com/BurntSushi/ripgrep) for searching files.

5.  Optionally install [bat](https://github.com/sharkdp/bat) for fancy previewing of files.

# How to use

For detailed information on using FZF, please refer to the [FZF documentation](https://github.com/junegunn/fzf).

## Completion

Here are the default key bindings for fzf powered completions in Clink, if you've enabled the `fzf.default_bindings` setting:

Key | Description
-|-
<kbd>Ctrl</kbd>-<kbd>T</kbd>     | Lists files recursively; choose one or multiple to insert them.
<kbd>Ctrl</kbd>-<kbd>R</kbd>     | Lists history entries; choose one to insert it<br>Press <kbd>Del</kbd> in the list to delete the selected history entry.<br>Press <kbd>Ctrl</kbd>-<kbd>R</kbd> in the history list to toggle fzf's sorting mode.
<kbd>Alt</kbd>-<kbd>C</kbd>      | Lists subdirectories; choose one to 'cd /d' to it.
<kbd>Alt</kbd>-<kbd>B</kbd>      | Lists key bindings; choose one to invoke it.
<kbd>Tab</kbd>                   | Uses fzf to filter match completions, but only when preceded by '**' (recursive).
<kbd>Ctrl</kbd>-<kbd>Space</kbd> | Uses fzf to filter match completions (and supports '**' for recursive).

## Recursive completion

You can use `**`<kbd>Tab</kbd> to list files recursively under the directory.

For example:
- `notepad **` lists files recursively under the current directory.
- `notepad foo**` lists files recursively under the current directory, and uses `foo` as the search phrase.
- `notepad bar\foo**` lists files recursively under the `bar` directory, and uses `foo` as the search phrase.

## Browsing git objects

Here are the default key bindings for git objects in Clink, unless you've disabled the `fzf_git.default_bindings` setting:

Key | Description
-|-
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>?</kbd> | Show key bindings for fzf_git
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>F</kbd> | Use fzf for Files
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>B</kbd> | Use fzf for Branches
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>T</kbd> | Use fzf for Tags
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>R</kbd> | Use fzf for Remotes
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>H</kbd> | Use fzf for commit Hashes
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>S</kbd> | Use fzf for Stashes
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>L</kbd> | Use fzf for reflogs
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>W</kbd> | Use fzf for Worktrees
<kbd>Ctrl</kbd>-<kbd>G</kbd>,<kbd>Ctrl</kbd>-<kbd>E</kbd> | Use fzf for Each ref (git for-each-ref)

## Searching files with ripgrep and fzf

Here are the default key bindings for ripgrep/fzf searches:

Key | Description
-|-
<kbd>Ctrl</kbd>-<kbd>X</kbd>,<kbd>F</kbd> | Interactively search files with ripgrep and filter results fzf.
<kbd>Ctrl</kbd>-<kbd>X</kbd>,<kbd>Ctrl</kbd>-<kbd>F</kbd> | Interactively search files with ripgrep and filter results fzf.

You can also run the `fzf_rg.cmd` script to invoke searching files with ripgrep and fzf from the command line, instead of using a key binding.

# Overriding the default behaviors

## Key bindings

You can use your own custom key bindings if you prefer.

Run `clink set fzf.default_bindings false` and add key bindings to your `.inputrc` file manually.

Run `clink echo` to find key bindings strings.  See [Key Bindings](https://chrisant996.github.io/clink/clink.html#key-bindings) in the Clink documentation for more information on how to set key bindings.

The default key bindings for FZF are listed here in .inputrc file format for convenience:

```inputrc
# Default key bindings for fzf with Clink.
"\C-t":        "luafunc:fzf_file"               # Ctrl-T lists files recursively; choose one or multiple to insert them.
"\C-r":        "luafunc:fzf_history"            # Ctrl-R lists history entries; choose one to insert it.
"\M-c":        "luafunc:fzf_directory"          # Alt-C lists subdirectories; choose one to 'cd /d' to it.
"\M-b":        "luafunc:fzf_bindings"           # Alt-B lists key bindings; choose one to invoke it.
"\t":          "luafunc:fzf_complete"           # Tab uses fzf to filter match completions, but only when preceded by '**' (recursive).
"\e[27;5;32~": "luafunc:fzf_complete_force"     # Ctrl-Space uses fzf to filter match completions (and supports '**' for recursive).
```

The default key bindings for git objects are listed here in .inputrc file format for convenience:

```inputrc
# Default key bindings for fzf_git with Clink.
"\C-g?":       "luafunc:fzf_git_help"           # Ctrl-G,? shows key bindings for fzf_git.
"\C-g\C-f":    "luafunc:fzf_git_files"          # Ctrl-G,Ctrl-F uses fzf for Files.
"\C-g\C-b":    "luafunc:fzf_git_branches"       # Ctrl-G,Ctrl-B uses fzf for Branches.
"\C-g\C-t":    "luafunc:fzf_git_tags"           # Ctrl-G,Ctrl-T uses fzf for Tags.
"\C-g\C-r":    "luafunc:fzf_git_remotes"        # Ctrl-G,Ctrl-R uses fzf for Remotes.
"\C-g\C-h":    "luafunc:fzf_git_commit_hashes"  # Ctrl-G,Ctrl-H uses fzf for commit Hashes.
"\C-g\C-s":    "luafunc:fzf_git_stashes"        # Ctrl-G,Ctrl-S uses fzf for Stashes.
"\C-g\C-l":    "luafunc:fzf_git_reflogs"        # Ctrl-G,Ctrl-L uses fzf for reflogs.
"\C-g\C-w":    "luafunc:fzf_git_worktrees"      # Ctrl-G,Ctrl-W uses fzf for Worktrees.
"\C-g\C-e":    "luafunc:fzf_git_eachref"        # Ctrl-G,Ctrl-E uses fzf for Eachref (git for-each-ref).
```

The default key bindings for ripgrep/fzf searches are listed here in .inputrc file format for convenience:

```inputrc
# Default key bindings for fzf_ripgrep with Clink.
"\C-xf":       "luafunc:fzf_ripgrep"            # Ctrl-X,F shows a FZF filtered view with files matching search term.
"\C-x\C-f":    "luafunc:fzf_ripgrep"            # Ctrl-X,Ctrl-F shows a FZF filtered view with files matching search term.
```

The following commands are also available for binding to keys:

Command | Description
-|-
`"luafunc:fzf_menucomplete"` | Use fzf for completion after `**` otherwise use the `menu-complete` command.
`"luafunc:fzf_oldmenucomplete"` | Use fzf for completion after `**` otherwise use the `old-menu-complete` command.

## FZF options

You can specify FZF options for each of the different commands:

Env Var Name | Description
-|-
`FZF_DEFAULT_OPTS`  | Options that are applied to all fzf invocations.
`FZF_CTRL_T_OPTS`   | Options for <kbd>Ctrl</kbd>-<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_CTRL_R_OPTS`   | Options for <kbd>Ctrl</kbd>-<kbd>R</kbd> (the `"luafunc:fzf_history"` function).
`FZF_ALT_C_OPTS`    | Options for <kbd>Alt</kbd>-<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).
`FZF_BINDINGS_OPTS` | Options for <kbd>Alt</kbd>-<kbd>B</kbd> (the `"luafunc:fzf_bindings"` function).
`FZF_COMPLETION_OPTS` | Options for the completion functions (`"luafunc:fzf_complete"`, `"luafunc:fzf_menucomplete"`, `"luafunc:fzf_oldmenucomplete"`, `"luafunc:fzf_selectcomplete"`, etc).

> [!TIP]
> The options in `FZF_DEFAULT_OPTS` are added to all fzf commands.
> The options in the other `..._OPTS` environment variables are added only to their corresponding fzf commands.

## FZF git options

You can specify FZF options for the git object browsing commands:

Env Var Name | Description
-|-
`BAT_STYLE`         | Defines what will be passed to `bat` via its `--style="..."` flag.
`FZF_GIT_CAT`       | Defines the preview command used for displaying files.
`FZF_GIT_COLOR`     | Control colors in the list: `always` (default) shows colors, `never` suppresses colors.
`FZF_GIT_PAGER`     | Specifies the pager command for the preview window.  (This is not used yet.)
`FZF_GIT_PREVIEW_COLOR` | Control colors in the preview window: `always` (default) shows colors, `never` suppresses colors.
`FZF_GIT_DEFAULT_COLORS` | Defines the default colors for fzf.  This is passed to fzf via the `--color` flag.
`FZF_GIT_EDITOR`    | Defines the command for editing a file.  Falls back to `%EDITOR%` or `notepad.exe` if not set.

## FZF ripgrep options

You can specify options for ripgrep and FZF when searching files:

Env Var Name | Description
-|-
`FZF_RG_EDITOR`     | Command to launch editor (expands placeholder tokens).
`FZF_RG_FZF_OPTIONS` | Options to add to the fzf commands.
`FZF_RG_RG_OPTIONS` | Options to add to the rg commands.

## Configuring the editor to launch when searching files

The editor to launch is chosen from the following, in priority order:

1. The `fzf_rg.editor` Clink setting (this expands placeholders; see below).
2. The `FZF_RG_EDITOR` environment variable (this expands placeholders; see below).
3. The `EDITOR` environment variable (this does not support placeholders).
4. If none of the above are set, then `notepad.exe` is used.

For all of these, the string is a command line and may contain flags (for example, `myeditor.exe --flag1 --flag2`).  The filename is automatically appended to the end of the command line, with quotes when appropriate.

The `fzf_rg.editor` setting and `FZF_RG_EDITOR` environment variable supporting expanding certain placeholders:

Placeholder | Description
-|-
`{file}` | This is replaced with the selected filename, and prevents automatically appending the filename to the end of the command line.  The filename is automatically quoted when needed, but if a quote is adjacent to {file} then quoting is disabled (e.g. an editor might require "{file}@{line}").
`{line}` | This is replaced with the selected line number.
`{$envvar}` | This is replaced with the value of `%envvar%` (with any newlines replaced with spaces).

## File and directory list commands

You can specify commands to run for collecting files or directories:

Env Var Name | Description
-|-
`FZF_CTRL_T_COMMAND` | Command to run for collecting files for <kbd>Ctrl</kbd>-<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_ALT_C_COMMAND`  | Command to run for collecting directories for <kbd>Alt</kbd>-<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).

# Icons in FZF

You can optionally have file icons show up in FZF completion lists in Clink (but not for the git object fzf commands).

Requirements:
- Install and use a [Nerd Font](https://nerdfonts.com).
- [Clink](https://github.com/chrisant996/clink) v1.6.5 or newer.
- [DirX](https://github.com/chrisant996/dirx) v0.9 or newer.
- [FZF](https://github.com/junegunn/fzf).

Configure the following environment variables:
- `set FZF_CTRL_T_COMMAND=dirx.exe /b /s /X:d /a:-s-h --bare-relative --icons=always --utf8 -- $dir`
- `set FZF_ALT_C_COMMAND=dirx.exe /b /s /X:d /a:d-s-h --bare-relative --icons=always --utf8 -- $dir`
- `set FZF_ICON_WIDTH=2`

If you want it to recurse into hidden directories, then remove the `/X:d` part from the commands in the environment variables.

If you want it to list hidden files and directories, then remove the `-h` part at the end of the `/a:` flags in the environment variables.

# Previewing file and folder contents

You can specify a preview command for FZF. 

If you have [enabled icons](#Icons-in-FZF), then replace each `{}` with `{2..}`.

The examples also let you toggle between different preview window sizes with <kbd>Ctrl</kbd>-<kbd>/</kbd>.

## Previewing file contents

The command will show the contents of files with the <kbd>Ctrl</kbd>-<kbd>T</kbd> hotkey; it assumes you have [bat](https://github.com/sharkdp/bat) installed and available in the `%PATH%` environment variable.

`set FZF_CTRL_T_OPTS=--preview-window "right:40%,border-left" --bind "ctrl-/:change-preview-window(right:70%|hidden|)" --preview "bat --force-colorization --style=numbers,changes --line-range=:500 -- {}"`

## Previewing folder contents

This command will show the contents of folders with the <kbd>Alt</kbd>-<kbd>C</kbd> hotkey; it assumes you have [dirx](https://github.com/chrisant996/dirx) installed and available in the `%PATH%` environment variable.

`set FZF_ALT_C_OPTS=--preview-window "right:40%,border-left" --bind "ctrl-/:change-preview-window(right:70%|hidden|)" --preview "dirx -b -s --bare-relative --utf8 --level=3 --tree --icons=always -- {}"`

## Previewing image files

The sample script [fzf-preview.cmd](fzf-preview.cmd) can be used to preview image files.  It assumes you have both [chafa](https://hpjansson.org/chafa) and [bat](https://github.com/sharkdp/bat) installed and available in the `%PATH%` environment variable.

To use the sample script for previewing image files, replace the `--preview "..."` part of the examples above with either:
- `--preview "fzf-preview.cmd {}"` if you're not using icons, or
- `--preview "fzf-preview.cmd {2..}"` if you're using icons.

If your terminal supports sixels, you can also run `set CLINK_FZF_PREVIEW_SIXELS=1` to tell the fzf-preview.cmd script to tell chafa to use sixels.

If you want to customize the flags for `chafa` and `bat`:
1. Make a copy of the script.
2. Customize the _copy_ instead of the original.  That way, your changes won't get overwritten when you update clink-fzf (or clink-gizmos).
3. Replace `fzf-preview.cmd` in the examples above with the filename of your customized copy.

# Unicode content in FZF

FZF assumes UTF8 stdin, but native Windows programs assume stdin and stdout are in the console's current codepage, which is not UTF8 by default.

The `fzf.lua` and `fzf_git.lua` scripts automatically save the current codepage and switch to UTF8 before invoking FZF, and then restore the original codepage after FZF exits.  This should ensure that users don't need to apply any custom workarounds to get Unicode text to show up in FZF.

For curious readers, here are related issues in FZF:
- [fzf/4065](https://github.com/junegunn/fzf/issues/4065) tracks the stdin encoding issue in FZF on Windows.
- [fzf/3799](https://github.com/junegunn/fzf/issues/3799) tracks the Unicode keyboard input issue in FZF on Windows.

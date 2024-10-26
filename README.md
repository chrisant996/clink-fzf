# FZF integration for Clink

This script integrates the [FZF](https://github.com/junegunn/fzf) "fuzzy finder" with the [Clink](https://chrisant996.github.io/clink) command line editing enhancements for CMD.exe on Windows.

> [!TIP]
> Consider using [clink-gizmos](https://github.com/chrisant996/clink-gizmos) instead, which includes this script as well as many other useful scripts.  If you use clink-gizmos, then you don't need clink-fzf -- clink-gizmos contains a collection of scripts, and clink-fzf contains a single script.

# How to install

1.  Copy the `fzf.lua` file into your Clink scripts directory (you can run `clink info` to find it, or see [Location of Lua Scripts](https://chrisant996.github.io/clink/clink.html#lua-scripts-location) in the Clink docs for more info).

2.  Either put `fzf.exe` in a directory listed in the system PATH environment variable, or run `clink set fzf.exe_location <put_full_exe_name_here>` to tell Clink where to find the FZF program.

3.  Set up key bindings.
    - To use the default key bindings, run `clink set fzf.default_bindings true`.
    - To use custom key bindings, add them to your .inputrc file (see [Key Bindings](#key-bindings)).

# How to use

For detailed information on using FZF, please refer to the [FZF documentation](https://github.com/junegunn/fzf).

Here are the default key bindings in Clink, if you've enabled the `fzf.default_bindings` setting:

Key | Description
-|-
<kbd>Ctrl</kbd>+<kbd>T</kbd>     | Lists files recursively; choose one or multiple to insert them.
<kbd>Ctrl</kbd>+<kbd>R</kbd>     | Lists history entries; choose one to insert it<br>Press <kbd>Del</kbd> in the list to delete the selected history entry.<br>Press <kbd>Ctrl</kbd>+<kbd>R</kbd> in the history list to toggle fzf's sorting mode.
<kbd>Alt</kbd>+<kbd>C</kbd>      | Lists subdirectories; choose one to 'cd /d' to it.
<kbd>Alt</kbd>+<kbd>B</kbd>      | Lists key bindings; choose one to invoke it.
<kbd>Tab</kbd>                   | Uses fzf to filter match completions, but only when preceded by '**' (recursive).
<kbd>Ctrl</kbd>+<kbd>Space</kbd> | Uses fzf to filter match completions (and supports '**' for recursive).

> **Note:** For the default key bindings to work, you must be using Clink v1.2.46 or higher.  If you're using an older version of Clink then consider upgrading Clink, or manually add key bindings in your .inputrc file as described below.

## Recursive completion

You can use `**`<kbd>Tab</kbd> to list files recursively under the directory.

For example:
- `notepad **` lists files recursively under the current directory.
- `notepad foo**` lists files recursively under the current directory, and uses `foo` as the search phrase.
- `notepad bar\foo**` lists files recursively under the `bar` directory, and uses `foo` as the search phrase.

# Overriding the default behaviors

## Key bindings

You can use your own custom key bindings if you prefer.

Run `clink set fzf.default_bindings false` and add key bindings to your `.inputrc` file manually.

Run `clink echo` to find key bindings strings.  See [Key Bindings](https://chrisant996.github.io/clink/clink.html#key-bindings) in the Clink documentation for more information on how to set key bindings.

The default key bindings for FZF are listed here in .inputrc file format for convenience:

```inputrc
# Default key bindings for fzf with Clink.
"\C-t":        "luafunc:fzf_file"           # Ctrl+T lists files recursively; choose one or multiple to insert them.
"\C-r":        "luafunc:fzf_history"        # Ctrl+R lists history entries; choose one to insert it.
"\M-c":        "luafunc:fzf_directory"      # Alt+C lists subdirectories; choose one to 'cd /d' to it.
"\M-b":        "luafunc:fzf_bindings"       # Alt+B lists key bindings; choose one to invoke it.
"\t":          "luafunc:fzf_complete"       # Tab uses fzf to filter match completions, but only when preceded by '**' (recursive).
"\e[27;5;32~": "luafunc:fzf_complete_force" # Ctrl+Space uses fzf to filter match completions (and supports '**' for recursive).
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
`FZF_CTRL_T_OPTS`   | Options for <kbd>Ctrl</kbd>+<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_CTRL_R_OPTS`   | Options for <kbd>Ctrl</kbd>+<kbd>R</kbd> (the `"luafunc:fzf_history"` function).
`FZF_ALT_C_OPTS`    | Options for <kbd>Alt</kbd>+<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).
`FZF_BINDINGS_OPTS` | Options for <kbd>Alt</kbd>+<kbd>B</kbd> (the `"luafunc:fzf_bindings"` function).
`FZF_COMPLETION_OPTS` | Options for the completion functions (`"luafunc:fzf_complete"`, `"luafunc:fzf_menucomplete"`, `"luafunc:fzf_oldmenucomplete"`, `"luafunc:fzf_selectcomplete"`, etc).

> [!TIP]
> The options in `FZF_DEFAULT_OPTS` are added to all fzf commands.
> The options in the other `..._OPTS` environment variables are added only to their corresponding fzf commands.

## File and directory list commands

You can specify commands to run for collecting files or directories:

Env Var Name | Description
-|-
`FZF_CTRL_T_COMMAND` | Command to run for collecting files for <kbd>Ctrl</kbd>+<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_ALT_C_COMMAND`  | Command to run for collecting directories for <kbd>Alt</kbd>+<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).

# Unicode content in FZF (known issue in FZF)

As of v0.55.0 (October 2024), FZF assumes UTF8 stdin.  But native Windows programs assume stdin and stdout are in the system codepage.

The default configuration for FZF uses `dir` to generate directory listings.  But the directory listings are in the system codepage, not UTF8.  So FZF misinterprets anything that isn't ASCII text, which can result in garbled text.

You can overcome that with the help of the `dirx` program.

Requirements:
- [DirX](https://github.com/chrisant996/dirx) v0.9 or newer.
- [FZF](https://github.com/junegunn/fzf).

Configure the following environment variables:
- `set FZF_CTRL_T_COMMAND=dirx.exe /b /s /X:d /a:-s-h --bare-relative --utf8 -- $dir`
- `set FZF_ALT_C_COMMAND=dirx.exe /b /s /X:d /a:d-s-h --bare-relative --utf8 -- $dir`

That should enable full Unicode directory listings.

Issue [fzf/4065](https://github.com/junegunn/fzf/issues/4065) tracks the stdin encoding issue in FZF on Windows, and issue [fzf/3799](https://github.com/junegunn/fzf/issues/3799) tracks the Unicode keyboard input issue in FZF on Windows.

# Icons in FZF

You can optionally have file icons show up in FZF completion lists in Clink.

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

The examples also let you toggle between different preview window sizes with <kbd>Ctrl</kbd>+<kbd>/</kbd>.

## Previewing file contents

The command will show the contents of files with the <kbd>Ctrl</kbd>+<kbd>T</kbd> hotkey; it assumes you have [bat](https://github.com/sharkdp/bat) installed and available in the `%PATH%` environment variable.

`set FZF_CTRL_T_OPTS=--preview-window "right:40%,border-left" --bind "ctrl-/:change-preview-window(right:70%|hidden|)" --preview "bat --force-colorization --style=numbers,changes --line-range=:500 -- {}"`

## Previewing folder contents

This command will show the contents of folders with the <kbd>Alt</kbd>+<kbd>C</kbd> hotkey; it assumes you have [dirx](https://github.com/chrisant996/dirx) installed and available in the `%PATH%` environment variable.

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

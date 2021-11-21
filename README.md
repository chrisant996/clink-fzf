# FZF integration for Clink

This script integrates the [FZF](https://nicedoc.io/junegunn/fzf) "fuzzy finder" with the [Clink](https://chrisant996.github.io/clink) command line editing enhancements for CMD.exe on Windows.

# How to install

1.  Copy the `fzf.lua` file into your Clink scripts directory.

2.  Either put `fzf.exe` in a directory listed in the system PATH environment variable, or run `clink set fzf.exe_location <put_dir_name_here>` to tell Clink where to find the FZF program.

# How to use

For detailed information on using FZF, please refer to the [FZF documentation](https://nicedoc.io/junegunn/fzf).

Here are the default key bindings in Clink:

Key | Description
-|-
<kbd>Ctrl</kbd>+<kbd>T</kbd>     | Lists files recursively; choose one or multiple to insert them.
<kbd>Ctrl</kbd>+<kbd>R</kbd>     | Lists history entries; choose one to insert it.
<kbd>Alt</kbd>+<kbd>C</kbd>      | Lists subdirectories; choose one to 'cd /d' to it.
<kbd>Alt</kbd>+<kbd>B</kbd>      | Lists key bindings; choose one to invoke it.
<kbd>Ctrl</kbd>+<kbd>Space</kbd> | Uses fzf to filter match completions.

> **Note:** For the default key bindings to work, you must be using Clink v1.2.46 or higher.  If you're using an older version of Clink then consider upgrading Clink, or manually add key bindings in your .inputrc file as described below.

# Overriding the default behaviors

## Key bindings

You can use your own custom key bindings if you prefer.

Run `clink set fzf.default_bindings false` and add key bindings to your `.inputrc` file manually.

Run `clink echo` to find key bindings strings.  See [Key Bindings](https://chrisant996.github.io/clink/clink.html#key-bindings) in the Clink documentation for more information on how to set key bindings.

The default key bindings for FZF are listed here in .inputrc file format for convenience:

```inputrc
# Default key bindings for fzf with Clink.
"\C-t":        "luafunc:fzf_file"       # Ctrl+T lists files recursively; choose one or multiple to insert them.
"\C-r":        "luafunc:fzf_history"    # Ctrl+R lists history entries; choose one to insert it.
"\M-c":        "luafunc:fzf_directory"  # Alt+C lists subdirectories; choose one to 'cd /d' to it.
"\M-b":        "luafunc:fzf_bindings"   # Alt+B lists key bindings; choose one to invoke it.
"\e[27;5;32~": "luafunc:fzf_complete"   # Ctrl+Space uses fzf to filter match completions.
```

## FZF options

You can specify FZF options for each of the different commands:

Env Var Name | Description
-|-
`FZF_CTRL_T_OPTS`   | Options for <kbd>Ctrl</kbd>+<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_CTRL_R_OPTS`   | Options for <kbd>Ctrl</kbd>+<kbd>R</kbd> (the `"luafunc:fzf_history"` function).
`FZF_ALT_C_OPTS`    | Options for <kbd>Alt</kbd>+<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).
`FZF_BINDINGS_OPTS` | Options for <kbd>Alt</kbd>+<kbd>B</kbd> (the `"luafunc:fzf_bindings"` function).
`FZF_COMPLETE_OPTS` | Options for <kbd>Ctrl</kbd>+<kbd>Space</kbd> (the `"luafunc:fzf_complete"` function).

## File and directory list commands

You can specify commands to run for collecting files or directories:

Env Var Name | Description
-|-
`FZF_CTRL_T_COMMAND` | Command to run for collecting files for <kbd>Ctrl</kbd>+<kbd>T</kbd> (the `"luafunc:fzf_file"` function).
`FZF_ALT_C_COMMAND`  | Command to run for collecting directories for <kbd>Alt</kbd>+<kbd>C</kbd> (the `"luafunc:fzf_directory"` function).

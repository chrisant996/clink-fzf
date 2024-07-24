@echo off
setlocal

rem     Depends on:
rem     - https://hpjansson.org/chafa
rem     - https://github.com/sharkdp/bat


rem     IMPORTANT NOTE:
rem
rem     If you want to customize this script, first copy it to another file
rem     name, so that your changes don't get overwritten when updating the
rem     clink-fzf or clink-gizmos scripts.


rem -- Ignore empty filenames.
rem    For example if {2..} is used with only one field, such as when
rem    configured to use icons but a match has no icon.
if "%~1" == "" goto :end

rem -- Make sure the filename is quoted.
set __ARG="%~1"

rem -- Try to preview as an image.
rem    NOTE: Unfortunately chafa does not support the usual -- syntax to end flags.
if x%__ARG:~1,1% == x- goto :try_file
2>nul chafa %__ARG%
if not errorlevel 1 goto :end

rem -- Try to preview as a text file.
:try_file
bat --force-colorization --style=numbers,changes --line-range=:500 -- %__ARG%

:end

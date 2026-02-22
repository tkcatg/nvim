@echo off

set KEYBIND=keybindings.json
set SETTING=settings.json

set DIR1=%LOCALAPPDATA%\nvim\vscode
set DIR2=%APPDATA%\Code\User

if "%1"=="" goto usage

if /i "%1"=="install"   goto do_install
if /i "%1"=="uninstall" goto do_uninstall

echo Error: invalud argument
goto usage

:do_install
echo -------
echo Install
echo -------
if not exist "%DIR2%\%KEYBIND%" ( mklink "%DIR2%\%KEYBIND%" "%DIR1%\%KEYBIND%" ) else ( echo %DIR2%\%KEYBIND% is exist. )
if not exist "%DIR2%\%SETTING%" ( mklink "%DIR2%\%SETTING%" "%DIR1%\%SETTING%" ) else ( echo %DIR2%\%SETTING% is exist. )
pause
exit /b

:do_uninstall
echo ---------
echo Uninstall
echo ---------
if exist "%DIR2%\%KEYBIND%" (del "%DIR2%\%KEYBIND%" & echo %DIR2%\%KEYBIND% deleted. )
if exist "%DIR2%\%SETTING%" (del "%DIR2%\%SETTING%" & echo %DIR2%\%SETTING% deleted. )
pause
exit /b

:usage
echo Usage: "%0 [ install | uninstall ]"
pause
exit /b
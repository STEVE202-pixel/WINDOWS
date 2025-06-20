@echo off
title 🔥 Permanent Downloads Cleaner 🔥
color 0C

echo 🔥 Deleting files from Downloads folder...
set "target=%USERPROFILE%\Downloads"
	
:: Delete all files
del /f /q "%target%\*.*"

:: Delete all subfolders
for /d %%d in ("%target%\*") do rd /s /q "%%d"

:: Overwrite free space to prevent recovery
cipher /w:"%target%"

echo ✅ Done! Downloads folder cleaned permanently.
pause

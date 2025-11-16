@echo off
start "" "%~dp0start_backend.bat"
timeout /t 2 >nul

if exist "%~dp0web\index.html" (
    start "" "%~dp0web\index.html"
) else (
    echo Please add web\index.html for UI.
)

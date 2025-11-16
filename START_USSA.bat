@echo off
title USSA - Universal Smart Assistant AI
color 0b

echo Starting USSA backend...
start "" cmd /k "D:\USAA-Agent\venv\Scripts\activate && cd D:\USAA-Agent\backend && python server.py"

timeout /t 2 >nul

echo Starting USSA frontend...
start "" cmd /k "cd D:\USAA-Agent\web && python -m http.server 5500"

timeout /t 3 >nul

echo Opening USSA interface...
start "" "http://127.0.0.1:5500/"

echo USSA is ready!
exit

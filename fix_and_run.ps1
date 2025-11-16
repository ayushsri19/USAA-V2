Write-Host "USAA AGENT - ONE CLICK FIX STARTING..."

$Root = "D:\USAA-Agent"
$Venv = "$Root\venv\Scripts\Activate.ps1"
$Backend = "$Root\backend\server.py"
$Frontend = "$Root\web"
$SettingsFolder = "$Root\.vscode"
$SettingsFile = "$SettingsFolder\settings.json"
$Src = "$Root\src"

# Create .vscode folder
if (!(Test-Path $SettingsFolder)) {
    New-Item -ItemType Directory -Path $SettingsFolder | Out-Null
}

# Create settings.json
$settingsJson = @'
{
    "python.defaultInterpreterPath": "D:/USAA-Agent/venv/Scripts/python.exe",
    "python.analysis.extraPaths": [
        "D:/USAA-Agent/src",
        "D:/USAA-Agent/src/engine",
        "D:/USAA-Agent/src/agents",
        "D:/USAA-Agent/src/orchestrator",
        "D:/USAA-Agent/src/router"
    ],
    "python.analysis.autoSearchPaths": true,
    "python.analysis.useLibraryCodeForTypes": true
}
'@

Set-Content -Path $SettingsFile -Value $settingsJson -Encoding UTF8
Write-Host "VS Code Pylance settings fixed."

# Fix __init__.py
$folders = @(
    "$Src",
    "$Src\engine",
    "$Src\agents",
    "$Src\router",
    "$Src\orchestrator"
)

foreach ($f in $folders) {
    $init = Join-Path $f "__init__.py"
    if (!(Test-Path $init)) {
        New-Item -Path $init -ItemType File | Out-Null
        Write-Host "Created: $init"
    }
}

# Set pythonpath
$env:PYTHONPATH = $Src
Write-Host "PYTHONPATH set."

# Activate venv
Write-Host "Activating venv..."
. $Venv

# Install dependencies
Write-Host "Installing dependencies..."
pip install fastapi uvicorn python-dotenv pydantic openai httpx > $null
Write-Host "Dependencies ready."

# Start backend
Write-Host "Starting backend on http://localhost:8000"
Start-Process powershell -ArgumentList "-NoExit", "-Command", ". $Venv; python '$Backend'"

Start-Sleep -Seconds 2

# Start frontend
Write-Host "Starting frontend on http://localhost:5500"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$Frontend'; python -m http.server 5500"

Start-Sleep -Seconds 2

# Open VS Code
Write-Host "Opening VS Code..."
Start-Process code -ArgumentList "$Root"

# Open browser
Write-Host "Opening browser..."
Start-Process "http://localhost:5500/index.html"

Write-Host "DONE. All Fixes Applied."

# iFiNeX - prepare the project for Android Studio (Windows).  Right-click -> Run with PowerShell  (or double-click build-android-local.bat)
# Run from anywhere: it finds the project folder (the one that contains package.json) by itself.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path (Join-Path $root 'package.json'))) { Write-Host "ERROR: package.json not found in $root. This script must stay inside the 'tools' folder of the iFiNeX project." -ForegroundColor Red; Read-Host 'Press Enter'; exit 1 }
Set-Location $root
Write-Host "Project folder: $root"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Write-Host "Node.js is not installed. Install the LTS version from https://nodejs.org (Next, Next, Finish), then run this again." -ForegroundColor Red; Read-Host 'Press Enter'; exit 1 }
npm ci --no-audit --no-fund
if ($LASTEXITCODE -ne 0) { npm install --no-audit --no-fund }
npx cap sync android
if ($LASTEXITCODE -ne 0) { Write-Host 'cap sync failed - read the message above.' -ForegroundColor Red; Read-Host 'Press Enter'; exit 1 }
Write-Host "`nDONE. In Android Studio: File > Open > choose the 'android' folder inside $root  -> wait for Gradle sync -> Build > Build APK(s)." -ForegroundColor Green
Write-Host "APK appears in android\app\build\outputs\apk\debug\app-debug.apk"
$a = Read-Host 'Open Android Studio now? (y/n)'
if ($a -eq 'y') { npx cap open android }

# iFiNeX — create your PERMANENT app signing key (do this ONCE, keep the file forever). Windows PowerShell.
# Needs Java: install "Temurin 17" from adoptium.net, or use the one inside Android Studio (see Setup Guide).
$ErrorActionPreference = "Stop"
$ks = Join-Path $env:USERPROFILE ".android\debug.keystore"
$kt = (Get-Command keytool -ErrorAction SilentlyContinue).Source
if (-not $kt) { $kt = "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" }
if (Test-Path $ks) { Write-Host "A key already exists at $ks - reusing it (this is what keeps updates working). Nothing overwritten." }
else { New-Item -ItemType Directory -Force (Split-Path $ks) | Out-Null
  & $kt -genkeypair -keystore $ks -storepass android -keypass android -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 36500 -dname "CN=iFiNeX,O=iFiNeX,C=AE" }
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($ks))
$b64 | Set-Clipboard
Set-Content -NoNewline -Path "$ks.b64.txt" -Value $b64
Write-Host "`n1) BACK UP this file somewhere safe (cloud drive + USB): $ks"
Write-Host "2) The secret text is ALREADY COPIED to your clipboard (also saved in $ks.b64.txt)"
Write-Host "3) GitHub repo -> Settings -> Secrets and variables -> Actions -> New repository secret"
Write-Host "   Name: IFX_DEBUG_KEYSTORE_B64   Secret: press Ctrl+V   -> Add secret"

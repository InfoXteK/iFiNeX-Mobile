#!/bin/bash
# iFiNeX - prepare the project for Android Studio (Mac/Linux)
set -e
cd "$(dirname "$0")/.."
[ -f package.json ] || { echo "package.json not found - run this from the iFiNeX project"; exit 1; }
npm ci --no-audit --no-fund || npm install --no-audit --no-fund
npx cap sync android
echo "DONE. Android Studio: File > Open > the 'android' folder -> Build > Build APK(s)."

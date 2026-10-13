#!/bin/bash
# iFiNeX — create your PERMANENT app signing key (do this ONCE, keep the file forever).
# Needs Java (keytool). Result: ifinex-signing.keystore (KEEP SAFE, never upload to GitHub) + ifinex-signing.keystore.b64.txt (paste into the GitHub secret).
set -e
KS="${1:-$HOME/.android/debug.keystore}"
if [ -f "$KS" ]; then echo "A key already exists at $KS — reusing it (this is what keeps updates working). Nothing overwritten."
else mkdir -p "$(dirname "$KS")"; keytool -genkeypair -keystore "$KS" -storepass android -keypass android -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 36500 -dname "CN=iFiNeX,O=iFiNeX,C=AE"; fi
B64="$(dirname "$KS")/ifinex-signing.keystore.b64.txt"
base64 < "$KS" | tr -d '\n' > "$B64"
echo; echo "1) BACK UP this file somewhere safe (cloud drive + USB):  $KS"
echo "2) GitHub repo -> Settings -> Secrets and variables -> Actions -> New repository secret"
echo "   Name:   IFX_DEBUG_KEYSTORE_B64"
echo "   Secret: the whole text inside  $B64"
echo "3) Use the SAME secret in BOTH repos (cloud and offline) — or a different key per repo, but never change it later."
command -v pbcopy >/dev/null && pbcopy < "$B64" && echo "(text already copied to your clipboard)"

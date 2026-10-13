# iFiNeX app (Android + iOS, one project)

Standard Capacitor project. **Everything is in this one folder:** `package.json`, `www/` (the website inside the app), `android/`, `ios/`.

* **GitHub builds the APK for you:** Actions -> *Build iFiNeX APK* -> Run workflow -> Releases.
* **Android Studio:** run `tools/build-android-local.bat` (Windows) or `tools/build-android-local.sh`, then Android Studio -> File -> Open -> the `android` folder -> Build -> Build APK(s).
  Manual equivalent (in the folder that contains `package.json`):  `npm ci` then `npx cap sync android`.
* Both routes use the same signing key if you follow the Setup Guide (secret `IFX_DEBUG_KEYSTORE_B64` = your Android Studio debug keystore).

Do NOT open the `android` folder in Android Studio before `npx cap sync android` was run once (the plugins are linked from `node_modules`).

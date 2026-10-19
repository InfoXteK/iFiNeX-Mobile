# iFiNeX — Mobile app (Android / iOS wrapper)

Capacitor wrapper around the iFiNeX website. GitHub Actions builds the signed APK, publishes it as a **Release**, and the app updates itself from that Release.

| What | Official value |
|---|---|
| This repo (app) | https://github.com/SquadSplit/iFiNeX-Mobile |
| Website repo | https://github.com/SquadSplit/Squadsplit.github.io |
| Live website | https://squadsplit.github.io |
| Latest APK | https://github.com/SquadSplit/iFiNeX-Mobile/releases/latest |

---

## Forking / cloning? Change these things

| # | What | File (in this repo) | What to change |
|---|---|---|---|
| 1 | **Where the phone looks for app updates** | `android/app/src/main/res/values/ifinex_update.xml` → `ifinex_update_repo` | `YOURUSER/YOUR-APP-REPO` — **this is the only place the phone reads it from** |
| 2 | **Which website repo is copied into the app** | `.github/workflows/sync-web.yml` → `WEB_REPO:` (line ~23) and `WEB_BRANCH:` | `YOURUSER/YOURUSER.github.io` and your branch |
| 3 | **Your website address, Supabase URL and Supabase key** | `www/ifinex-config.json` (`site`, `supabaseUrl`, `supabaseKey`) | **Do not edit it here by hand** — edit `ifinex-config.json` in your *website* repo; the sync workflow copies it into `www/` and overwrites local edits. Use the anon/publishable key only, **never `service_role`** |
| 4 | Signing key | repo → *Settings → Secrets and variables → Actions* | create `IFX_KEYSTORE_B64` and `IFX_KEYSTORE_PASSWORD` (see `tools/signing-key.js`). Keep the same key forever, or phones refuse updates |
| 5 | Website-repo → app instant trigger (optional) | website repo `.github/workflows/notify-app.yml` → `--repo` | your app repo |
| 6 | App id (advanced, only if you publish under your own id) | `capacitor.config.json` `appId`, `android/app/build.gradle` (`applicationId`, `namespace`), and the Java package folder `io/github/squadsplit/app` | your own id |

The app is **not** pre-filled with a server: on first start it asks "Server or Standalone" and the user enters the website address. `ifinex-config.js` → `LEGACY_HOST` is only a storage-key name and needs no change in a fork.

### Setup in 6 steps
1. Fork this repo.
2. Do row 1 and row 2 above. Commit.
3. Add the two secrets (row 4).
4. *Actions* tab → enable workflows → run **Sync website into the app** (then **Build APK** runs).
5. Open *Releases* → download the APK → install on the phone (allow "install unknown apps").
6. Later updates: the app shows "Update available" → tap → install. The update is only accepted if it is signed with the same key, has a higher version, and comes from `ifinex_update_repo`.

### If you rename this repo
GitHub redirects the old name, but update row 1 (`ifinex_update_repo`) and row 2/5 immediately. Phones that run an APK built **before** the rename must install one new APK manually; after that, updates work again.

### Security rules
* Never commit a keystore, passwords, the Supabase `service_role` key or a with-data SQL file.
* Turn on 2FA and branch protection (`main`) — code pushed here is installed on every phone.

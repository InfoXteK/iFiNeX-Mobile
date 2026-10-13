#!/bin/bash
# Pulls the newest website from WEB_REPO and, if it differs from what is inside the app, replaces www/ and raises the patch version.
# Writes  changed=true|false  and  version=x.y.z  to $GITHUB_OUTPUT.
set -euo pipefail
: "${WEB_REPO:?WEB_REPO is not set}"; BR="${WEB_BRANCH:-main}"
OUTF="${GITHUB_OUTPUT:-/dev/stdout}"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
if [ -n "${WEB_ZIP:-}" ]; then cp "$WEB_ZIP" "$T/w.zip"; else curl -fsSL --retry 3 "https://codeload.github.com/$WEB_REPO/zip/refs/heads/$BR" -o "$T/w.zip"; fi
unzip -q "$T/w.zip" -d "$T/x"; SRC=$(ls -d "$T"/x/*/ | head -1); SRC=${SRC%/}
# sanity: refuse to ship something that is not the iFiNeX site
for f in bill-tracker.html index.html start.html ifinex-update.js ifinex-session.js ifinex-config.js ifinex-config.json vendor/ifinex-local.js; do [ -f "$SRC/$f" ] || { echo "::error::$f missing in $WEB_REPO@$BR — refusing to sync"; exit 1; }; done
grep -q "supabase" "$SRC/bill-tracker.html" || { echo "::error::unexpected website content"; exit 1; }
rm -rf "$SRC/.git" "$SRC/.github" "$SRC"/*.md "$SRC/CNAME" "$SRC/LICENSE" 2>/dev/null || true

PUB="$T/pub"; cp -r "$SRC" "$PUB"

CUR=www
if [ -d "$CUR" ] && diff -rq "$PUB" "$CUR" >/dev/null 2>&1; then
  echo "Website unchanged — nothing to do."; echo "changed=false" >> "$OUTF"; exit 0
fi
rm -rf "$CUR"; cp -r "$PUB" "$CUR"
python3 -I - <<'PY' >> "$OUTF"
import re
p='android/app/build.gradle'; s=open(p).read()
m=re.search(r'versionName "(\d+)\.(\d+)\.(\d+)"',s)
a,b,c=map(int,m.groups()); new=f'{a}.{b}.{c+1}'
s=s.replace(m.group(0),f'versionName "{new}"',1); open(p,'w').write(s)
import json
q='package.json'; d=json.load(open(q)); d['version']=new; open(q,'w').write(json.dumps(d,indent=2)+'\n')
print('changed=true'); print('version='+new)
PY
echo "Website changed — copied into the app and version raised."

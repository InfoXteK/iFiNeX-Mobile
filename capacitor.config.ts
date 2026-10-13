import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  // appId is intentionally UNCHANGED: a different id would install as a second, separate app and lose upgrade path.
  appId: 'io.github.squadsplit.app',
  appName: 'iFiNeX',
  webDir: 'www',
  backgroundColor: '#0b0b18',
  plugins: {
    // Used by the local (scheduled) notifications: status-bar glyph + tint. Files live in android/app/src/main/res/drawable-*/ic_stat_ifinex.png
    LocalNotifications: { smallIcon: 'ic_stat_ifinex', iconColor: '#4D96FF' }
  }
};

export default config;

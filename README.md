# WinAssurance
The project WinAssurance is a collection of scripts to analyse Windows settings.

## WinProxyAnalyser.ps1
WinProxyAnalyser.ps1 parses the proxy settings from Windows Registry DefaultConnectionSettings.

**You can manually review these settings in Internet Explorer via:**
1. Open _Internet Options_
2. Tab _Connections_
3. Button _LAN Settings_
4. Dialog _Local Area Network (LAN) Settings_ opens

**You can manually review these settings in Winows 10 settings:**
1. Open _Settings_
2. Select _Network & Internet_
3. Select _Proxy_

The table below maps out the settings and associated nibbles. The nibbles appear to be  AND connected to form the settings value.

| Binary  | Decimal | Setting Label IE | Setting Label Edge | Script Marker |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| 0001 | 1 | All LAN Settings Disabled | All Proxy Settings Disabled | *DISABLED* |
| 0011 | 3 | Only "Proxy Server" Enabled | Only "Use a proxy server" On | *PROXY* |
| 0101 | 5 | Only "Use automatic configuration script" Enabled (Default) | Only "Use setup script" On (Default) | *PAC* |
| 0111 | 7 | PAC and PROXY Enabled | PAC and PROXY Enabled | *PAC-PROXY* |
| 1001 | 9 | Only "Automatically detect settings" Enabled | Only "Automatically detect settings" Enabled | *WPAD* |
| 1011 | 11 | WPAD and PROXY Enabled | WPAD and PROXY Enabled | *WPAD-PROXY* |
| 1101 | 13 | WPAD and PAC Enabled | WPAD and PAC Enabled | *WPAD-PAC* |
| 1111 | 15 | WPAD and PAC and PROXY Enabled | WPAD and PAC and PROXY Enabled | *WPAD-PAC-PROXY* |

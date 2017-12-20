#----------------------------------------------------------------
# Title   : Micorsoft Windows Proxy Setting Analyser
# 
# Version : 0.4
# Author  : Oliver Kunz
# 
# Permissions Required:
#   Non-Administrative (read-only script)
#
# Description:
#   PowerShell script to analyse the IE / Win10 Proxy Settings
#   IE   => Internet Options -> LAN settings
#   Edge => Settings -> Network & Internet -> Proxy
#----------------------------------------------------------------

$PATH = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections\"
$INDEX = 8

$value = (Get-ItemProperty $PATH).DefaultConnectionSettings[$INDEX]

switch ($value) {
    # 0001	1	All LAN Settings Disabled
    1 {"Value: 1 => All Settings Disabled [DISABLED]"}

    # 0011	3	Only Proxy Settings Enabled (PROXY)
    3 {"Value: 3 => Only Proxy Settings Enabled [PROXY]"}

    # 0101	5	Only "Use automatic configuration script" Enabled (PAC)
    5 {"Value: 5 => Only 'Use automatic configuraiton script' Enabled [PAC]"}

    # 0111	7	PAC and PROXY Enabled
    7 {"Value: 7 => PAC and PROXY Enabled [PAC-PROXY]"}
    
    # 1001	9	Only "Automatically detect settings" Enabled (WPAD)
    9 {"Value: 9 => Only 'Automatically detect settings' Enabled [WPAD]"}
    
    # 1011	11	WPAD and PROXY Enabled
    11 {"Value: 11 => WPAD and PROXY Enabled [WPAD-PROXY]"}
    
    # 1101	13	WPAD and PAC Enabled
    13 {"Value: 13 => WPAD and PAC Enabled [WPAD-PAC]"}
    
    # 1111	15	WPAD and PAC and PROXY Enabled
    15 {"Value: 15 => WPAD and PAC and PROXY Enabled [WPAD-PAC-PROXY]"}
    
    # default
    default {"Value: " + $value + " => Value is unknown; Please contact author [UNKNOWN]"}
}

# Reference::
#    Registry Key Path and Registry Value Offset origin from a script by rysstad. 
#    Source: http://codegist.net/snippet/powershell/disable-wpadps1_rysstad_powershell

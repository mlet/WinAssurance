#----------------------------------------------------------------
# Title   : Windows WLAN PSK Analyser
# 
# Version : 0.8
# Author  : Oliver Kunz
# 
# Permissions Required:
#   Administrative (privileged script)
#
# Description:
#   PowerShell script to analyse local WLAN profiles configured 
#   on the host.
#   
#   CAUTION: THIS SCRIPT WILL DISPLAY THE PSK IN CLEARTEXT
#----------------------------------------------------------------

function main () {

    # List available WLAN Profiles
    Write-Host "`nWLAN Profiles Found on your Computer:`n" -ForegroundColor Yellow
    $localProfiles = getProfileNames
    $numOfLocalProfiles = $localProfiles.Length

    # Verify that we have WLAN Profiles configured
    if ($numOfLocalProfiles -gt 0) {
        
        # Write to console the Profile Name prepended by the array index.
        for ($i = 0; $i -le $numOfLocalProfiles - 1; $i++){
            Write-Host  ($i) "`t" $localProfiles[$i] -ForegroundColor DarkYellow
        }

    } else {
        Write-Host "** NO WLAN PROFILES FOUND! **" -ForegroundColor Red
        exit
    }        

    # Ask for WLAN Profile to Reveal PSK
    getProfilePSK(getUserInput)
    
}

# Retrieve user profile selection
function getUserInput () {
    Write-Host "`nSelect WLAN Profile: " -NoNewline -ForegroundColor DarkCyan
    $input = Read-Host

    return $input
}

# Retrieve WLAN PSK configured in a local profile (identified by $val)
function getProfilePSK ($val) {
    # $val can either be an index (int) or SSID (string)

    $data = @()

    try {
        # Check if users enters integer value

        # Verify that user did enter a value and that the integer is not larger than the array index (IndexOutOfBounds)
        if ([string]::IsNullOrEmpty($val)) {
            Write-Host "** INVALID VALUED ENTERED! **`nPlease choose an SSID from the list or an Index value between 0 and "((getProfileNames).Length - 1)  -ForegroundColor Red
            getProfilePSK(getUserInput)
        } elseif ([int]$val -gt ((getProfileNames).Length - 1)) {
            Write-Host "** INVALID INDEX VALUE ENTERED! **`nPlease choose an SSID from the list or an Index value between 0 and "((getProfileNames).Length - 1) -ForegroundColor Red
            getProfilePSK(getUserInput)
        } else {
            $profileName = (getProfileNames)[[int]$val].Trim()        
            $data += $profileName
            $data += (((netsh wlan show profiles name=$profileName key="clear") | Select-String "Key Content") -split ':')
            printAnswer($data)       
        }

    } catch {
        # User enters the SSID string
        $data += $val
        $data += (((netsh wlan show profiles name="$val" key="clear") | Select-String "Key Content") -split ':')
        printAnswer($data)
    }

}

# Print analysis to console
function printAnswer ([string[]]$inputData) {
    # Index 0 => SSID
    # Index 2 => PSK

    if ( !(veryProfileExistence($inputData[0])) ) {
        Write-Host "** INVALID SSID VALUE ENTERED! **`nPlease choose an SSID from the list or an Index value between 0 and "((getProfileNames).Length - 1) -ForegroundColor Red
        getProfilePSK(getUserInput)
    } elseif ( [string]::IsNullOrEmpty($inputData[2]) ) {
        Write-Host "Queried Profile : "$inputData[0] -ForegroundColor DarkYellow
        Write-Host "WLAN PSK`t`t:  **NO PSK CONFIGURED**" -ForegroundColor DarkYellow
    } else {
        Write-Host "Queried Profile : "$inputData[0] -ForegroundColor DarkYellow
        Write-Host "WLAN PSK`t`t: "$inputData[2].Trim() -ForegroundColor DarkYellow
    }

}

# Retrieve list of profile names
function getProfileNames () {
    $profiles = @()
    $data = (netsh wlan show profiles | Select-String "\:\ (.+)$") -split ':'
    
    # Iterate over the $data array and copy the profile names into the $profiles array
    for ($i = 1; $i -lt $data.Length; $i = $i + 2) {
        $profiles += $data[$i].Trim()
    }

    Remove-Variable data
    return $profiles
}

# Check if a profile name is in the local profile list
function veryProfileExistence ($toCheck) {
    $allProfiles = getProfileNames
    return $allProfiles -contains $toCheck
}

# Run the script
main

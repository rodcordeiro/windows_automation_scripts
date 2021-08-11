# Author: ALiangLiang <me@aliangliang.top>

# Replace VPN_NAME, ADDRESS and ACCOUNT first!!
# Ref: https://docs.microsoft.com/en-us/powershell/module/vpnclient/add-vpnconnection?view=win10-ps

$VPN_NAME = 'VPN'
$ADDRESS = 'vpn.example.com'
$ACCOUNT = 'user1'

function Connect {
    # Get password from prompt
    $pass = Read-Host 'What is your password?' -AsSecureString
    $pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))

    # Establish VPN configuration
    # Ref: https://docs.microsoft.com/en-us/powershell/module/vpnclient/add-vpnconnection?view=win10-ps
    Add-VpnConnection -Name "$VPN_NAME" -ServerAddress "$ADDRESS" -TunnelType PPTP -EncryptionLevel Required -RememberCredential -PassThru

    # Connect the VPN configuration
    $code = (Start-Process rasdial -NoNewWindow -ArgumentList "$VPN_NAME $ACCOUNT $pass" -PassThru -Wait).ExitCode
    
    if ("$code" -eq "0") {
        Write-Host "Create and connect to VPN server success" -ForegroundColor DarkGreen

        return $true
    } else {
        # Error codes: https://support.microsoft.com/en-us/help/824864/list-of-error-codes-for-dial-up-connections-or-vpn-connections
        if ("$code" -eq "691") {
            Write-Host "Create and connect to VPN server failed with wrong username or password" -ForegroundColor DarkRed

            return $false # return and try againg
        } else {
            Write-Host "Create and connect to VPN server failed with error code: $($code)" -ForegroundColor DarkRed
            
            throw "$code"
        }

    }
}

function Disconnect {
    # Disconnect
    rasdial "$VPN_NAME" /DISCONNECT

    # Remove it
    Remove-VpnConnection -Name "$VPN_NAME" -Force
    
    Write-Host "Disconnect and remove VPN connection success" -ForegroundColor Magenta
}

function Pause {
    param($text)
    write-host "$text"
    [void][System.Console]::ReadKey($true)
}

# If no connection created before...
if (-Not [bool] (Get-VpnConnection -Name "$VPN_NAME")){
    while (Connect) {}

    # Pause the progress
    Pause -text "Press any key to stop VPN..."
}

Disconnect

# Pause the progress
Pause -text "Press any key to close window..."

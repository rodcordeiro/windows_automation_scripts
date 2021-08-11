
<#PSScriptInfo

.VERSION 1.0

.GUID 45e21021-3511-4787-9e32-b6d08b653d13

.AUTHOR Rodrigo Cordeiro <rodrigomendoncca@gmail.com>

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI https://rodcordeiro.com.br/

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 
.SYNOPSIS
 Manage VPN connections to create, connect and delete VPN 
.DESCRIPTION 
 Manage VPN connections to create, connect and delete VPN 
.PARAMETER <Name>
 Nome a ser usado na VPN
.PARAMETER <Server>
 Servidor a ser utilizado
.PARAMETER <Protocol>
 Protocolo a ser usado, os valores aceitados são PPTP e L2TP
.PARAMETER <L2tpPSK>
 L2TP Pre-Shared Key
.PARAMETER <Domain>
 Sufixo de Domínio, o mesmo será utilizado para as configurações de rede
.PARAMETER [Account | User | Username]
 Usuário utilizado para a configuração da VPN
.PARAMETER <Password>
 Senha a ser utilizada na VPN. Pontuando que não deve ser utilizado $ na senha, pois o powershell interpreta como variável
.EXAMPLE
 .\vpn.ps1 -Name "VPN Connection" -Server 1.1.1.1 -Domain domain.local -Account User -Protocol pptp -Password z3Rd7sma#7k#oe
.EXAMPLE
 .\vpn.ps1 -Name "VPN Connection" -Server 1.1.1.1 -Domain domain.local -Account User -Protocol L2TP -L2tpPSK  123123 -Password z3Rd7sma#7k#oe
#> 
Param(
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="VPN display name")]
    [Alias("Name")]
    [ValidateNotNullOrEmpty()]
    [string]
    $vpn_name = "VPN_NAME",
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="VPN Server"
    )]
    [ValidateNotNullOrEmpty()]
    [Alias('Server')]
    [string]
    $vpn_server= "VPN_SERVER",
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="VPN Tunnel type"
    )]
    [ValidateSet("PPTP","L2TP")]
    [Alias("Protocol")]
    [string]
    $tunnelType = "VPN_PROTOCOL",
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="Domain suffix"
    )]
    [Alias("Domain")]
    [string]
    $domain_name = "domain.local",
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="L2TP PSK"
    )]
    [string]
    $L2tpPSK,
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="Rasphone PBK settings that must be changed"
    )]
    [hashtable]
    $vpn_default_settings = @{
        "UseRasCredentials"=0;
        "ExcludedProtocols"=8;
        "IpDnsFlags"=3;
    },
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="Rasphone PBK file path"
    )]
    [string]
    $pbkFile =$(resolve-path -path "$env:APPDATA\Microsoft\Network\Connections\Pbk\rasphone.pbk"),
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="Domain suffix"
    )]
    [Alias("Account","User","Username")]
    [string]
    $vpn_account = "someUser",
    
    [parameter(ValueFromPipelineByPropertyName,
    HelpMessage="Domain suffix"
    )]
    [Alias("Password")]
    [string]
    $vpn_password
)

function create_vpn_connection(){
<#
.SYNOPSIS
  Create a new VPN connection
#>
    $hasVPN = Get-VpnConnection -Name $vpn_name -ErrorAction SilentlyContinue
    if (!$hasVPN) {

        if($L2tpPSK){            
            $vpn_default_settings.Add("IpSecFlags",1)
            $vpn_default_settings.Add("PreferredHwFlow",1)
            $vpn_default_settings.Add("PreferredProtocol",1)
            $vpn_default_settings.Add("PreferredCompression",1)
            $vpn_default_settings.Add("PreferredSpeaker",1)
            $vpn_default_settings.Add("AuthRestrictions",544)

            Add-VPNConnection -Force -Name $vpn_name -ServerAddress $vpn_server -TunnelType $tunnelType  -L2tpPsk $L2tpPSK -RememberCredential -SplitTunneling -AuthenticationMethod MSChapv2 -DnsSuffix $domain_name -ErrorVariable $vpnCreationError

        } else {

            Add-VPNConnection -Name $vpn_name -ServerAddress $vpn_server -TunnelType $tunnelType -RememberCredential -SplitTunneling -AuthenticationMethod MSChapv2 -DnsSuffix $domain_name -ErrorVariable $vpnCreationError

        }

        if(!$vpnCreationError){
            Update-RASPhoneBook -Path $pbkFile -ProfileName $vpn_name -Settings  $vpn_default_settings -ErrorVariable $vpnCreationError
        }

        if(!$vpnCreationError){
            connect_vpn
        }

    } else {
        Write-Host "VPN already exists"
    }
}

function connect_vpn(){
    rasdial $vpn_name $vpn_account $vpn_password
}

Function Update-RASPhoneBook {
<#
.Synopsis
 Updates the rasphone book with custom settings
.description
 https://github.com/richardhicks/aovpn/blob/master/Update-Rasphone.ps1
#>
    [CmdletBinding(SupportsShouldProcess)]

    Param (

        [string]$Path,
        [string]$ProfileName,
        [hashtable]$Settings

    )

    $pattern = "(\[.*\])"
    $c = Get-Content $path -Raw
    $p = [System.Text.RegularExpressions.Regex]::Split($c, $pattern, "IgnoreCase") | Where-Object { $_ }

    # // Create a hashtable of VPN profiles
    Write-Verbose "Initializing a hashtable for VPN profiles from $path..."
    $profHash = [ordered]@{}

    For ($i = 0; $i -lt $p.count; $i += 2) {

        Write-Verbose "Adding $($p[$i]) to VPN profile hashtable..."
        $profhash.Add($p[$i], $p[$i + 1])

    }

    # // An array to hold changed values for -Passthru
    $pass = @()

    Write-Verbose "Found the following VPN profiles: $($profhash.keys -join ',')."

    $compare = "[$Profilename]"
    
    Write-Verbose "Searching for VPN profile $compare..."
    # // Need to make sure to get the exact profile
    $SelectedProfile = $profHash.GetEnumerator() | Where-Object { $_.name -eq $compare }

    If ($SelectedProfile) {

        Write-Verbose "Updating $($SelectedProfile.key)"
        $pass += $SelectedProfile.key

        $Settings.GetEnumerator() | ForEach-Object {

            $SettingName = $_.name
            Write-Verbose "Searching for setting $Settingname..."
            $Value = $_.Value
            $thisName = "$SettingName=.*\s?`n"
            $thatName = "$SettingName=$value`n"
            If ($SelectedProfile.Value -match $thisName) {

                Write-Verbose "Setting $SettingName = $Value."
                $SelectedProfile.value = $SelectedProfile.value -replace $thisName, $thatName
                $pass += ($ThatName).TrimEnd()
                # // Set a flag indicating the file should be updated
                $ChangeMade = $True

            }

            Else {

                Write-Warning "Could not find an entry for $SettingName under [$($SelectedProfile.key)]."

            }

        } #ForEach setting

        If ($ChangeMade) {

            # // Update the VPN profile hashtable
            $profhash[$Selectedprofile.key] = $Selectedprofile.value

        }

    } #If found

    Else {

        Write-Warning "VPN Profile [$profilename] not found."

    }

    # // Only update the file if changes were made
    If (($ChangeMade) -AND ($pscmdlet.ShouldProcess($path, "Update RAS PhoneBook"))) {

        Write-Verbose "Updating $Path"
        $output = $profHash.Keys | ForEach-Object { $_ ; ($profhash[$_] | Out-String).trim(); "`n" }
        $output | Out-File -FilePath $Path -Encoding ascii

    } #Whatif

} 

create_vpn_connection

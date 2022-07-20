
<#
.SYNOPSIS
Connects to a remote machine.

.DESCRIPTION
A wrapper for connecting to remote servers via PSSession. It includes the parameters for authentication and credentials.

.PARAMETER Server
The server to which you wish to connect.
https://github.com/krispharper/Powershell-Scripts/blob/master/Connect-ToServer.ps1
.\referencies\ps\ConnectTo-Server.ps1 SRV-DEV-SQL12
#>
param (
    [Parameter(Position=1, Mandatory=$true)]
    [string] $Server
)

$session = New-PSSession -ComputerName $Server -Credential $(Get-Credential) -Authentication Credssp
# $session = New-PSSession -ComputerName $Server -Credential $(Get-Credential) -Authentication Kerberos
Invoke-Command -Session $session -ScriptBlock { . $args[0] } -ArgumentList $profile
Enter-PSSession $session
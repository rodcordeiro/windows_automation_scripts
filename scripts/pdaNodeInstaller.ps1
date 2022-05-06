
<#PSScriptInfo

.VERSION 1.0

.GUID a6dfe468-8c6b-40c5-a142-4d55cd984b1f

.AUTHOR Rodrigo Cordeiro

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA
0
#>

<# 
.Synopsis
 Install needed tools for PDA Etiquetas
.DESCRIPTION 
 Install the needed tools for running PDA Etiquetas, as chocolatey and node v14.
.Inputs
 There's no input for this script
.outputs
 There's no input for this script
.EXAMPLE
 .\pdaNodeInstaller.ps1
#> 

Param()

Add-Type -AssemblyName PresentationFramework

$OutputEncoding = [Console]::OutputEncoding = New-Object System.Text.Utf8Encoding

New-Item -Type directory -Name 'PDA' -Path "C:\" | Out-Null

Start-Transcript -Path "C:\PDA\PDAPrinterApp_Installation.log" -Append -NoClobber -IncludeInvocationHeader

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

$title = 'Informe a porta a ser utilizada da API:'
$msg   = 'Lembrando que esta porta e referente a API de producao do cliente!'

$PORT = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
if (!$PORT){
    Write-Host "A porta deve ser especificada!"
	Stop-Transcript
	return
}
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install nodejs --version 14.17.3 -y

Invoke-WebRequest -Uri "http://189.113.15.118:$PORT/api/atualizacao/etiquetas/pda-etiquetas.exe" -outfile "C:\PDA\pda-etiquetas.exe"

Invoke-Expression "C:\PDA\pda-etiquetas.exe"
Stop-Transcript


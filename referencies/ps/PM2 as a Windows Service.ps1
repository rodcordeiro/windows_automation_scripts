# Deploys application as an app within a PM2 service
# Run from root of Node application
# https://gist.github.com/mauron85/e55b3b9d722f91366c50fddf2fca07a4
param(
    [string] $Pm2Home = $env:PM2_HOME,
    [string] $AppStart = "app.js"
)

$ErrorActionPreference = "Stop"

function Install-Node-Modules {
    Write-Host "Running npm install"
    & "npm" i
}

function Create-Pm2-Home {
    Write-Host "Attempting to create $Pm2Home and give FullControl to LOCAL SERVICE"
    New-Item -ItemType Directory -Force -Path $Pm2Home

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "LOCAL SERVICE", "FullControl", "ContainerInherit, ObjectInherit",
        "None", "Allow")

    try {
        $acl = Get-Acl -Path $Pm2Home -ErrorAction Stop
        $acl.SetAccessRule($rule)
        Set-Acl -Path $Pm2Home -AclObject $acl -ErrorAction Stop
        Write-Host "Successfully set FullControl permissions on $Pm2Home"
    }
    catch {
        throw "$Pm2Home : Failed to set permissions. Details : $_"
    }
}

function Set-Daemon-Permissions {
    $daemonPath = "$(npm config get prefix)\node_modules\@innomizetech\pm2-windows-service\src\daemon"
    Write-Host "Attempting to create $daemonPath and give FullControl to LOCAL SERVICE"
    New-Item -ItemType Directory -Force -Path $daemonPath

    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "LOCAL SERVICE", "FullControl", "ContainerInherit, ObjectInherit",
        "None", "Allow")

    try {
        $acl = (Get-Item $daemonPath).GetAccessControl('Access')
        $acl.SetAccessRule($rule)
        Set-Acl -Path $daemonPath -AclObject $acl -ErrorAction Stop
        Write-Host "Successfully set FullControl permissions on $daemonPath"
    }
    catch {
        throw "$daemonPath : Failed to set permissions. Details : $_"
    }
}

function Install-Pm2-Service {
    Write-Host "Installing pm2"
    & "npm" i "pm2@latest" "-g"
    Write-Host "Installing pm2-windows-service npm module"
    & "npm" i "@innomizetech/pm2-windows-service" "-g"
    & "pm2-service-install" "--unattended"
	
    # Create wrapper log file, otherwise it won't start
    $wrapperLogPath = "$(npm config get prefix)\node_modules\@innomizetech\pm2-windows-service\src\daemon\pm2.wrapper.log"
	
    if (Test-Path $wrapperLogPath) {
        Write-Debug "PM2 service wrapper log file already exists"
    }
    else {
        Out-File $wrapperLogPath -Encoding utf8
    }
}

function Create-Pm2-Service-Config {
    param([string] $ConfigPath, [string] $CmdPath)

    $configContent = @"
{
	"apps": [{
		"name": "node-app",
		"script": "$($CmdPath -replace "\\","\\")",
		"args": [],
		"cwd": "$((Split-Path $CmdPath) -replace "\\","\\")",
		"merge_logs": true,
		"instances": 4,
		"exec_mode": "cluster_mode",
		"env": {
			"NODE_ENV": "development"
		}
	}]
}
"@

    # Write out config to JSON file
    Write-Host "Writing PM2 service configuration to $ConfigPath"
    $configContent | Out-File $ConfigPath -Encoding utf8
}

# From http://stackoverflow.com/a/4370900/964356
function Set-ServiceAcctCreds {
    param([string] $serviceName, [string] $newAcct, [string] $newPass)

    $filter = "Name='$serviceName'"

    $tries = 0
	
    while (($service -eq $null -and $tries -le 3)) {
        if ($tries -ne 0) {
            sleep 2
        }
        $service = Get-WMIObject -namespace "root\cimv2" -class Win32_Service -Filter $filter
        $tries = $tries + 1
    }

    if ($service -eq $null) {
        throw "Could not find '$serviceName' service"
    }

    $service.Change($null, $null, $null, $null, $null, $null, $newAcct, $newPass)

    $service.StopService()

    while ($service.Started) {
        sleep 2
        $service = Get-WMIObject -namespace "root\cimv2" -class Win32_Service -Filter $filter
    }
    $service.StartService()
}

function Change-Pm2-Service-Account {
    Write-Host "Changing PM2 to run as LOCAL SERVICE"
    Set-ServiceAcctCreds -serviceName "pm2.exe" -newAcct "NT AUTHORITY\LocalService" -newPass ""
}

$env:PM2_HOME = $Pm2Home
$env:PM2_SERVICE_SCRIPTS = "$Pm2Home\ecosystem.json"
$env:PM2_SERVICE_PM2_DIR = "$(npm config get prefix)\node_modules\pm2\index.js"

[Environment]::SetEnvironmentVariable("PM2_HOME", $env:PM2_HOME, "Machine")
[Environment]::SetEnvironmentVariable("PM2_SERVICE_SCRIPTS", $env:PM2_SERVICE_SCRIPTS, "Machine")
[Environment]::SetEnvironmentVariable("PM2_SERVICE_PM2_DIR", $env:PM2_SERVICE_PM2_DIR, "Machine")
[Environment]::SetEnvironmentVariable("SET_PM2_HOME", "true", "Machine")
[Environment]::SetEnvironmentVariable("SET_PM2_SERVICE_PM2_DIR", "true", "Machine")
[Environment]::SetEnvironmentVariable("SET_PM2_SERVICE_SCRIPTS", "true", "Machine")

& Install-Node-Modules
& Create-Pm2-Home
& Create-Pm2-Service-Config -ConfigPath $env:PM2_SERVICE_SCRIPTS -CmdPath $AppStart
& Install-Pm2-Service
& Set-Daemon-Permissions
& Change-Pm2-Service-Account
# it is need for correct cyrilic symbols in old OS
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
function Get-LatestUpdate {
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.Update.Session') | Out-Null
    $Session = New-Object -ComObject Microsoft.Update.Session                    
    $UpdateSearcher = $Session.CreateUpdateSearcher()
    $NumUpdates = $UpdateSearcher.GetTotalHistoryCount()
    $InstalledUpdates = $UpdateSearcher.QueryHistory(1, $NumUpdates)
    $LastInstalledUpdate = $InstalledUpdates | Select-Object Title, Date | Sort-Object -Property Date -Descending | Select-Object -first 1

    return $LastInstalledUpdate.Date
}


function Test-PendingReboot {
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $True }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $True }
    return $False
}


function Get-Chassis {  
      
    $chassis = Get-WmiObject win32_systemenclosure | Select-Object chassistypes  
    $result = ""
    switch ($chassis.chassistypes) { 
        "3" { $result = "Desktop" } 
        "4" { $result = "Low Profile Desktop" } 
        "5" { $result = "Pizza Box" } 
        "6" { $result = "Mini Tower" }  
        "7" { $result = "Tower" } 
        "8" { $result = "Portable" }  
        "9" { $result = "Laptop" } 
        "10" { $result = "Notebook" }  

        "11" { $result = "Hand Held" }  
        "12" { $result = "Docking Station" }  
        "13" { $result = "All in One" }  
        "14" { $result = "Sub Notebook" }  
        "15" { $result = "Space-Saving" }  
        "16" { $result = "Lunch Box" }  
        "17" { $result = "Main System Chassis" }  

        "18" { $result = "Expansion Chassis" }  
        "19" { $result = "Sub Chassis" }  
        "20" { $result = "Bus Expansion Chassis" }  
        "21" { $result = "Peripheral Chassis" }  
        "22" { $result = "Storage Chassis" }  
        "23" { $result = "Rack Mount Chassis" }  
        "24" { $result = "Sealed-Case PC" }  

        "26" { $result = "Compact PCI" }  
        "27" { $result = "Advanced TCA" }  
        "28" { $result = "Blade" }  
        "29" { $result = "Blade Enclosure" }  
        "30" { $result = "Tablet" }  
        "31" { $result = "Convertible" }  
        "32" { $result = "Detachable" }  
        "33" { $result = "IoT Gateway" }  
        "34" { $result = "Embedded PC" }  
        "35" { $result = "Mini PC" }  
        "36" { $result = "" }  

        default { $result = "Unknown" } 
    }    
    return $result 
}  
Function Get-FirewallState {
    [CmdletBinding()]
	
    $ErrorActionPreference = "Stop"
    Try {

        $HKLM = 2147483650
        $reg = get-wmiobject -list -namespace root\default  | where-object { $_.name -eq "StdRegProv" }
        $DomainProfileEnabled = $reg.GetDwordValue($HKLM, "System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile", "EnableFirewall")
        $DomainProfileEnabled = [int]($DomainProfileEnabled.uValue)
        $PrivateProfileEnabled = $reg.GetDwordValue($HKLM, "System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PrivateProfile", "EnableFirewall")
        $PrivateProfileEnabled = [int]($PrivateProfileEnabled.uValue)
        $PublicProfileEnabled = $reg.GetDwordValue($HKLM, "System\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile", "EnableFirewall")
        $PublicProfileEnabled = [int]($PublicProfileEnabled.uValue)
        $FirewallObject = New-Object PSObject
        Add-Member -inputObject $FirewallObject -memberType NoteProperty -name "DomainProfile" -value $DomainProfileEnabled 
        Add-Member -inputObject $FirewallObject -memberType NoteProperty -name "PrivateProfile" -value $PrivateProfileEnabled  
        Add-Member -inputObject $FirewallObject -memberType NoteProperty -name "PublicProfile" -value $PublicProfileEnabled 
        return $FirewallObject
    }
    Catch {
        Write-Host  ($_.Exception.Message -split ' For')[0] -ForegroundColor Red
    }
}

$result = New-Object PSCustomObject

######################  host
$hostname = $env:COMPUTERNAME
$result | Add-Member -type NoteProperty -name Hostname  -Value $hostname

######################  get serial number and bios
$bios = (Get-WmiObject win32_bios)
$bios_Manufacturer = $bios.Manufacturer
$bios_Version = $bios.Name
$computer_serialNumber = $bios.serialnumber
$bios_SMBIOSBIOSVersion = $bios.SMBIOSBIOSVersion

$result | Add-Member -type NoteProperty -name BiosManufacturer -Value $bios_Manufacturer
$result | Add-Member -type NoteProperty -name BiosVersion -Value $bios_Version 
$result | Add-Member -type NoteProperty -name SMBIOSBIOSVersion -Value  $bios_SMBIOSBIOSVersion
$result | Add-Member -type NoteProperty -name SerialNumber -Value $computer_serialNumber

######################  os
$os = Get-WmiObject Win32_OperatingSystem
$os_vendor = $os.Manufacturer
$os_buildversion = $os.BuildNumber
$os_Version = $os.Version
$os_title = $os.Caption
$os_installdate = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($(get-itemproperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion').InstallDate)) 
$BootTime = $os.ConvertToDateTime($os.LastBootUpTime) 
$Uptime = [math]::Round( ($os.ConvertToDateTime($os.LocalDateTime) - $boottime).TotalSeconds)
$update_latest_date = Get-LatestUpdate
$StartDate = (GET-DATE)
$update_latest_seconds = [math]::Round(($StartDate - $update_latest_date).TotalSeconds)
$pending_reboot = Test-PendingReboot
$pending_reboot = [System.Convert]::ToInt32($pending_reboot)

$result | Add-Member -type NoteProperty -name OSVendor -Value $os_vendor
$result | Add-Member -type NoteProperty -name OSBuildversion -Value $os_buildversion
$result | Add-Member -type NoteProperty -name OSVersion -Value $os_Version
$result | Add-Member -type NoteProperty -name OSTitle -Value $os_title
$result | Add-Member -type NoteProperty -name OSInstallDate -Value $os_installdate.tostring("dd.MM.yyyy")
$result | Add-Member -type NoteProperty -name OSLatestUpdatesInstalled -Value $update_latest_date.tostring("dd.MM.yyyy")
$result | Add-Member -type NoteProperty -name OSSecondsFromLatestUpdatesInstalled -Value $update_latest_seconds
$result | Add-Member -type NoteProperty -name OSUptime  -Value  $Uptime
$result | Add-Member -type NoteProperty -name PendingReboot -Value $pending_reboot 

###################### cpu
$cpu_atchitecture = $ENV:PROCESSOR_ARCHITECTURE
$cpu_model = (Get-WmiObject -class win32_processor).Name
$result | Add-Member -type NoteProperty -name CPUModel -Value $cpu_model
$result | Add-Member -type NoteProperty -name ComputerArchitecture -Value $cpu_atchitecture

######################  memory
$TotalVisibleMemorySize = $os.TotalVisibleMemorySize * 1024 # in bytes
$result | Add-Member -type NoteProperty -name TotalPhysicalMemory -Value $TotalVisibleMemorySize

######################  powershell version
$env = $PSVersionTable
$shell_versions = New-Object PSCustomObject
$shell_versions  | Add-Member -type NoteProperty -name PowerShell  -Value $env.PSVersion.ToString()
$shell_versions  | Add-Member -type NoteProperty -name CLR  -Value $env.CLRVersion.ToString()

### check psremoting
$psremoting_active = $false
$test = [bool](Test-WSMan -ComputerName $env:COMPUTERNAME -ErrorAction SilentlyContinue)
if ($test -eq $true) {
    $psremoting_active = 1
}
else {
    $psremoting_active = 0
}

### get zabbix agent version
$zabbix_service_path = (Get-WmiObject win32_service | Where-Object { $_.name -eq 'Zabbix Agent' } ).pathname
if ($zabbix_service_path) {
    $zabbix_agent_path = $zabbix_service_path.substring(0, $zabbix_service_path.IndexOf("--config")).replace("""", "")
    $zabbix_version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($zabbix_agent_path).FileVersion
}
$shell_versions  | Add-Member -type NoteProperty -name PSRemotingActive -Value $psremoting_active     

$result | Add-Member -type NoteProperty -name ShellVersion  -Value  $shell_versions 
$result | Add-Member -type NoteProperty -name ZabbixAgentVersion -Value $(if ($zabbix_version) { $zabbix_version } else { $null })

######################  physical
$computer = Get-WmiObject Win32_Computersystem
$computer_domain = $computer.domain
$chassis = Get-Chassis
$motherboadr = Get-WmiObject Win32_BaseBoard | Select-Object Manufacturer, Product

$result | Add-Member -type NoteProperty -name Domain  -Value $computer_domain
$result | Add-Member -type NoteProperty -name ComputerManufacturer  -Value $computer.Manufacturer
$result | Add-Member -type NoteProperty -name ComputerModel  -Value $computer.Model
$result | Add-Member -type NoteProperty -name ComputerNumberOfLogicalProcessors  -Value $computer.NumberOfLogicalProcessors
$result | Add-Member -type NoteProperty -name ComputerNumberOfProcessors  -Value $computer.NumberOfProcessors
$result | Add-Member -type NoteProperty -name Chassis  -Value     $chassis 
$result | Add-Member -type NoteProperty -name MotherboardManufacturer -Value $motherboadr.Manufacturer
$result | Add-Member -type NoteProperty -name MotherboardProduct -Value $motherboadr.Product 

###################### firewall
$firewall_status = Get-FirewallState 
$result | Add-Member -type NoteProperty -name FirewallStatus -Value   $firewall_status


###################### network
$nwINFO = Get-WmiObject  Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -ne $null } | Select-Object IPAddress, IpSubnet, DefaultIPGateway, MACAddress, DNSServerSearchOrder
$result | Add-Member -type NoteProperty -name Networks -Value $nwINFO 


###################### antivirus
$AntiVirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ErrorAction SilentlyContinue
switch ($AntiVirusProduct.productState) { 
    "262144" { $defstatus = "Up to date" ; $rtstatus = 0 } 
    "262160" { $defstatus = "Out of date" ; $rtstatus = 0 } 
    "266240" { $defstatus = "Up to date" ; $rtstatus = 1 } 
    "266256" { $defstatus = "Out of date" ; $rtstatus = 1 } 
    "393216" { $defstatus = "Up to date" ; $rtstatus = 0 } 
    "393232" { $defstatus = "Out of date" ; $rtstatus = 0 } 
    "393488" { $defstatus = "Out of date" ; $rtstatus = 0 } 
    "397312" { $defstatus = "Up to date" ; $rtstatus = 1 } 
    "397328" { $defstatus = "Out of date" ; $rtstatus = 1 } 
    "397584" { $defstatus = "Out of date" ; $rtstatus = 1 } 
    "397568" { $defstatus = "Up to date"; $rtstatus = 1 }
    "393472" { $defstatus = "Up to date" ; $rtstatus = 0 }
    default { $defstatus = "Unknown" ; $rtstatus = -1 } 
}

$antivirus = New-Object PSCustomObject
$antivirus  | Add-Member -type NoteProperty -name ProductName -Value   $AntiVirusProduct.displayName
$antivirus  | Add-Member -type NoteProperty -name ProductExe -Value   $AntiVirusProduct.pathToSignedProductExe
$antivirus  | Add-Member -type NoteProperty -name ProductUpdateStatus -Value   $defstatus
$antivirus  | Add-Member -type NoteProperty -name ProductRealTimeProtection -Value   $rtstatus
$result | Add-Member -type NoteProperty -name Antivirus -Value $antivirus

###################### disks
$disks = New-Object PSCustomObject
Get-Disk | ForEach-Object {
    # Get disk info
    $disk = New-Object PSCustomObject
    $disk | Add-Member -type NoteProperty -name Name  -Value $_.FriendlyName
    $disk | Add-Member -type NoteProperty -name Health  -Value $_.HealthStatus
    $disk | Add-Member -type NoteProperty -name SerialNumber  -Value $_.SerialNumber
    $disk | Add-Member -type NoteProperty -name total_size  -Value $_.Size
    $disk | Add-Member -type NoteProperty -name isSystem  -Value $_.IsSystem
    $disk | Add-Member -type NoteProperty -name objId  -Value $_.ObjectId
    $disk | Add-Member -type NoteProperty -name Status  -Value $_.OperationalStatus
    $disk | Add-Member -type NoteProperty -name disk_id  -Value $_.Number
    
    # Get disk status
    $t = $_ | Get-StorageReliabilityCounter
    $disk | Add-Member -type NoteProperty -name temperature  -Value $t.Temperature
    # Write-Host $disk
    
    $disks | Add-Member -type NoteProperty -name $_.FriendlyName  -Value $disk
    
}
$result  | Add-Member -type NoteProperty -name Disk  -Value $disk


$result | ConvertTo-Json
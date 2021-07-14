[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

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
class Inventory{
    [PSCustomObject]$inventoryData
    
    [datetime]GetLatestUpdate(){
        [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.Update.Session') | Out-Null    
        $Session = New-Object -ComObject Microsoft.Update.Session                    
        $UpdateSearcher = $Session.CreateUpdateSearcher()
        $NumUpdates = $UpdateSearcher.GetTotalHistoryCount()
        $InstalledUpdates = $UpdateSearcher.QueryHistory(1, $NumUpdates)
        $LastInstalledUpdate = $InstalledUpdates | Select-Object Title, Date | Sort-Object -Property Date -Descending | Select-Object -first 1

        return $LastInstalledUpdate.Date
    }
    [bool]TestPendingReboot(){
        if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $True }
        if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $True }
        return $False
    }
    [string]GetChassis(){  
      
        $chassis = Get-WmiObject win32_systemenclosure | Select-Object chassistypes  
        $result = ""
        switch ($chassis.chassistypes) { 
            "3" {  $result = "Desktop"} 
            "4" {  $result = "Low Profile Desktop"} 
            "5" {  $result = "Pizza Box"} 
            "6" {  $result = "Mini Tower"}  
            "7" {  $result = "Tower"} 
            "8" {  $result = "Portable"}  
            "9" {  $result = "Laptop"} 
            "10" {  $result = "Notebook"}  
    
            "11" {  $result = "Hand Held"}  
            "12" {  $result = "Docking Station"}  
            "13" {  $result = "All in One"}  
            "14" {  $result = "Sub Notebook"}  
            "15" {  $result = "Space-Saving"}  
            "16" {  $result = "Lunch Box"}  
            "17" {  $result = "Main System Chassis"}  
    
            "18" {  $result = "Expansion Chassis" }  
            "19" {  $result = "Sub Chassis"}  
            "20" {  $result = "Bus Expansion Chassis"}  
            "21" {  $result = "Peripheral Chassis"}  
            "22" {  $result = "Storage Chassis"}  
            "23" {  $result = "Rack Mount Chassis"}  
            "24" {  $result = "Sealed-Case PC"}  
    
            "26" {  $result = "Compact PCI"}  
            "27" {  $result = "Advanced TCA"}  
            "28" {  $result = "Blade"}  
            "29" {  $result = "Blade Enclosure"}  
            "30" {  $result = "Tablet"}  
            "31" {  $result = "Convertible"}  
            "32" {  $result = "Detachable"}  
            "33" {  $result = "IoT Gateway"}  
            "34" {  $result = "Embedded PC"}  
            "35" {  $result = "Mini PC"}  
            "36" {  $result = ""}  
    
            default {  $result = "Unknown"} 
        }    
        return $result 
    }

    [void]getHostname(){
        $hostname = $env:COMPUTERNAME
        $this.inventoryData | Add-Member -type NoteProperty -name Hostname  -Value $hostname

    }
    [void]get_serial_and_bios(){
        $bios = (Get-WmiObject win32_bios)
        $bios_Manufacturer = $bios.Manufacturer
        $bios_Version = $bios.Name
        $computer_serialNumber = $bios.serialnumber
        $bios_SMBIOSBIOSVersion = $bios.SMBIOSBIOSVersion

        $bios_info =  New-Object PSCustomObject
        $bios_info | Add-Member -type NoteProperty -name BiosManufacturer -Value $bios_Manufacturer
        $bios_info | Add-Member -type NoteProperty -name BiosVersion -Value $bios_Version 
        $bios_info | Add-Member -type NoteProperty -name SMBIOSBIOSVersion -Value  $bios_SMBIOSBIOSVersion
        $bios_info | Add-Member -type NoteProperty -name SerialNumber -Value $computer_serialNumber
        
        $this.inventoryData | Add-Member -type NoteProperty -name Bios_info -Value $bios_info
        
    }
    [void]get_os_info(){
        $os = Get-WmiObject Win32_OperatingSystem
        $os_vendor = $os.Manufacturer
        $os_buildversion = $os.BuildNumber
        $os_Version = $os.Version
        $os_title = $os.Caption
        $os_installdate = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($(get-itemproperty 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion').InstallDate)) 
        $BootTime = $os.ConvertToDateTime($os.LastBootUpTime) 
        $Uptime = [math]::Round( ($os.ConvertToDateTime($os.LocalDateTime) - $boottime).TotalSeconds)
        $update_latest_date = $this.GetLatestUpdate()
        $StartDate = (GET-DATE)
        $update_latest_seconds = [math]::Round(($StartDate - $update_latest_date).TotalSeconds)
        $pending_reboot = $this.TestPendingReboot()
        $pending_reboot = [System.Convert]::ToInt32($pending_reboot)
        
        $os_info =  New-Object PSCustomObject
        $os_info | Add-Member -type NoteProperty -name OSVendor -Value $os_vendor
        $os_info | Add-Member -type NoteProperty -name OSBuildversion -Value $os_buildversion
        $os_info | Add-Member -type NoteProperty -name OSVersion -Value $os_Version
        $os_info | Add-Member -type NoteProperty -name OSTitle -Value $os_title
        $os_info | Add-Member -type NoteProperty -name OSInstallDate -Value $os_installdate.tostring("dd.MM.yyyy")
        $os_info | Add-Member -type NoteProperty -name OSLatestUpdatesInstalled -Value $update_latest_date.tostring("dd.MM.yyyy")
        $os_info | Add-Member -type NoteProperty -name OSSecondsFromLatestUpdatesInstalled -Value $update_latest_seconds
        $os_info | Add-Member -type NoteProperty -name OSUptime  -Value  $Uptime
        $os_info | Add-Member -type NoteProperty -name PendingReboot -Value $pending_reboot 
        
        $this.inventoryData | Add-Member -type NoteProperty -name OS_info -Value $os_info
    }
    [void]get_network_info(){
        $nwINFO = Get-WmiObject  Win32_NetworkAdapterConfiguration | Where-Object { $null -ne $_.IPAddress } | Select-Object IPAddress, IpSubnet, DefaultIPGateway, MACAddress, DNSServerSearchOrder, Description
        $network_info =  New-Object PSCustomObject
        $nwInfo | ForEach-Object{
            $network_info | Add-Member -type NoteProperty -name $_.Description -Value $_
        }
        $this.inventoryData | Add-Member -type NoteProperty -name Networks -Value $network_info
    }
    
    [void]get_antivirus_info(){
        $defstatus = ''
        $rtstatus = ''
        $AntiVirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ErrorAction SilentlyContinue
        switch ($AntiVirusProduct.productState) { 
            "262144" {$defstatus = "Up to date" ; $rtstatus = 0} 
            "262160" {$defstatus = "Out of date" ; $rtstatus = 0} 
            "266240" {$defstatus = "Up to date" ; $rtstatus = 1} 
            "266256" {$defstatus = "Out of date" ; $rtstatus = 1} 
            "393216" {$defstatus = "Up to date" ; $rtstatus = 0} 
            "393232" {$defstatus = "Out of date" ; $rtstatus = 0} 
            "393488" {$defstatus = "Out of date" ; $rtstatus = 0} 
            "397312" {$defstatus = "Up to date" ; $rtstatus = 1} 
            "397328" {$defstatus = "Out of date" ; $rtstatus = 1} 
            "397584" {$defstatus = "Out of date" ; $rtstatus = 1} 
            "397568" {$defstatus = "Up to date"; $rtstatus = 1}
            "393472" {$defstatus = "Up to date" ; $rtstatus = 0}
            default {$defstatus = "Unknown" ; $rtstatus = -1} 
        }
        
        $antivirus = New-Object PSCustomObject
        $antivirus  | Add-Member -type NoteProperty -name ProductName -Value   $AntiVirusProduct.displayName
        $antivirus  | Add-Member -type NoteProperty -name ProductExe -Value   $AntiVirusProduct.pathToSignedProductExe
        $antivirus  | Add-Member -type NoteProperty -name ProductUpdateStatus -Value   $defstatus
        $antivirus  | Add-Member -type NoteProperty -name ProductRealTimeProtection -Value   $rtstatus
        $this.inventoryData | Add-Member -type NoteProperty -name Antivirus -Value $antivirus        
    }
    [void]get_firewall_status(){
        $firewall_status = Get-FirewallState 
        $this.inventoryData | Add-Member -type NoteProperty -name FirewallStatus -Value   $firewall_status
    }
    [void]get_disk_info(){
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
        $this.inventoryData  | Add-Member -type NoteProperty -name Disk  -Value $disks
    }

    Inventory(){
        $this.inventoryData = New-Object PSCustomObject
        $this.getHostname()
        $this.get_serial_and_bios()
        $this.get_os_info()
        $this.get_network_info()
        $this.get_antivirus_info()
        $this.get_disk_info()
    }
}






class Preventiva{
    [string]$pasta_beltis = ".\inventario"

    [void]gerar_inventario(){
        $inv = [Inventory]::New()
        
        if ( Test-Path "$($this.pasta_beltis)\$($inv.inventoryData.Hostname).json" ) { 
            $old_inv = Get-Content "$($this.pasta_beltis)\$($inv.inventoryData.Hostname).json"
            Remove-Item "$($this.pasta_beltis)\$($inv.inventoryData.Hostname).json"
            New-Item -Path $this.pasta_beltis -Name "$($inv.inventoryData.Hostname).json" -ItemType "file" -Value "$($inv.inventoryData | ConvertTo-Json)"    
            $inv = Get-Content "$($this.pasta_beltis)\DESKTOP-3377U3C.json"
            $comp = Compare-Object  -ReferenceObject $old_inv -DifferenceObject $inv
            $comp
        } else {
            New-Item -Path $this.pasta_beltis -Name "$($inv.inventoryData.Hostname).json" -ItemType "file" -Value "$($inv.inventoryData | ConvertTo-Json)"        
        }
        
        
        
    }

    [void]clear_folder([string]$folder){
        Get-ChildItem  $folder| ForEach-Object { Remove-Item "$($folder)\$($_)" -Force -Recurse}
        Remove-Item $folder -Force -Recurse
        New-Item -ItemType Directory $folder
    }
    [void]delete_folder([string]$folder){
        Get-ChildItem  $folder| ForEach-Object { 
            Remove-Item "$($folder)\$($_)" -Force -Recurse
        }
        Remove-Item $folder -Force -Recurse
    }
    
    [void]cleaner(){        
        # defrag -c -v >C:\Preventiva\result_defrag.txt
        $this.delete_folder("$($Env:SystemRoot)\temp")
        $this.delete_folder("$($Env:SystemRoot)\Prefetch")
        $this.delete_folder($Env:TEMP)
        $this.delete_folder("$($Env:SystemRoot)\tempor~1")# rd /s /q $($Env:SystemRoot)\tempor~1
        $this.delete_folder("$($Env:SystemRoot)\tmp")
        $this.delete_folder("c:\ff*.tmp")
        $this.delete_folder("$($Env:SystemRoot)\history")
        $this.delete_folder("$($Env:SystemRoot)\cookies")
        $this.delete_folder("$($Env:SystemRoot)\recent")
        $this.delete_folder("$($Env:SystemRoot)\spool\printers")
        $this.delete_folder("$($Env:SystemRoot)\repair")
        $this.delete_folder("$($Env:SystemRoot)\system32\dllcache") # rd /s /q c:\windows\system32\dllcache
        $this.delete_folder("C:\MSOCache") # rd /s /q c:\MSOCache
        # rd /s /q c:\windows\Installer
        $this.delete_folder("$($Env:SystemRoot)\system32\ReinstallBackups")# rd /s /q c:\windows\system32\ReinstallBackups
        $this.delete_folder("C:\WIN386.SWP") # del c:\WIN386.SWP
        # if not exist "C:\WINDOWS\Users\*.*" goto skip
        # if exist "C:\WINDOWS\Users\*.zip" del "C:\WINDOWS\Users\*.zip" /f /q
        # if exist "C:\WINDOWS\Users\*.exe" del "C:\WINDOWS\Users\*.exe" /f /q
        # if exist "C:\WINDOWS\Users\*.gif" del "C:\WINDOWS\Users\*.gif" /f /q
        # if exist "C:\WINDOWS\Users\*.jpg" del "C:\WINDOWS\Users\*.jpg" /f /q
        # if exist "C:\WINDOWS\Users\*.png" del "C:\WINDOWS\Users\*.png" /f /q
        # if exist "C:\WINDOWS\Users\*.bmp" del "C:\WINDOWS\Users\*.bmp" /f /q
        # if exist "C:\WINDOWS\Users\*.avi" del "C:\WINDOWS\Users\*.avi" /f /q
        # if exist "C:\WINDOWS\Users\*.mpg" del "C:\WINDOWS\Users\*.mpg" /f /q
        # if exist "C:\WINDOWS\Users\*.mpeg" del "C:\WINDOWS\Users\*.mpeg" /f /q
        # if exist "C:\WINDOWS\Users\*.ra" del "C:\WINDOWS\Users\*.ra" /f /q
        # if exist "C:\WINDOWS\Users\*.ram" del "C:\WINDOWS\Users\*.ram"/f /q
        # if exist "C:\WINDOWS\Users\*.mp3" del "C:\WINDOWS\Users\*.mp3" /f /q
        # if exist "C:\WINDOWS\Users\*.mov" del "C:\WINDOWS\Users\*.mov" /f /q
        # if exist "C:\WINDOWS\Users\*.qt" del "C:\WINDOWS\Users\*.qt" /f /q
        # if exist "C:\WINDOWS\Users\*.asf" del "C:\WINDOWS\Users\*.asf" /f /q
        # :skip
        # if not exist C:\WINDOWS\Users\Users\*.* goto skippy /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.zip del C:\WINDOWS\Users\Users\*.zip /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.exe del C:\WINDOWS\Users\Users\*.exe /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.gif del C:\WINDOWS\Users\Users\*.gif /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.jpg del C:\WINDOWS\Users\Users\*.jpg /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.png del C:\WINDOWS\Users\Users\*.png /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.bmp del C:\WINDOWS\Users\Users\*.bmp /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.avi del C:\WINDOWS\Users\Users\*.avi /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.mpg del C:\WINDOWS\Users\Users\*.mpg /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.mpeg del C:\WINDOWS\Users\Users\*.mpeg /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.ra del C:\WINDOWS\Users\Users\*.ra /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.ram del C:\WINDOWS\Users\Users\*.ram /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.mp3 del C:\WINDOWS\Users\Users\*.mp3 /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.asf del C:\WINDOWS\Users\Users\*.asf /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.qt del C:\WINDOWS\Users\Users\*.qt /f /q
        # if exist C:\WINDOWS\Users\AppData\Temp\*.mov del C:\WINDOWS\Users\Users\*.mov /f /q
        # :skippy
        # if exist "C:\WINDOWS\ff*.tmp" del C:\WINDOWS\ff*.tmp /f /q
        $this.delete_folder("$($Env:SystemRoot)\ShellIconCache")# if exist C:\WINDOWS\ShellIconCache del /f /q "C:\WINDOWS\ShellI~1\*.*"
        
        # Limpar a lixeira
        Clear-RecycleBin -Force 
        
    }


    Preventiva(){
        $this.gerar_inventario()
    }
}

$p = [Preventiva]::new()


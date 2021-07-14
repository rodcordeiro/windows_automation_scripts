[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Verificar se a pasta de preventiva existe
# Verificar se os arquivos estão na pasta
# Executar
class PreventiveTasks{
    [string]$local_folder="C:\Preventiva"
    $d = @()    

    [PSCustomObject]get_disk_info(){
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
            Write-Host $disk
        }
        return $disks
    }

    [void]validate_local_folder(){
        if(Test-Path $this.local_folder){
            
        } else {
            New-Item -ItemType Directory -Path $this.local_folder
        }
    }

    
    PreventiveTasks(){
        $t = $this.get_disk_info()
        $this.d = $t
        
    }
}

$task = [PreventiveTasks]::New()
$task.d | ConvertTo-Json

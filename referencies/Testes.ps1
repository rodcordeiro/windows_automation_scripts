[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Verificar se a pasta de preventiva existe
# Verificar se os arquivos estão na pasta
# Executar
class Preventiva{
    [string]$pasta_beltis = ".\inventario"

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
        $this.cleaner()
    }
}

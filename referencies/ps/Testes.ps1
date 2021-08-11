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

# SIG # Begin signature block
# MIIFjQYJKoZIhvcNAQcCoIIFfjCCBXoCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0jhRTkS3HhyN7KWGE4OdBOgS
# lzagggMnMIIDIzCCAgugAwIBAgIQfHYWeWymG5hKNa2NOeSPejANBgkqhkiG9w0B
# AQsFADAbMRkwFwYDVQQDDBBSb2RyaWdvIENvcmRlaXJvMB4XDTIxMDgwNjIxMzUw
# NloXDTIyMDgwNjIxNTUwNlowJzElMCMGA1UEAwwcUm9kcmlnbyBDb3JkZWlybyB8
# IEJlbHRpcyBUSTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMAEnmvM
# +ALHEAPt9WC3ENvRcUvHLciaY6+jDewf718jrJ6UoamxjW8eZrta94TcsIOFtkNL
# L5HjjAUyWN+Wi7x1lhHUrwYA2/2loJGwqNEy4HSKJBXe2K9L9areuuM+W+wrb+N2
# BbfUXI/XaKDh8VLiLcbZE9kh3L6Oh+8ROImDBt926stsRx2mAFGVoa8XpKluFKGa
# D7ipzo0bpS08hhcBSTOulhsvTYJOCAlIDHImYzFa+cew0Z8NPz21p+tkiTBYSGO1
# SXpH7GY7thYRgeukM2uSWOpurzLyP/t2zLJU+6RV74A63tDUruyrt3/IS019n1om
# wCxdxICy//1Gqk0CAwEAAaNXMFUwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHwYDVR0j
# BBgwFoAUIxqWky1XNPwRIoGiKBwTQ3BGGgcwHQYDVR0OBBYEFH9eFmKUZJTh3xQh
# Gpgd6PVrlJiVMA0GCSqGSIb3DQEBCwUAA4IBAQBqZq7otKdUMdsUAlyvP8KcQNvG
# v9jQslH1Cke24hwEmwC3qq7bE48cjJ3MSqgztslPMt9vnVoPAbWrC2GqhaKmGQxe
# H0qyhRGyE/6btVy5T+qLHTFd5pHwRJs0BlfS7DtK4c/AERV/NyW7r+3DgFWmyLtk
# 3BnrdznEP5YActkmtpNARrPuTeVSRDAZit0miCKrktU1E2RpYo8JprZ17SufGkgW
# PgyxlF6CsWlpV7WeI7sG+RcFDrUZDtLCPCnTxQ9c2zGtaQ52H0z+IDPWKYu20EZS
# /KJZORWJGAHmm0BDpTukLAphhrRnqVcjuKS0mRdskjr6IM7LMs+ImU2hsYHuMYIB
# 0DCCAcwCAQEwLzAbMRkwFwYDVQQDDBBSb2RyaWdvIENvcmRlaXJvAhB8dhZ5bKYb
# mEo1rY055I96MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAA
# MBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgor
# BgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQL4KhKl8wkYgAMhdHWaWTZ53QRSTAN
# BgkqhkiG9w0BAQEFAASCAQBr5EkgBZXMP87p0AKMi+9hv6jOOfKL17eDaeen58T4
# XVftRv4Qjr0KIPEUyDIUaJTxVVaES0S4P73mEPlYcmMQGtaAQ3fNi8eMDJyYAG/9
# 1ytC0WZzxTlf4/wLAxiY/OtzFne2gLTiCVyjSiDCDoRAILKLBAsDRE5hY5Qf3Ra+
# /3SqCHZAXcF7ExwmYkL8tQvINcMZ6b3XZ/TPkcyXbUuHh9TppvdL1KHveYdGQw+I
# jevKM8boL6j6I2x3SNkzZZnU/rTy3NZKPSQGpM8XHkA/6lVu50dfNu6uxSRV9ppf
# Ld4B3L5bhRHVXIcSOz7Dch6KnkSCJtAgZ0n2K7k0Mibz
# SIG # End signature block

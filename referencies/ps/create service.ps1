

$params = @{
    Name = "API INVENTARIO NodeJS"
    BinaryPathName = '"powershell.exe -File C:\Scripts\InitAPI.ps1"'
    DependsOn = "NetLogon"
    DisplayName = "API INVENTARIO NodeJS"
    StartupType = "Automatic"
    Description = "Inicializa a instância da API de Inventário"
}
New-Service @params



Compress-Archive -Path .\build\* -DestinationPath "inv_api.zip" -Force
Expand-Archive -Path .\inv_api.zip -DestinationPath .\Cloud.Inventario.Api -Force
Remove-Item -Path .\inv_api.zip
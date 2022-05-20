function pda{
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("nk","hl")][string]$Client,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("Admin","WMS","INV","label")][string]$Project
        )
    if ($Client -eq "nk") {
        if ($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "ADMIN") {
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if ($Project -eq "WMS" -or $Project -eq "wms" -or $Project -eq "Wms") {
            Stop-IISSite -Name NK.Front.WMS
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
    }
    if ($Client -eq "hl") {
        if ($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "label") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
    }
}

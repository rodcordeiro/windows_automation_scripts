function pda {
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("nk", "hl", "centerlar","homol")][string]$Client,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("Admin", "WMS", "Etiquetas", "apk", "inv:front", "inv:api")][string]$Project
    )
    $env:PDA_ENVIRONMENT = "dev";
    
    if ($($Client -eq "nk") -and $($env:PDA_ENVIRONMENT -eq "dev")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if ($Project -eq "WMS") {
            Stop-IISSite -Name NK.Front.WMS
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
    }
    if ($($Client -eq "nk") -and $($env:PDA_ENVIRONMENT -eq "homol")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if ($Project -eq "WMS") {
            Stop-IISSite -Name NK.Front.WMS
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
    }
    if ($($Client -eq "nk") -and $($env:PDA_ENVIRONMENT -eq "prod")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if ($Project -eq "WMS") {
            Stop-IISSite -Name NK.Front.WMS
            Remove-Item C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React\* -Recurse -Force
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
    }
    
    if ($($Client -eq "hl") -and $($env:PDA_ENVIRONMENT -eq "dev")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name HL.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\front\Autenticacao -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name HL.Front.Admin
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
        if ($Project -eq "apk") {
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }
        if ($Project -eq "inv:front") {
            Stop-IISSite -Name HL.Front.Inventario
            Expand-Archive -Path $env:USERPROFILE\Desktop\inv.zip -DestinationPath C:\inetpub\wwwroot\repos\Front\Inventario -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\inv.zip -Force
            Start-IISSite -Name HL.Front.Inventario
        }
        if ($Project -eq "inv:api") {
            Stop-ScheduledTask -TaskName "\[Inventario API] Homol"
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\api\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\api\Cloud.Inventario.Api
            npm install
            Start-ScheduledTask -TaskName "\[Inventario API] Homol"
        }
        
    }
    
    if ($($Client -eq "centerlar") -and $($env:PDA_ENVIRONMENT -eq "prod")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
        if ($Project -eq "inv:front") {
            Stop-IISSite -Name Centerlar.Inventario.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\inv.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\inv.zip -Force
            Start-IISSite -Name Centerlar.Inventario.Front
        }
        if ($Project -eq "inv:api") {
            Stop-ScheduledTask -TaskName "\[Inventario API] Centerlar"
            # "[Inventario API] $Client"
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            Start-ScheduledTask -TaskName "\[Inventario API] Centerlar"
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
        if ($Project -eq "apk") {
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\Centerlar\Cloud.Gateway.Api\api\Atualizacao\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
    if ($($Client -eq "centerlar") -and $($env:PDA_ENVIRONMENT -eq "homol")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
        if ($Project -eq "inv:front") {
            Stop-IISSite -Name Centerlar.Inventario.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\inv.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\inv.zip -Force
            Start-IISSite -Name Centerlar.Inventario.Front
        }
        if ($Project -eq "inv:api") {
            Stop-ScheduledTask -TaskName "\[Inventario API] Centerlar"
            # "[Inventario API] $Client"
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            Start-ScheduledTask -TaskName "\[Inventario API] Centerlar"
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
        if ($Project -eq "apk") {
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\Centerlar\Cloud.Gateway.Api\api\Atualizacao\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
    if ($($Client -eq "centerlar") -and $($env:PDA_ENVIRONMENT -eq "dev")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
        if ($Project -eq "inv:front") {
            Stop-IISSite -Name Centerlar.Inventario.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\inv.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\inv.zip -Force
            Start-IISSite -Name Centerlar.Inventario.Front
        }
        if ($Project -eq "inv:api") {
            Stop-ScheduledTask -TaskName "\[Inventario API] Centerlar"
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            Start-ScheduledTask -TaskName "\[Inventario API] Centerlar"
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
        if ($Project -eq "apk") {
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\Centerlar\Cloud.Gateway.Api\api\Atualizacao\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
}

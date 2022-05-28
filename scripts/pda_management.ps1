function pda {
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("nk", "hl", "centerlar","homol")][string]$Client,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("Admin", "WMS", "Etiquetas", "apk", "inv:front", "inv:api")][string]$Project
    )
    $env:PDA_ENVIRONMENT = "homol";
    $env:pm2config = "C:\PDA\ecosystem.config.js"
    if ($($Client -eq "homol") -and $($env:PDA_ENVIRONMENT -eq "dev")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
        if ($Project -eq "WMS") {
            Stop-IISSite -Name NK.Front.WMS
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
        if ($Project -eq "inv:front") {
            Stop-IISSite -Name Centerlar.Inventario.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\inv.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\inv.zip -Force
            Start-IISSite -Name Centerlar.Inventario.Front
        }
        if ($Project -eq "inv:api") {
            pm2 stop $env:pm2config --only centerlar-inventario-api
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            pm2 start $env:pm2config --only centerlar-inventario-api
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
    }
    if ($($Client -eq "hl") -and $($env:PDA_ENVIRONMENT -eq "dev")) {
        if ($Project -eq "Admin") {
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if ($Project -eq "Etiquetas") {
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
            Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
        if ($Project -eq "apk") {
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\ -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
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
            pm2 stop $env:pm2config --only centerlar-inventario-api
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            pm2 start $env:pm2config --only centerlar-inventario-api
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
            pm2 stop $env:pm2config --only centerlar-inventario-api
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            pm2 start $env:pm2config --only centerlar-inventario-api
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
            pm2 stop $env:pm2config --only centerlar-inventario-api
            Expand-Archive -Path $env:USERPROFILE\Desktop\app.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.Api -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\app.zip -Force
            Set-Location C:\inetpub\wwwroot\repos\Centerlar\Cloud.Inventario.api
            npm install
            pm2 start $env:pm2config --only centerlar-inventario-api
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

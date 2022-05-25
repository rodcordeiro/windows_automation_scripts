function pda{
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("nk","hl","centerlar")][string]$Client,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, inform the notification type")][ValidateSet("Admin","WMS","INV","Etiquetas","Label","etq","apk","Mobile")][string]$Project
        )
	$env:PDA_ENVIRONMENT = "prod";
    if($($Client -eq "nk") -and $($env:PDA_ENVIRONMENT -eq "dev")){
        if($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "ADMIN"){
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
        if($Project -eq "WMS" -or $Project -eq "wms" -or $Project -eq "Wms"){
            Stop-IISSite -Name NK.Front.WMS
            Expand-Archive -Path $env:USERPROFILE\Desktop\wms.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.WMS.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\wms.zip -Force
            Start-IISSite -Name NK.Front.WMS
        }
    }
    if($($Client -eq "hl") -and $($env:PDA_ENVIRONMENT -eq "dev")){
        if($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "ADMIN"){
            Stop-IISSite -Name NK.Front.Admin
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\NKStore\Cloud.Autentication.React -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name NK.Front.Admin
        }
		if($Project -eq "Etiquetas" -or $Project -eq "Label" -or $Project -eq "etq"){
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
			Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
		if($Project -eq "mobile" -or $Project -eq "apk"){
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\ -Force
			Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
    if($($Client -eq "centerlar") -and $($env:PDA_ENVIRONMENT -eq "prod")){
        if($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "ADMIN"){
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
		if($Project -eq "Etiquetas" -or $Project -eq "Label" -or $Project -eq "etq"){
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
			Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
		if($Project -eq "mobile" -or $Project -eq "apk"){
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\repos\api\Cloud.Gateway.Api\api\Atualizacao\ -Force
			Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
    if($($Client -eq "centerlar") -and $($env:PDA_ENVIRONMENT -eq "homol")){
        if($Project -eq "Admin" -or $Project -eq "admin" -or $Project -eq "ADMIN"){
            Stop-IISSite -Name Centerlar.Admin.Front
            Expand-Archive -Path $env:USERPROFILE\Desktop\admin.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Admin.Front -Force
            Remove-Item -Path $env:USERPROFILE\Desktop\admin.zip -Force
            Start-IISSite -Name Centerlar.Admin.Front
        }
		if($Project -eq "Etiquetas" -or $Project -eq "Label" -or $Project -eq "etq"){
            Expand-Archive -Path $env:USERPROFILE\Desktop\etiquetas.zip -DestinationPath C:\inetpub\wwwroot\repos\Centerlar\Cloud.Gateway.Api\api\Atualizacao\etiquetas\ -Force    
			Remove-Item -Path $env:USERPROFILE\Desktop\etiquetas.zip -Force
        }
		if($Project -eq "mobile" -or $Project -eq "apk"){
            copy-item $env:USERPROFILE\Desktop\*.apk -Destination C:\inetpub\wwwroot\Centerlar\Cloud.Gateway.Api\api\Atualizacao\ -Force
			Remove-Item -Path $env:USERPROFILE\Desktop\*.apk -Force
        }		
    }
}

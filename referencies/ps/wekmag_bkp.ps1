Start-Transcript -Path "C:\Scripts\bkp.log" -Append -NoClobber -IncludeInvocationHeader

param ($clientEmails, $client,$source,$target)
# Get-WinEvent -ProviderName Microsoft-Windows-Backup -MaxEvents 10

$SUPPORTEMAIL = "suporte@beltis.com.br"
$USER = "suporte@grupobeltis.com.br"
$SMTPServer = "smtps.uhserver.com"
$SMTPPort = "587"
$password = ConvertTo-SecureString –String "SupMAster2021" –AsPlainText -Force

$lastBkp = Get-WBJob -previous 1
$lbkpEndTime = Get-Date -date $lastBkp.EndTime  -Format "dd/MM/yyyy HH:mm"
$origin = @()
$bkpPolicy.VolumesToBackup | ForEach-Object {
    if($_.MountPath){
        $origin += $_.MountPath
    }
}
$origin += $source
$destiny = @()
$bkpPolicy.BackupTargets | ForEach-Object {
        $destiny += $_.Label
}
$destiny += $target

$statusReturn = @(
    [pscustomobject]@{
        "status"=4;
        "Subject" = "Backup concluído";
        "body" = "<h2>Backup concluído com sucesso!</h2>  <p>Backup concluído às "   +  $HORA +    "</p><table style='width:20%;border:1px solid black;border-collapse:collapse;padding: 5px 10px;'><tr style='border:1px solid black;border-collapse:collapse;padding: 5px 10px;'><td style='width: 20%;border:1px solid black;border-collapse:collapse;padding: 5px 10px;'><b>Origem</b></td><td style='border:1px solid black;border-collapse:collapse;padding: 5px 10px;'>"+ $origin +"</td></tr><tr style='border:1px solid black;border-collapse:collapse;padding: 5px 10px;'><td style='border:1px solid black;border-collapse:collapse;padding: 5px 10px;'><b>Destino</b></td><td style='border:1px solid black;border-collapse:collapse;padding: 5px 10px;'>"+ $destiny +"</td></tr></table>"
        
    },
    [pscustomobject]@{
        "status"=5;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>";
        "error"="Backup started at '%6' failed with following error code '%2'."
    },
    [pscustomobject]@{
        "status"=8;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Backup Cancelado";
        "body"= "<h2>O Backup foi cancelado!</h2>"
    },
    [pscustomobject]@{
        "status"=9;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as Volume Shadow copy operation failed for backup volumes with following error code '%2'.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=17;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed because Windows Backup engine could not be contacted, error code '%2'.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=18;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Scheduled backup started at '%1' failed because the schedule settings was not found.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=19;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup attempted at '%4' failed to start, error code '%5'.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=20;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%2' failed as another backup or recovery is in progress.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=21;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Scheduled backup configuration conflicts with group policy settings, error - '%1'. Failing scheduled backup started at '%2' due to the conflict.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=22;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%2' failed as recovery planning is in progress through some other client.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=49;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup failed as no target could be found.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=50;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup failed as required space was not available on the backup target.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=52;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup task failed as the configured network target is not writeable.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=100;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup schedule was cancelled. Backups would no more run as per schedule.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=517;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed with following error code '%2' (%3). Please rerun backup once issue is resolved.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=518;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as another backup or recovery is in progress. Please re-run backup.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=521;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as Volume Shadow copy operation failed for backup volumes with following error code '%2'. Please rerun backup once issue is resolved.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=527;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as recovery planning is in progress through some other client. Please re-run backup.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=528;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Scheduled backup configuration conflicts with group policy settings, error - '%2'. Failing scheduled backup started at '%1' due to the conflict. Please modify scheduled backup configuration to avoid the conflict.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=544;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed because Windows Backup engine could not be contacted, error code '%2'. Please check if engine service is installed and enabled.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=545;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Scheduled backup started at '%1' failed because the schedule settings was not found. Please re-configure scheduled backup.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=546;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup attempted at '%1' failed to start, error code '%2'.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=561;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as no target could be found. Please attach a backup target and rerun backup.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=564;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup started at '%1' failed as network target '%2' is not writeable. Please ensure user '%3' has write permissions on the target.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    },
    [pscustomobject]@{
        "status"=612;
        "emailToWarn"=$SUPPORTEMAIL;
        "Subject"= "Falha no backup";
        "error"="Backup schedule was cancelled. Backups would no more run as per schedule.";
        "body"= "<h2>O Backup apresentou falha!</h2>  <p>Backup foi encerrado com falha às "   +  $HORA +    "</p>"
    }
)

$emailsToSend = @()
$emailsToSend += $clientEmails

$StartTime = (Get-Date -Hour 22).hour
$EndTime = (get-date).hour
$NotifyTime = (Get-Date -Hour 07).hour

if($EndTime -gt $NotifyTime -and $EndTime -lt $StartTime){
    $emailsToSend += $SUPPORTEMAIL
}

$body = "<div style='width:100%'>"
$HORA = Get-Date -Format "dd/MM/yyyy HH:mm"

$From = $USER # Remetente
$userName = $USER # Novamente o endereço de e-mail do remetente
# Aqui a variável credential está recebendo um novo objeto contendo a o usuário e a senha para a autenticação no SMTP
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
# Codificação de caracteres do texto
$Encoding= New-Object System.Text.UTF8Encoding
$status = 0
$bkpLogs | ForEach-Object{
    $date = Get-Date -date $_.TimeCreated -Format "dd/MM/yyyy HH:mm"
    if($date -eq $lbkpEndTime){
        $status = $_.Id
        $statusReturn | ForEach-Object {
            if( $_.status -eq $status){
                $Subject = $_.Subject
                $body += $_.body 
                if($_.error){
                    $body+="<blockquote style='margin-left:2%;border:1.5px solid black; border-left: 5px solid black; color: #18181899; padding:10px 15px;'><i>"
                    $body+=$_.error
                    $body+="</i></blockquote>"
                }
                if($_.emailToWarn){
                    $emailsToSend += $_.emailToWarn
                }
                $body += "</div>"
                $emailsToSend | ForEach-Object {
                    $To = $_
                    Send-Mailmessage -smtpServer $smtpServer -from $From -to $To -subject $Subject -body $Body -BodyAsHtml -priority High -encoding $Encoding -port $SMTPPort -UseSsl -Credential $credential -ErrorAction Stop
                    return
                }
            }
        }
        if($status -eq 4){
            Start-Process -FilePath "C:\Windows\MonitBackup\ncftpput.exe" -ArgumentList "-C -u MonitBackup -p S3nhamoNitoraAment0Bk -F monitbeltis.ddns.net NUL $client"
        }
    }
}
Stop-Transcript
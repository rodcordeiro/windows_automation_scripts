$Client = "Homol"
$ScriptName = "$Client.inventario.ps1"
$ClientFolder = "C:\inetpub\wwwroot\repos\HOMOL\Cloud.Inventario.api"

New-Item -Type File -Path C:\Scripts -Name $ScriptName -Value "
Start-Transcript -Path C:\Scripts\$ScriptName.log -Append -NoClobber -IncludeInvocationHeader
/env:NODE_ENV='development'
/env:TOKEN_KEY='MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAF53wUbKmDHtvfOb8u1HPqEBFNNFcsnOMjIcSEhAwIQMbgrOuQvHYgXuuDJaURS85H8P4UTt6lYOJnSFnXvS82E7LHJpVrWwQzbh2QKh13akPe90DlNTUGEYO7rHaPLqTlld0jkLFSytwqfwqn9yrYpM1ncUOpCciK5j8t8MzO71LJoJg24CFxpjIS0tBrJvKzrRNcxWSRDLmu2kNmtsh7yyJouE6XoizVmBmNVltHhFaDMmqjugMQA2CZfLrxiR1ep8TH8IBvPqysqZI1RIpBe0engP41KLrOt6gGS0JEDh1kG2fJOblN4n3sCOtgaz5Uz88jpwbmZ3Se8CAwEAAQKCAQAdOsSs2MbavAsIM3qoGBehO0iqdxooMpbQvECmjZ3JTlvUqNkPPWQvFdiW8PsHTvtackhdLsqnNUreKxXL5rr8vqi9qm00mXpGNi7gP3mFeaVdYnfpIwgCe6lag5k6Myv7PG6N8XrWyBdwlOe96bGohvB4Jp2YFjSTM67QONQ8CdmfqokqJ83RyrpDvGN3iX3yzBqXGOjPkoJQv3I4lsYdR0nl4obHHnMSeWCQCYvJoZ7ZOliuDd0ksItlodG6s8rujkSa8VIhe0fnXTf0i7lqa55CAByGN4MOR0bAkJwIB7nZzQKurBPcTAYJFFvAc5hgMnWT0XW83TehAoGBALVPGnznScUwO50OXKI5yhxGfXDT8g28L8Oc4bctRzI8YfIFfLJ57uDGuojOBpqtYmXmgORru0jYR8idEkZrxgf62czOiJrCWTkBCEMtrNfFHQJQCQrjfbHofp7ODnEHbHFm7zdlbfNnEBBaKXxd2rVv4UTEhgftvwsHcimbXAoGBAIViWrHWElMeQT0datqlThEu51mc4VlV7iRWXVa1gAP85ZAu44VvvDlkpYVkFzSRRlHSOzsubDMN45OBQW6UA3RPg4TCvrTOmhQUeF5XPuSdcD0R2At6pdaLwAKnOtILg13Ha6ymIgjv8glodvem3hWLmpHIhNBiaXtf8wqpAoGADH5a8OhvKOtd8EChGXyp9LDWHRw9vbyNgi9dQXltgyoUBb1jDllgoJSRHgRFUvyvbbImR5c03JwqtiQ8siWTC9G5WGeSjcSNt9fVmG7W1L14MbrGJj8fFns7xrOlasnlPdgA5NCONtIsZY2DKZr0drhPhZBcWJlFxkCgYAn4SOPEo6hjKNhA6vER7fSxDEVsDgrDh3YgAWpvUdlaqBxqOyAqi600YugQZGHK2lv7vNYOdmrunuIx7BPuDqYbjtRR4Mc9bVQAZbXSLXMl7j2RWwKfNhLSJbk9LX4EoVtTgLjvOUE4tAdq9fFgpqdwLwzqPTO9kECP4CQKBgH6tOxcNxGuXUideluAn3H2KeyyznZMJ7oCvzf26XpTAMI243OoeftiKVMgxuZ7hjwqfnVHXABc4i5gchr9RzSb1hZIqFzq2YGmbppg5Ok2cgwalDoDBi21bRf8aDRweL62mO7aPnCQZ58j5W72PB8BAr6xg0Oro25O4os'
/env:PORT= '830'
/env:DB_HOST= '10.23.1.29'
/env:DB_SERVER = 'SRV-DEV-SQL12'
/env:DB_PORT= '12434'
/env:DB_USER= 'sa'
/env:DB_PWD= 'Sql@2016'
/env:DB_NAME= 'React_Inventario'
Set-Location $ClientFolder
node.exe $ClientFolder
Stop-Transcript".Replace("/","$")


$Task = Import-CliXml "~/Desktop/TaskBKP.xml"
$restoreTask = New-ScheduledTask `
    -Action $Task.Actions `
    -Trigger $Task.Triggers `
    -Settings $Task.Settings `
    -Principal $Task.Principal

Register-ScheduledTask `
    -TaskName $Task.TaskName`
    -InputObject $restoreTask `
    -User 'PDACLOUD\Rodrigo.Mendonca' `
    -Password 'PDA@2020'

$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument "-File 'C:\Scripts\$ScriptName'"
$taskTrigger = New-ScheduledTaskTrigger -AtStartup

$taskName = "[Inventario API] $Client"

# Describe the scheduled task.
$description = "Runs $Client inventory node API"

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
Start-ScheduledTask $taskName

$restoreTask = New-ScheduledTask `
    -Action $stBackup.Actions `
    -Trigger $stBackup.Triggers `
    -Settings $stBackup.Settings `
    -Principal $stBackup.Principal

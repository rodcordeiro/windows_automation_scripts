$apps = [PSCustomObject]@{}
$list = @("Armazenagem","Recebimento","Expedição","Picking","Embarque","Transferencia","Movimentacao","Montagem","Inventário","Dashboard")
$clients = @("Homol","Overcome","Raizs","MagDecor","Hidrolight","NkStore")

$clients | ForEach-Object {
    $client = $_
    $list | ForEach-Object {
        $app = $_
        $version = Read-Host "App $app for $client"
        $client
        $app
        $version
        
        if($apps.$client) {
            Write-Host 'client'
            $apps.$client | Add-Member -type NoteProperty -name $app  -Value $version
        } else {
            write-host 'new client'
            $value = [PSCustomObject]@{
                $app = $version
            }   
            $apps | Add-Member -type NoteProperty -name $client  -Value $value
        }
    }
}
$table = @()
$table += "|Aplicativo"+[String]::Join("",$($clients |foreach-Object {"|$($_)"}))+ "|"
$table += "|:-"+[String]::Join("",$($clients |foreach-Object {"|:-:"}))+ "|"
$table += $list | foreach-object{
    $app = $_ 
    return "|$app"+[String]::Join("",$($clients |foreach-Object {"|$($apps.$_.$app)"}))+ "|"
}
Remove-Item -Path ".\apps.md"
New-Item -itemtype file -name ".\apps.md" 
$table | ForEach-Object {
    Add-Content -Path '.\apps.md' -Value $_
}
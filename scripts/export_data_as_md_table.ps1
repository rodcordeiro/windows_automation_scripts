function ConvertTo-MarkdownTable{
    param(
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [ValidateNotNullOrEmpty()]
		[string[]]$Columns,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory=$false)]
		[string[]]$RowsLabel,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [ValidateNotNullOrEmpty()]
		[PSCustomObject[]]$Rows,
        [Parameter(ValueFromPipelineByPropertyName,Mandatory=$false)]
        [string]$OutFile
    )
    $table = @()
    $table += $(if($RowsLabel){'| '}) + [String]::Join("",$($Columns |foreach-Object {"|$($_)"}))+ "|"
    $table += $(if($RowsLabel){'|:- '}) +[String]::Join("",$($Columns |foreach-Object {"|:-:"}))+ "|"
    if($RowsLabel){
        $table += $RowsLabel | foreach-object{
            $app = $_ 
            return "|$app"+[String]::Join("",$($Columns |foreach-Object {"|$($Rows.$_.$app)"}))+ "|"
        }
        
    } else {
        $table += $Rows | foreach-object{
            $row = $_
            return [String]::Join("",$($Columns |foreach-Object {"|$($row.$_)"}))+ "|"
        }
    }
    if ($OutFile){
        New-Item -Type file -Path $OutFile | Out-Null
        $table | ForEach-Object {
            Add-Content  -Path $OutFile -Value $_
        }
    } else {
        return $table
    }

}

# ConvertTo-MarkdownTable -Columns @('name','lastName') -Rows @(@{
#     name="Rodrigo";
#     lastName="Cordeiro"
# },@{
#     name="Yasmim";
#     lastName="Cordeiro"
# }) -OutFile test.md

# $Data = [PSCustomObject]@{}
# # ROWS
$Rows = @("Armazenagem","Recebimento","Expedição","Picking","Embarque","Transferencia","Movimentacao","Montagem","Inventário","Dashboard")

#COLUMNS
$Columns = @("Homol","Overcome","Raizs","MagDecor","Hidrolight","NkStore")

# RECEIVE INFORMATION FOR EACH ROW IN EACH COLUMN
$Columns | ForEach-Object {
    $client = $_
    $Rows | ForEach-Object {
        $app = $_
        $version = Read-Host "App $app for $client"
        $client
        $app
        $version
        
        if($Data.$client) {
            Write-Host 'client'
            $Data.$client | Add-Member -type NoteProperty -name $app  -Value $version
        } else {
            write-host 'new client'
            $value = [PSCustomObject]@{
                $app = $version
            }   
            $Data | Add-Member -type NoteProperty -name $client  -Value $value
        }
    }
}
$Data
# $table = @()
# $table += "|Aplicativo"+[String]::Join("",$($Columns |foreach-Object {"|$($_)"}))+ "|"
# $table += "|:-"+[String]::Join("",$($Columns |foreach-Object {"|:-:"}))+ "|"
# $table += $Rows | foreach-object{
#     $app = $_ 
#     return "|$app"+[String]::Join("",$($Columns |foreach-Object {"|$($Data.$_.$app)"}))+ "|"
# }
# Remove-Item -Path ".\apps.md"
# New-Item -itemtype file -name ".\apps.md" 
# $table | ForEach-Object {
#     Add-Content -Path '.\apps.md' -Value $_
# }
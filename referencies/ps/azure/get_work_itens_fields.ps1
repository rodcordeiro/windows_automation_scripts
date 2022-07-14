# https://github.com/mgajda83/PSDevOpsBackup/blob/main/PSDevOpsBackup/Backup-Repository.ps1

$witType="product%20backlog%20item"

$token = $env:PAT

$url="https://dev.azure.com/pdasolucoes/Projetos/_apis/wit/fields?api-version=6.1-preview.2"


$Header = @{
  "Content-Type" = "application/json"
  "Accept" = "application/json"
  "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
}


$response = Invoke-RestMethod -Uri $url -Headers $Header -Method Get -ContentType application/json-patch+json
$response
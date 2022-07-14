# https://github.com/mgajda83/PSDevOpsBackup/blob/main/PSDevOpsBackup/Backup-Repository.ps1
# https://docs.microsoft.com/en-us/rest/api/azure/devops/git/pull-requests/update?view=azure-devops-rest-6.0

$token = $env:PAT

$url="https://dev.azure.com/pdasolucoes/Projetos/_apis/git/pullrequests?api-version=6.0"


$Header = @{
  "Content-Type" = "application/json"
  "Accept" = "application/json"
  "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
}


$response = Invoke-RestMethod -Uri $url -Headers $Header -Method GET -ContentType application/json-patch+json
$response
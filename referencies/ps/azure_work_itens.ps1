# https://github.com/mgajda83/PSDevOpsBackup/blob/main/PSDevOpsBackup/Backup-Repository.ps1

$witType="task"

$token = $env:PAT

$url="https://dev.azure.com/pdasolucoes/Projetos/_apis/wit/workitems/`$$($witType)?api-version=6.0"


$Header = @{
  "Content-Type" = "application/json"
  "Accept" = "application/json"
  "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
}

# $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($token)"))
$body="[
          {
            `"op`": `"add`",
            `"path`": `"/fields/System.Title`",
            `"value`": `"titlename`"
          },
          {
            `"op`": `"add`",
            `"path`": `"/fields/System.AssignedTo`",
            `"value`": `"rmendonca@pdasolucoes.com.br`"
          },

          {
            `"op`": `"add`",
            `"path`": `"/fields/Microsoft.VSTS.Common.Priority`",
            `"value`": `"4`"
          },
          {
            `"op`": `"add`",
            `"path`": `"/fields/System.Tags`",
            `"value`": `"Inventario`"
          },

       ]"
      #  {
      #   `"op`": `"add`",
      #   `"path`": `"/fields/System.History`",
      #   `"value`": `"<div>$(SYSTEM.STAGEDISPLAYNAME)</div>`"
      # }


$response = Invoke-RestMethod -Uri $url -Headers @{Authorization = "Basic $token"} -Method Post -Body $body -ContentType application/json-patch+json
# https://github.com/mgajda83/PSDevOpsBackup/blob/main/PSDevOpsBackup/Backup-Repository.ps1

$witType="Product%20Backlog%20Item"

$token = $env:PAT

$url="https://dev.azure.com/pdasolucoes/Projetos/_apis/wit/workitems/`$$($witType)?api-version=6.0"


$Header = @{
  "Content-Type" = "application/json"
  "Accept" = "application/json"
  "Authorization" = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($token)"))
}

# $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($token)"))
$body='[
          {
            "op": "add",
            "path": "/fields/System.Title",
            "value": "Atualização de dependências"
          },
          {
            "op": "add",
            "path": "/fields/System.Description",
            "value": "Atualização automatizada de dependências"
          },
          
          {
            "op": "add",
            "path": "/fields/System.AssignedTo",
            "value": "rmendonca@pdasolucoes.com.br"
          },

          {
            "op": "add",
            "path": "/fields/Microsoft.VSTS.Common.Priority",
            "value": "4"
          },
          {
            "op": "add",
            "path": "/fields/System.Tags",
            "value": "Coletores"
          },
          {
            "op": "add",
            "path": "/fields/Custom.Client",
            "value": "PDA"
          },{
            "op": "add",
            "path": "/fields/Custom.AnalystFunctional",
            "value": "Ferrão"
          },{
            "op": "add",
            "path": "/fields/Custom.Project",
            "value": "-"
          },
       ]'
      #  {
      #   `"op`": `"add`",
      #   `"path`": `"/fields/System.History`",
      #   `"value`": `"<div>$(SYSTEM.STAGEDISPLAYNAME)</div>`"
      # }

      
$response = Invoke-RestMethod -Uri $url -Headers $Header -Method Post -Body $body -ContentType application/json-patch+json
$response
function Mapear-Repositorios {
    param(
        # Caminho onde estão os projetos. Pode passar o caminho para a função ou executar direto na pasta
        [Parameter(ValueFromPipeline)]
        [string]
        $Path
    )

    begin {
        # Variáveis
        $organization = "irienu"              # nome da sua organização no Azure DevOps
        $project = "Projetos"                         # nome do projeto onde o repositório será criado
        $pat = "PAT"                            # seu Personal Access Token
        # Montar o header de autorização (Base64)
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($pat)"))
        # URL da API REST
        $url = "https://dev.azure.com/$organization/$project/_apis/git/repositories?api-version=7.1-preview.1"

        if (-not $Path) {
            $Path = $PWD
        }
    }
    process {
        Set-Location (Resolve-Path $Path)
        $repositorios = Get-ChildItem -Directory

        foreach ($repositorio in $repositorios) {
            Write-Host "Acessando pasta: $repositorio"
            # Acessa a pasta
            Set-Location $repositorio.FullName
            
            Write-Host "Criando .gitignore"
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            # Cria o .gitignore
            try {
                Invoke-WebRequest `
                    -Uri "https://www.toptal.com/developers/gitignore/api/dotnetcore,csharp,aspnetcore" `
                    -OutFile .gitignore `
                    -TimeoutSec 10 `
                    -ErrorAction Stop
                Write-Host ".gitignore criado com sucesso"
            }
            catch {
                Write-Warning "Falha ao baixar .gitignore: $_"
                New-Item -ItemType File -Name ".gitignore" -Value "# fallback .gitignore" | Out-Null
            }

            # Corpo da requisição
            $body = @{
                name = $repositorio.Name
            } | ConvertTo-Json -Depth 10
            Write-Host "Requisição JSON: $body"


            Write-Host "Criando repositorio $repositorio no azure"
            # Fazer o POST para criar o repositório
            $response = Invoke-RestMethod -Method Post -Uri $url -Headers @{
                Authorization  = "Basic $base64AuthInfo"
                "Content-Type" = "application/json"
            } -Body $body -Verbose

            # Exibir resultado
            if ($response.name -eq $repositorio.Name) {
                Write-Host "Repositório '$repoName' criado com sucesso no projeto '$project'."

                Write-Host "iniciando  Repositorio $repositorio"
                git init
                git add .
                git commit -m 'Criado o repositório'
                
                $repoUrl = "https://$organization:$pat@dev.azure.com/$organization/$project/_git/$($repositorio.Name)"
                git remote add origin $repoUrl

                
                Write-Host "enviando dados para o repositorio $repositorio"
                git push
            }
            else {
                Write-Host "Falha ao no repositório $repositorio"
            }
            Set-Location (Resolve-Path $Path)
        }
    }
}

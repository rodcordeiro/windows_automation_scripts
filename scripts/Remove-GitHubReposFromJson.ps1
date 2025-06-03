function Remove-GitHubReposFromJson {
    param (
        [string]$Username,
        [string]$Token,
        [string]$JsonFile = "repos.json"
    )

    $headers = @{
        Authorization = "token $Token"
        Accept        = "application/vnd.github+json"
        "User-Agent"  = "$Username-PowerShell"
    }

    if (-not (Test-Path $JsonFile)) {
        Write-Host "Arquivo JSON '$JsonFile' não encontrado." -ForegroundColor Red
        return
    }

    $repos = Get-Content -Raw $JsonFile | ConvertFrom-Json

    foreach ($repo in $repos) {
        if ($repo.delete -eq $true) {
            $uri = "https://api.github.com/repos/$Username/$($repo.name)"
            Write-Host "Deletando repositório: $($repo.name)..."

            try {
                Invoke-RestMethod -Uri $uri -Method Delete -Headers $headers
                Write-Host "✅ Repositório '$($repo.name)' deletado com sucesso." -ForegroundColor Green
            } catch {
                Write-Host "❌ Erro ao deletar '$($repo.name)': $_" -ForegroundColor Red
            }
        }
    }
}

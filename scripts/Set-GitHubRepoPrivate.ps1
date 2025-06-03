function Set-GitHubRepoPrivate {
    param (
        [string]$Username,
        [string]$Token,
        [string]$InputFile = "repos.json"
    )

    $headers = @{
        Authorization = "token $Token"
        Accept        = "application/vnd.github+json"
        "User-Agent"  = "$Username-PowerShell"
    }

    $repos = Get-Content -Raw $InputFile | ConvertFrom-Json

    foreach ($repo in $repos) {
        if ($repo.public -eq $false) {
            if ($repo.delete -ne $true ) {
                Write-Host "Setting '$($repo.name)' to private..."

                $uri = "https://api.github.com/repos/$Username/$($repo.name)"
                $body = @{
                    private = $true
                } | ConvertTo-Json

                try {
                    Invoke-RestMethod -Uri $uri -Method Patch -Headers $headers -Body $body -OutVariable $null
                    Write-Host "Repository '$($repo.name)' visibility updated to private." -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed to update '$($repo.name)': $_" -ForegroundColor Red
                }
            }
        }
    }
}

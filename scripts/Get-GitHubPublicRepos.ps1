function Get-GitHubPublicRepos {
    param (
        [string]$Username,
        [string]$Token,
        [string]$OutputFile = "repos.json"
    )

    $headers = @{
        Authorization = "token $Token"
        Accept        = "application/vnd.github+json"
        "User-Agent"  = "$Username-PowerShell"
    }

    $repos = @()
    $page = 1

    do {
        $uri = "https://api.github.com/users/$Username/repos?per_page=100&page=$page"
        $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get
        foreach ($repo in $response) {
            $repos += [PSCustomObject]@{
                name   = $repo.name
                fork   = $repo.fork
                public = $repo.private -eq $false
                delete = $false
            }
        }
        $page++
    } while ($response.Count -eq 100)

    $repos | ConvertTo-Json -Depth 3 | Out-File -Encoding UTF8 $OutputFile
    Write-Host "Saved repository list to $OutputFile"
}
    
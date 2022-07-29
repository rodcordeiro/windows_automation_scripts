function downloadBinaries{
    param(
        [string]$url,
        [string]$executable,
        [switch]$Run
    )
    
    Write-Output "Downloading $executable"
    Invoke-WebRequest -Uri $url -outfile "C:\tools\$executable.exe"
    if($Run){
        Invoke-Expression "C:\tools\$executable.exe"
    }
}
New-Item -Type Directory -Name Scripts -Path C:\ | Out-Null
New-Item -Type Directory -Name Tools -Path C:\ | Out-Null

downloadBinaries "https://github.com/ytdl-org/youtube-dl/releases/download/2021.12.17/youtube-dl.exe" "youtube-dl"
downloadBinaries "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v3.4.3/Beekeeper-Studio-Setup-3.4.3.exe" "beekeeper" -Run
downloadBinaries "https://github.com/Kong/insomnia/releases/download/core%402022.3.0/Insomnia.Core-2022.3.0.exe" "insomnia" -Run
downloadBinaries "https://download.microsoft.com/download/c/7/c/c7ca93fc-3770-4e4a-8a13-1868cb309166/SSMS-Setup-PTB.exe" "SSMS" -Run

function Download-Repositories {
    param(
        [parameter(ValueFromPipelineByPropertyName)]$Repos
    )
    $Repos | ForEach-Object {
        $Folder = $_
        if($($(Test-Path -Path $(Resolve-Path -Path $Folder.Parent)) -eq $True)){
            Set-Location $Folder.Parent
            $repos = $($Folder.repos | ConvertFrom-Json)
            $repos | ForEach-Object {
                clone -Alias $_.alias -Folder $Folder -Path $_.repo
                if($(Test-Path "$PWD/package.json") -eq $True){
                    yarn
                }
                if ($_.branches){
                    $_.branches  | ForEach-Object {
                        git checkout $_
                        git pull --set-upstream origin $_
                    }
                }
                git push -u origin --all                
            }
        } else {
            New-Item -Type Directory $Folder.Parent
            Set-Location $Folder.Parent
            $repos = $($Folder.repos | ConvertFrom-Json)
            $repos | ForEach-Object {
                clone -Alias $_.alias -Folder $Folder -Path $_.repo
                if ($_.branches){
                    $_.branches  | ForEach-Object {
                        git checkout $_
                        git pull --set-upstream origin $_
                    }
                }
                git push -u origin --all                
            }
        }
    }
}

Download-Repositories $Repositories

notify "Finally!" "Finished!!`nAll apps and repos configured"

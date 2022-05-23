<#PSScriptInfo

.VERSION 1.0.0

.GUID 437cd1ca-2204-4eed-971c-b91b069ec220

.AUTHOR Rodrigo Cordeiro <rodrigomendoncca@gmail.com> (https://rodcordeiro.com.br/)

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES 

#>

<# 
.Synopsis
 Retrieves basic inventory data about hardware    
.DESCRIPTION 
 Retrieves information about the hardware. Actual information retrived is hostname, bios, OS, network adapters and antivirus
.PARAMETER <path>
    Path to save the json file
.Inputs
 There's no input for this script
.outputs
 Outputs a json containing the hardware information.
.EXAMPLE
 .\Get_inventory.ps1
#> 
Param()

# choco
# git
# nodejs
# nvm
# drawio
# ssms
# profile


#CONSTANTS 
$repositories = $('[
    {
        "Parent":  "~/projetos/pda",
        "repos":  "[\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Armazenagem.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \"Armazenagem\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.WMS.Armazenagem-raizs.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Armazenagem-raizs\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Azure.Inventario.Node\",\r\n        \"branches\":  [\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Azure.Inventario.Node\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Azure.Inventario.React\",\r\n        \"branches\":  [\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Azure.Inventario.React\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Desktop.Centerlar.Etiquetas\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Centerlar-etiquetas\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Admin.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"develop\",\r\n                         \"beta\",\r\n                         \"Dev\",\r\n                         \"Hml\",\r\n                         \"Master\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Admin.React.Mobile\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Autentication.React\",\r\n        \"branches\":  [\r\n                         \"cloud-azure\",\r\n                         \"develop\",\r\n                         \"sem-filial\",\r\n                         \"main\",\r\n                         \"azure-pipelines\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Autentication.React\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Inventario.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Inventario.Mobile\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Inventario.Node\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"develop\",\r\n                         \"cloud-azure\",\r\n                         \"cloud\",\r\n                         \"common\",\r\n                         \"scheduleFeature\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Inventario.Node\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Inventario.React\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\",\r\n                         \"marcela\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Inventario.React\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.WMS.Embarque.MagDecor.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Cloud.WMS.Embarque.MagDecor.Mobile\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.React\",\r\n        \"branches\":  [\r\n                         \"dev-magazine-decor\",\r\n                         \"magazine-decor\",\r\n                         \"hidrolight\",\r\n                         \"develop\",\r\n                         \"main\",\r\n                         \"branch-teste\",\r\n                         \"overcome-homol\",\r\n                         \"raizs\",\r\n                         \"component-snackbar\",\r\n                         \"Overcome\"\r\n                     ],\r\n        \"alias\":  \"Cloud.Wms.React\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Inventario.Dashboard.App\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"develop\"\r\n                     ],\r\n        \"alias\":  \"dashboardApp\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Desktop.Etiquetas.Electron\",\r\n        \"branches\":  [\r\n                         \"hidrolight\",\r\n                         \"v2\",\r\n                         \"skala\",\r\n                         \"magazineDecor\",\r\n                         \"raizs\",\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Desktop.Etiquetas.Electron\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.WMS.Embarque.mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Embarque\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Expedicao.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\",\r\n                         \"beta\"\r\n                     ],\r\n        \"alias\":  \"Expedicao\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Expedicao.Raizs.Mobile\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"develop\"\r\n                     ],\r\n        \"alias\":  \"Expedicao-Raizs\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/React.Web.components\",\r\n        \"branches\":  [\r\n                         \"lib\"\r\n                     ],\r\n        \"alias\":  \"libPda\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/rn.mobile.components\",\r\n        \"branches\":  [\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"mobileComponents\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Montagem.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"hidrolight\",\r\n                         \"montagem-mutiplo\",\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Montagem\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Movimentacao.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"movimentacao-multiplo\",\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Movimentacao\"\r\n    },\r\n    {\r\n        \"repo\":  \"\",\r\n        \"branches\":  [\r\n                         \"master\",\r\n                         \"  remotes/upstream/master\",\r\n                         \"dependabot/npm_and_yarn/path-parse-1.0.7\",\r\n                         \"feature/compile_with_v13x\"\r\n                     ],\r\n        \"alias\":  \"node-printer\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Recebimento.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Recebimento\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Separacao.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"magDecor\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Separacao\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Cloud.Wms.Transferencia.React.Mobile\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"v1\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"Transferencia\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@ssh.dev.azure.com:v3/pdasolucoes/Projetos/Dev.Versionamento.API\",\r\n        \"branches\":  [\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"versionamento\"\r\n    }\r\n]"
    },
    {
        "Parent":  "~/projetos/personal",
        "repos":  "[\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/.dotfiles.git\",\r\n        \"branches\":  [\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \".dotfiles\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:HaikuTeam/animator.git\",\r\n        \"branches\":  [\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \"animator\"\r\n    },\r\n    {\r\n        \"repo\":  \"\",\r\n        \"branches\":  [\r\n                         \"master\",\r\n                         \"  remotes/upstream/master\"\r\n                     ],\r\n        \"alias\":  \"ApprenderApp\"\r\n    },\r\n    {\r\n        \"repo\":  \"\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"master\",\r\n                         \"  remotes/upstream/master\"\r\n                     ],\r\n        \"alias\":  \"ApprenderBackend\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/botDiscordSpammer.git\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"renovate/configure\"\r\n                     ],\r\n        \"alias\":  \"botDiscordSpammer\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/cordeiro-backend\",\r\n        \"branches\":  [\r\n                         \"master\",\r\n                         \"updates/node-14.x\",\r\n                         \"dependabot/npm_and_yarn/minimist-1.2.6\",\r\n                         \"updates/typescript-4.x\",\r\n                         \"updates/jest-monorepo\",\r\n                         \"updates/jasmin2895-open-graph-image-1.x\",\r\n                         \"updates/uuid-8.x\",\r\n                         \"updates/jsonwebtoken-8.x\",\r\n                         \"dependabot/npm_and_yarn/follow-redirects-1.14.8\",\r\n                         \"develop\"\r\n                     ],\r\n        \"alias\":  \"cordeiro-backend\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/bash.git\",\r\n        \"branches\":  [\r\n                         \"powershell\",\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"discloud\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/dmbot\",\r\n        \"branches\":  [\r\n                         \"updates/actions-setup-node-3.x\",\r\n                         \"updates/typescript-4.x\",\r\n                         \"updates/discord-api-types-0.x\",\r\n                         \"updates/pin-dependencies\",\r\n                         \"dependabot/npm_and_yarn/simple-get-3.1.1\",\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \"dmbot\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/IqOption.git\",\r\n        \"branches\":  [\r\n                         \"master\",\r\n                         \"renovate/pylint-2.x\",\r\n                         \"renovate/websocket-client-1.x\",\r\n                         \"renovate/astroid-2.x\",\r\n                         \"renovate/mccabe-0.x\",\r\n                         \"renovate/lazy-object-proxy-1.x\",\r\n                         \"renovate/isort-5.x\",\r\n                         \"renovate/idna-3.x\",\r\n                         \"renovate/certifi-2021.x\",\r\n                         \"renovate/urllib3-1.x\",\r\n                         \"renovate/charset-normalizer-2.x\"\r\n                     ],\r\n        \"alias\":  \"IqOption\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/kuuhaku\",\r\n        \"branches\":  [\r\n                         \"updates/github-codeql-action-2.x\",\r\n                         \"main\",\r\n                         \"doc/Contributing\"\r\n                     ],\r\n        \"alias\":  \"kuuhaku\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/laravel_study.git\",\r\n        \"branches\":  [\r\n                         \"main\"\r\n                     ],\r\n        \"alias\":  \"laravel_study\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/nest_user_api.git\",\r\n        \"branches\":  [\r\n                         \"main\",\r\n                         \"updates/node-16.x\",\r\n                         \"updates/ts-jest-27.x\",\r\n                         \"updates/pin-dependencies\",\r\n                         \"updates/nestjs-schematics-8.x\",\r\n                         \"updates/prettier-2.x\",\r\n                         \"updates/tsconfig-paths-3.x\",\r\n                         \"updates/supertest-2.x\",\r\n                         \"develop\"\r\n                     ],\r\n        \"alias\":  \"nest_user_api\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/php_api\",\r\n        \"branches\":  [\r\n                         \"updates/actions-checkout-3.x\",\r\n                         \"main\",\r\n                         \"updates/samkirkland-ftp-deploy-action-4.x\",\r\n                         \"updates/actions-checkout-2.x\"\r\n                     ],\r\n        \"alias\":  \"php_api\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/raizes-de-aruanda\",\r\n        \"branches\":  [\r\n                         \"develop\",\r\n                         \"main\",\r\n                         \"updates/samkirkland-ftp-deploy-action-4.x\"\r\n                     ],\r\n        \"alias\":  \"raizes-de-aruanda\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/rodcordeiro.git\",\r\n        \"branches\":  [\r\n                         \"lib\",\r\n                         \"master\",\r\n                         \"output\"\r\n                     ],\r\n        \"alias\":  \"rodcordeiro\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/shares.git\",\r\n        \"branches\":  [\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \"shares\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/windows_automation_scripts\",\r\n        \"branches\":  [\r\n                         \"master\"\r\n                     ],\r\n        \"alias\":  \"windows_automation_scripts\"\r\n    },\r\n    {\r\n        \"repo\":  \"git@github.com:rodcordeiro/zabbix_automation_scripts.git\",\r\n        \"branches\":  [\r\n                         \"master\",\r\n                         \"renovate/php-7.x\"\r\n                     ],\r\n        \"alias\":  \"zabbix_automation_scripts\"\r\n    }\r\n]"
    }
]' | ConvertFrom-Json)

# FUNCTIONS

Function prepareEnvironment{
    Write-Output "Preparing environment..."
    installModules

    Write-Output "Creating default folders"
    New-Item -Type Directory -Name Scripts -Path C:\ | Out-Null
    New-Item -Type Directory -Name Tools -Path C:\ | Out-Null
    New-Item -Type Directory -Name projetos -Path $env:USERPROFILE | Out-Null
    
    Write-Output "Install chocolatey"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    Write-Output "Install Node"
    choco install nodejs --version 14.17.3 -y

    downloadBinaries "https://github.com/ytdl-org/youtube-dl/releases/download/2021.12.17/youtube-dl.exe" "youtube-dl"
    downloadBinaries "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v3.4.3/Beekeeper-Studio-Setup-3.4.3.exe" "beekeeper" -Run
    downloadBinaries "https://github.com/Kong/insomnia/releases/download/core%402022.3.0/Insomnia.Core-2022.3.0.exe" "insomnia" -Run
    downloadBinaries "https://download.microsoft.com/download/c/7/c/c7ca93fc-3770-4e4a-8a13-1868cb309166/SSMS-Setup-PTB.exe" "SSMS" -Run
    downloadBinaries "https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022&source=VSLandingPage&includeRecommended=true&cid=2030:2cf06761-eaf3-4ecf-b77b-4421af5d579c" "VisualStudio"

    Download-Repositories $repositories
    Copy-Item "$($env:USERPROFILE)/projetos/.dotfiles/Microsoft.PowerShell_profile.ps1" $PROFILE
    Copy-Item "$($env:USERPROFILE)/projetos/.dotfiles/.gitconfi*" $env:USERPROFILE
    Copy-Item "$($env:USERPROFILE)/projetos/.dotfiles/.npmrc" $env:USERPROFILE
}

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
Function installModules{
    Write-Output "Installing modules..."
    Install-Module Microsoft.PowerShell.Management -Repository PSGalery
    Install-Module  -Name Microsoft.PowerShell.Security -Repository PSGalery
    Install-Module  -Name Microsoft.PowerShell.Utility -Repository PSGalery
    Install-Module  -Name PackageManagement -Repository PSGalery
    Install-Module  -Name PowerShellGet -Repository PSGalery
    Install-Module  -Name PSReadline -Repository PSGalery
    Install-Module  -Name psscriptanalyzer -Repository PSGalery
    Install-Module  -Name Terminal-Icons -Repository PSGalery
    Install-Module  -Name WindowsConsoleFonts -Repository PSGalery
    Write-Output "Modules Installed"
}

Function isInsideGit() {
    if ($(Split-Path -Path $PWD -Leaf) -ne '.git') {
      if ($(Test-Path -Path "$PWD\.git") -ne $False) {
        return Resolve-Path -Path "$PWD"
      }
      if ($(Test-Path -Path "$PWD\..\.git") -ne $False) {
        return Resolve-Path -Path "$PWD\.."
      }
      if ($(Test-Path -Path "$PWD\..\..\.git") -ne $False) {
        return Resolve-Path -Path "$PWD\..\.."
      }    
      if ($(Test-Path -Path "$PWD\..\..\..\.git") -ne $False) {
        return Resolve-Path -Path "$PWD\..\..\.."
      }
    }
    else {
      return Resolve-Path -Path "$PWD"
    }
  }
  
  function clone {
    <# 
    .SYNOPSIS 
        Function to customize repositories cloning with some validations.
    .DESCRIPTION
        Function to customize repositories cloning with some validations. It validates the folder and the repository link.
    .Parameter <Path>
        Repository link
    .Parameter <Folder>
        Provides you the possibility of cloning the repository on a different folder. Pass the desired folder path.
    .Parameter <Alias>
        Provides you the possibility of changing the destiny folder name.
    .Parameter <Confirm>
        Forces execution
    .EXAMPLE
        clone https://github.com/user/repo.git
    .EXAMPLE
        clone https://github.com/user/repo.git -y
    .EXAMPLE
        clone https://github.com/user/repo.git -Folder test
    .EXAMPLE
        clone https://github.com/user/repo.git -Alias someTest
    .EXAMPLE
        clone https://github.com/user/repo.git someTest
    #>

    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, enter the repository link for download")][string]$Path,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Provides you the possibility of changing the destiny folder name.")][string]$Alias,
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Provides you the possibility of cloning the repository on a different folder. Pass the desired folder path.")][string]$Folder,
        [parameter(HelpMessage = "Please, enter the repository link for download")][Alias('y', 'yes')][Switch] $confirm
    )

    if (!$Path) {
        Write-Host "You must provide a repository to clone!"
    }
    $repository = $Path
    $destiny = if ($Folder) { $Folder } else { $pwd }
    $localFolder = if ($Alias) { $Alias } else { $(Split-Path -Path $repository -Leaf) }

    if ($(Split-Path -Path $destiny -Leaf) -eq 'personal' -Or $(Split-Path -Path $destiny -Leaf) -eq 'pda' -Or $(Split-Path -Path $destiny -Leaf) -eq 'estudos' -Or $confirm) {
        if ($folder) { Set-Location $(Resolve-Path -Path $Folder) }
        git clone $repository $(if ($Alias) { $Alias })
        Set-Location $(Resolve-Path -Path $localFolder)
        return
    }

    $response = Read-Host "You're outside of the predefined projects folders. Do you want to proceed? ([Y]es/[N]o)"
    if ($response -eq 'Y' -Or $response -eq 'y' -Or $response -eq 'S' -Or $response -eq 's') {
        if ($folder) { Set-Location $(Resolve-Path -Path $Folder) }
        git clone $repository $(if ($Alias) { $Alias })
        Set-Location $(Resolve-Path -Path $localFolder)
        return
    }
    Write-Host "Cancelling cloning projects. Have a nice day!"
}

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


# EXECUTION
Function Execute{
    param()
    PROCESS {
        prepareEnvironment
    }


}

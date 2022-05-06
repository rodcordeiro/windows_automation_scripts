
<#PSScriptInfo

.VERSION 1.0.0

.GUID 563f01ee-aa0f-4ca4-bcdc-f8a7506ef176

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
 CLI para gerenciamento de arquivos locais dos projetos alocados no servidor 
.DESCRIPTION 
 CLI para gerenciamento de arquivos locais dos projetos alocados no servidor 

#> 
Param()

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Function get_pda_file([string]$Path) {
    if ($(Split-Path -Path $Path -Leaf) -ne '.pda') {
        if (Test-Path -Path "$Path\.pda") {
            return Resolve-Path -Path "$Path\.pda"
        }
        if (Test-Path -Path "..\$Path\.pda") {
            return Resolve-Path -Path "$Path\.pda"
        }
        $folders = $(Get-ChildItem "$Path\*" -Depth 0 -Directory)
        $folders | ForEach-Object {
            $f = "$Path\$_"
            if (Test-Path -Path "$f\.pda") {
                
                return Resolve-Path -Path "$f\.pda"
            }
            $folders2 = $(Get-ChildItem "$f\*" -Depth 0 -Directory)
            $folders2 | ForEach-Object {
                if (Test-Path -Path "$f\$_\.pda") {
                    
                    return Resolve-Path -Path "$f\$_\.pda"
                }               
            
            }
        }
    }
    else {
        return Resolve-Path -Path "$Path"
    }
    
}

Function get_project_data {
    param(
        [parameter(ValueFromPipelineByPropertyName, HelpMessage = "Please, enter the repository link for download")][string]$Path
    )
    if (!$Path) {
        $Path = $PWD;
    }
    $file = get_pda_file($Path)
    if (!$file) {
        Write-Host "File .pda with project settings not found. The file must be placed on the root of the project or in a folder at maximum of 2 depth."
        return
    }
    $content = Get-Content -Path $file 
    $content
}

Function PDA-Init (
        # [parameter(HelpMessage="Template for default configuration")]
        # [ValidateSet("React","RN","Node")]
        # [Alias("T")]
        # [string] $Template,
        # [parameter(ValueFromPipelineByPropertyName,HelpMessage="Skips information input")]
        # [Alias("Y")]
        # [switch] $Confirm
    ){
    $args.split(' -') | ForEach-Object {
        Write-Host "Obj $_"
    }
    
    $settings = @{}
    if($confirm){
        $name = $(Split-Path -Path $pwd -Leaf)
        $id = ''
    } else {
        $name = Read-Host 'Inform the project name'
        $id = Read-Host 'Inform the project id'
    }

    $settings | Add-Member -type NoteProperty -name name -Value $name
    $settings | Add-Member -type NoteProperty -name id -Value $id
    $settings | Add-Member -type NoteProperty -name files -Value @()
    $settings | Add-Member -type NoteProperty -name exclude -Value @()
    
    if($Template){
        New-Item -Type 'Directory' -Name $name -Path '.\' | Out-Null
        New-Item -Type 'File' -Name ".\$name\.pda" -Value $($settings | ConvertTo-Json) | Out-Null
    } else {
        New-Item -Type 'File' -Name '.pda' -Value $($settings | ConvertTo-Json) | Out-Null
    }

    
    

}

function Command-Help { Get-Help -Name pda }
function pda(
    [Parameter(Position = 0)]
    [ValidateSet("init","compress","info","help")]
    [string]$Command,
    [Parameter(Position=1, ValueFromRemainingArguments)]
    $Rest
 ) {
    $args
    switch ($Command) {
        'commit' { 
            commit
        }
        'init' { 
            init $Rest
        }
        'info' { 
            get_project_data
        }
        'help' {
            Command-Help
        }
        Default {
            Command-Help
        }
    }
}


Export-ModuleMember -Function pda
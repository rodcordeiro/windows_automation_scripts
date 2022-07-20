<#
.SYNOPSIS
Recursively checks a directory for git repositories and displays their statuses

.PARAMETER rootPath
The directory root which holds all the git repositories to be checked
https://github.com/krispharper/Powershell-Scripts/blob/master/Get-GitStatuses.ps1
#>

param (
    [string] $rootPath = "."
)

Push-Location -StackName s .

ls $rootPath -Attributes Directory -Force -Depth 1 -Filter .git | % {
    cd $_.FullName
    cd ..
    $status = git status -s

    if ($status) {
        $_.FullName
        git status -s
        ""
    }
}

Pop-Location -StackName s
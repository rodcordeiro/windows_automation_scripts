function Update-Repos {
    # function hasPdaLib{
    #     $pkg = $(get-Content -Path .\package.json | ConvertFrom-Json)
    #     $dependencies = $($pkg.Dependencies | Select-String "pdasolutions")
        
    #     if($dependencies){
    #         return $True
    #     } else {
    #         return $False
    #     }
    # }
    # function UpdatePDAlib{
    #     yarn remove @pdasolutions/web
    #     yarn add @pdasolucoes/web
        
    #     $pkg = $(get-Content -Path .\package.json | ConvertFrom-Json)
    #     $scripts = $pkg.scripts.updateLib
    #     $scripts
    #     if($scripts){
    #         $content = $(get-Content -Path .\package.json).Replace("pdasolutions","pdasolucoes")
    #         Remove-Item .\package.json -Force
    #         New-Item -Type File -Name package.json -Value $content
    #     } else {
    #         return $False
        # }
    # }
    
    # $projectFolders = $(Get-ChildItem -Path "~/projetos" -depth 0 -Recurse)
    # $f = 'pda'
    $folders = Get-Repositories
    # $repositories = @()
    # Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Username "Script do rod" -Webhook $env:disc_darthside -Content "Ignorem. Estou rodando um script de atualizacao automatica dos repositorios"
    $folders | ForEach-Object {
        $folder = Resolve-Path -Path $_
        $folder
    #     Set-Location $folder
    #     $git = isInsideGit
    #     # $lib = hasPdaLib
    #     if($git -and $(git remote -v | Select-String 'fetch')){
    #         # $branch = $(git branch | select-string "\*").ToString().split(" ")[1]
    #         # UpdatePDAlib
    #         $git_dir = $(Split-Path -Path $(git rev-parse --show-toplevel) -Leaf)
    #         $git_index = $PWD.ToString().IndexOf($git_dir)
    #         $CmdPromptCurrentFolder = $PWD.ToString().Substring($git_index)

    #         git add .
    #         git commit -m '[skip ci] Updating repositories'
    #         git pull origin --all
    #         git push -u origin --all
    #         Discord -Avatar "https://rodcordeiro.github.io/shares/img/eu.jpg" -Content "Atualizado o $CmdPromptCurrentFolder" -Username "Script do rod" -Webhook $env:disc_darthside
    #   }
    }
}
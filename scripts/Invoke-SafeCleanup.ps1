<#PSScriptInfo

.VERSION 1.0

.GUID 8e69a94d-9fa1-4a5f-a23a-4546bdf5f39f

.AUTHOR Rodrigo Cordeiro

.PROJECTURI https://rodcordeiro.com.br/

.TAGS Windows Cleanup Temporary Cache

.RELEASENOTES
Initial safe cleanup function based on legacy BAT references.

#>

function Invoke-SafeCleanup {
<#
.SYNOPSIS
    Limpa arquivos temporarios e caches comuns do Windows com perfil conservador.

.DESCRIPTION
    Consolida as rotinas seguras observadas nos scripts BAT de referencia:
    temp de usuario, Windows Temp, caches de navegadores, INetCache e logs/caches
    temporarios. Por padrao remove apenas itens antigos e preserva as pastas-base.

    Use -Full para incluir uma limpeza mais completa, como lixeira, caches de
    Windows Update/Delivery Optimization, Adobe Media Cache, logs antigos e
    caches de todos os perfis locais quando executado como administrador.

    A funcao nao remove cookies, senhas, arquivos de sessao de navegador,
    Windows\Installer, MSOCache, dllcache, repair ou prefetch inteiro.

.PARAMETER Full
    Inclui alvos de maior impacto, ainda limitados a caches, logs e temporarios.

.PARAMETER MinimumAgeHours
    Idade minima dos itens removidos. O padrao evita remover arquivos recem-criados
    ou possivelmente em uso.

.PARAMETER PassThru
    Retorna um objeto com o resumo da limpeza.

.PARAMETER WhatIf
    Mostra o que seria removido sem apagar arquivos.

.EXAMPLE
    . .\Invoke-SafeCleanup.ps1
    Invoke-SafeCleanup

.EXAMPLE
    . .\Invoke-SafeCleanup.ps1
    Invoke-SafeCleanup -Full -WhatIf

.EXAMPLE
    . .\Invoke-SafeCleanup.ps1
    Invoke-SafeCleanup -Full -MinimumAgeHours 6 -PassThru
#>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        [switch]$Full,

        [ValidateRange(0, 8760)]
        [int]$MinimumAgeHours = 24,

        [switch]$PassThru
    )

    Set-StrictMode -Version Latest

    $cutoff = (Get-Date).AddHours(-$MinimumAgeHours)
    $summary = [ordered]@{
        Mode           = if ($Full) { 'Full' } else { 'Default' }
        MinimumAgeHours = $MinimumAgeHours
        TargetsVisited = 0
        FilesRemoved   = 0
        BytesRemoved   = 0L
        Skipped        = 0
        Errors         = 0
    }

    function Test-IsAdministrator {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]::new($identity)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }

    function Format-ByteSize {
        param([double]$Bytes)

        if ($Bytes -ge 1GB) { return '{0:N2} GB' -f ($Bytes / 1GB) }
        if ($Bytes -ge 1MB) { return '{0:N2} MB' -f ($Bytes / 1MB) }
        if ($Bytes -ge 1KB) { return '{0:N2} KB' -f ($Bytes / 1KB) }
        return '{0:N0} B' -f $Bytes
    }

    function Resolve-ExistingPath {
        param([Parameter(Mandatory)][string]$Path)

        try {
            return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path
        }
        catch {
            return $null
        }
    }

    function Test-SafeCleanupRoot {
        param([Parameter(Mandatory)][string]$Path)

        $resolved = Resolve-ExistingPath -Path $Path
        if (-not $resolved) { return $false }

        $blockedRoots = @(
            [Environment]::GetFolderPath('Windows'),
            [Environment]::GetFolderPath('ProgramFiles'),
            ${env:ProgramFiles(x86)},
            "$env:SystemDrive\",
            "$env:SystemDrive\Users"
        ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            ForEach-Object { $_.TrimEnd('\') }

        $normalized = $resolved.TrimEnd('\')
        return -not ($blockedRoots -contains $normalized)
    }

    function Get-CleanupFiles {
        param(
            [Parameter(Mandatory)][string]$Path,
            [string[]]$Include = @('*')
        )

        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            return @()
        }

        foreach ($pattern in $Include) {
            Get-ChildItem -LiteralPath $Path -Force -Recurse -File -Include $pattern -ErrorAction SilentlyContinue |
                Where-Object { $_.LastWriteTime -lt $cutoff }
        }
    }

    function Remove-CleanupFiles {
        param(
            [Parameter(Mandatory)][string]$Label,
            [Parameter(Mandatory)][string]$Path,
            [string[]]$Include = @('*')
        )

        $resolved = Resolve-ExistingPath -Path $Path
        if (-not $resolved) {
            Write-Verbose "Ignorando '$Label': caminho inexistente ($Path)."
            return
        }

        if (-not (Test-SafeCleanupRoot -Path $resolved)) {
            Write-Warning "Ignorando '$Label': raiz bloqueada por seguranca ($resolved)."
            $summary.Skipped++
            return
        }

        $summary.TargetsVisited++
        $files = @(Get-CleanupFiles -Path $resolved -Include $Include)
        if ($files.Count -eq 0) {
            Write-Host "Sem itens antigos em $Label"
            return
        }

        $bytes = ($files | Measure-Object -Property Length -Sum).Sum
        if ($null -eq $bytes) { $bytes = 0 }

        $description = "$($files.Count) arquivo(s), $(Format-ByteSize -Bytes $bytes)"
        if ($PSCmdlet.ShouldProcess($resolved, "Remover $description de $Label")) {
            foreach ($file in $files) {
                try {
                    Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
                    $summary.FilesRemoved++
                    $summary.BytesRemoved += $file.Length
                }
                catch {
                    $summary.Errors++
                    Write-Verbose "Nao foi possivel remover '$($file.FullName)': $($_.Exception.Message)"
                }
            }
        }
    }

    function Remove-EmptyDirectories {
        param(
            [Parameter(Mandatory)][string]$Label,
            [Parameter(Mandatory)][string]$Path
        )

        $resolved = Resolve-ExistingPath -Path $Path
        if (-not $resolved -or -not (Test-SafeCleanupRoot -Path $resolved)) {
            return
        }

        $directories = @(Get-ChildItem -LiteralPath $resolved -Force -Recurse -Directory -ErrorAction SilentlyContinue |
            Sort-Object -Property FullName -Descending)

        foreach ($directory in $directories) {
            try {
                $hasChildren = @(Get-ChildItem -LiteralPath $directory.FullName -Force -ErrorAction SilentlyContinue).Count -gt 0
                if (-not $hasChildren -and $PSCmdlet.ShouldProcess($directory.FullName, "Remover pasta vazia de $Label")) {
                    Remove-Item -LiteralPath $directory.FullName -Force -ErrorAction Stop
                }
            }
            catch {
                $summary.Errors++
                Write-Verbose "Nao foi possivel remover pasta '$($directory.FullName)': $($_.Exception.Message)"
            }
        }
    }

    function Get-LocalUserProfiles {
        param([switch]$AllUsers)

        if (-not $AllUsers) {
            return @([pscustomobject]@{
                Name = $env:USERNAME
                Path = $env:USERPROFILE
            })
        }

        Get-CimInstance -ClassName Win32_UserProfile -ErrorAction SilentlyContinue |
            Where-Object {
                $_.LocalPath -like "$env:SystemDrive\Users\*" -and
                -not $_.Special -and
                (Test-Path -LiteralPath $_.LocalPath -PathType Container)
            } |
            ForEach-Object {
                [pscustomobject]@{
                    Name = Split-Path -Path $_.LocalPath -Leaf
                    Path = $_.LocalPath
                }
            }
    }

    function Invoke-ProfileCleanup {
        param(
            [Parameter(Mandatory)]$Profile,
            [switch]$IncludeFullTargets
        )

        $base = $Profile.Path
        $name = $Profile.Name

        Remove-CleanupFiles -Label "Temp do usuario $name" -Path (Join-Path $base 'AppData\Local\Temp')
        Remove-EmptyDirectories -Label "Temp do usuario $name" -Path (Join-Path $base 'AppData\Local\Temp')

        Remove-CleanupFiles -Label "INetCache do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Windows\INetCache')
        Remove-CleanupFiles -Label "Cache principal do Edge do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Edge\User Data\Default\Cache\Cache_Data') -Include @('data*', 'f*', 'index', '*.tmp')
        Remove-CleanupFiles -Label "GPUCache do Edge do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Edge\User Data\Default\GPUCache') -Include @('d*', 'i*', '*.tmp')
        Remove-CleanupFiles -Label "Code Cache do Edge do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Edge\User Data\Default\Code Cache')
        Remove-CleanupFiles -Label "Service Worker Cache do Edge do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage')
        Remove-CleanupFiles -Label "Cache principal do Chrome do usuario $name" -Path (Join-Path $base 'AppData\Local\Google\Chrome\User Data\Default\Cache\Cache_Data') -Include @('data*', 'f*', 'index', '*.tmp')
        Remove-CleanupFiles -Label "GPUCache do Chrome do usuario $name" -Path (Join-Path $base 'AppData\Local\Google\Chrome\User Data\Default\GPUCache') -Include @('d*', 'i*', '*.tmp')
        Remove-CleanupFiles -Label "Code Cache do Chrome do usuario $name" -Path (Join-Path $base 'AppData\Local\Google\Chrome\User Data\Default\Code Cache')
        Remove-CleanupFiles -Label "Service Worker Cache do Chrome do usuario $name" -Path (Join-Path $base 'AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage')
        Remove-CleanupFiles -Label "Cache do Firefox do usuario $name" -Path (Join-Path $base 'AppData\Local\Mozilla\Firefox\Profiles') -Include @('*.tmp', '*.log', 'startup*.*', 'script*.bin')
        Remove-CleanupFiles -Label "Cache do Opera do usuario $name" -Path (Join-Path $base 'AppData\Local\Opera Software')

        if ($IncludeFullTargets) {
            Remove-CleanupFiles -Label "WebCache logs do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Windows\WebCache') -Include @('*.log', '*.tmp')
            Remove-CleanupFiles -Label "Explorer thumb cache do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Windows\Explorer') -Include @('thumbcache*.db', '*.tmp')
            Remove-CleanupFiles -Label "Terminal Server Client cache do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Terminal Server Client\Cache') -Include @('*.bin')
            Remove-CleanupFiles -Label "Logs do OneDrive do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\OneDrive\setup\logs') -Include @('*.log')
            Remove-CleanupFiles -Label "Adobe Media Cache do usuario $name" -Path (Join-Path $base 'AppData\Roaming\Adobe\Common\Media Cache files')
            Remove-CleanupFiles -Label "Metricas do Edge do usuario $name" -Path (Join-Path $base 'AppData\Local\Microsoft\Edge\User Data\BrowserMetrics') -Include @('*.pma', '*.log')
            Remove-CleanupFiles -Label "Metricas do Chrome do usuario $name" -Path (Join-Path $base 'AppData\Local\Google\Chrome\User Data\BrowserMetrics') -Include @('*.pma', '*.log')
        }
    }

    Write-Host "Iniciando limpeza segura. Modo: $($summary.Mode). Itens mais novos que $MinimumAgeHours hora(s) serao preservados."

    $isAdmin = Test-IsAdministrator
    if ($Full -and -not $isAdmin) {
        Write-Warning 'Modo Full sem administrador: a limpeza completa ficara limitada ao perfil atual e caminhos acessiveis.'
    }

    $profiles = @(Get-LocalUserProfiles -AllUsers:($Full -and $isAdmin))
    foreach ($profile in $profiles) {
        Invoke-ProfileCleanup -Profile $profile -IncludeFullTargets:$Full
    }

    Remove-CleanupFiles -Label 'Windows Temp' -Path (Join-Path $env:WINDIR 'Temp')
    Remove-EmptyDirectories -Label 'Windows Temp' -Path (Join-Path $env:WINDIR 'Temp')

    if ($Full) {
        Remove-CleanupFiles -Label 'Logs CBS antigos' -Path (Join-Path $env:WINDIR 'Logs\CBS') -Include @('*.log')
        Remove-CleanupFiles -Label 'Logs MoSetup antigos' -Path (Join-Path $env:WINDIR 'Logs\MoSetup') -Include @('*.log')
        Remove-CleanupFiles -Label 'Logs Panther antigos' -Path (Join-Path $env:WINDIR 'Panther') -Include @('*.log')
        Remove-CleanupFiles -Label 'Logs INF antigos' -Path (Join-Path $env:WINDIR 'inf') -Include @('*.log')
        Remove-CleanupFiles -Label 'Logs SoftwareDistribution antigos' -Path (Join-Path $env:WINDIR 'SoftwareDistribution') -Include @('*.log')
        Remove-CleanupFiles -Label 'Cache de download do Windows Update' -Path (Join-Path $env:WINDIR 'SoftwareDistribution\Download')
        Remove-CleanupFiles -Label 'Cache de Delivery Optimization' -Path (Join-Path $env:ProgramData 'Microsoft\Windows\DeliveryOptimization\Cache')

        if ($PSCmdlet.ShouldProcess('Lixeira do usuario atual', 'Esvaziar lixeira')) {
            try {
                Clear-RecycleBin -Force -ErrorAction Stop
            }
            catch {
                $summary.Errors++
                Write-Verbose "Nao foi possivel esvaziar a lixeira: $($_.Exception.Message)"
            }
        }
    }

    $result = [pscustomobject]@{
        Mode           = $summary.Mode
        MinimumAgeHours = $summary.MinimumAgeHours
        TargetsVisited = $summary.TargetsVisited
        FilesRemoved   = $summary.FilesRemoved
        BytesRemoved   = $summary.BytesRemoved
        FreedSpace     = Format-ByteSize -Bytes $summary.BytesRemoved
        Skipped        = $summary.Skipped
        Errors         = $summary.Errors
    }

    Write-Host ''
    Write-Host 'Resumo da limpeza'
    Write-Host "Alvos avaliados : $($result.TargetsVisited)"
    Write-Host "Arquivos removidos: $($result.FilesRemoved)"
    Write-Host "Espaco liberado   : $($result.FreedSpace)"
    Write-Host "Itens ignorados   : $($result.Skipped)"
    Write-Host "Erros             : $($result.Errors)"

    if ($PassThru) {
        return $result
    }
}

if ($ExecutionContext.SessionState.Module) {
    Export-ModuleMember -Function Invoke-SafeCleanup
}


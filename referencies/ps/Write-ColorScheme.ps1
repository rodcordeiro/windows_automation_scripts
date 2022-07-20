# https://github.com/krispharper/Powershell-Scripts/blob/master/Write-ColorScheme.ps1
param (
    [string] $output
)
if (-not $output) {
    $noOutput = $true
}

(0..15) | % {
    $fg = $_
    (0..15) | % {
        if ($noOutput) {
            $output = "{0} {1}" -f $fg.ToString("00"), $_.ToString("00")
        }
        Write-Host -ForegroundColor $fg -BackgroundColor $_ -NoNewline " $output "
    }
    Write-Host }
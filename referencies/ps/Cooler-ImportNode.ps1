function Cooler-ImportNode {
    $origpos = $host.UI.RawUI.CursorPosition
    $vDirs = Get-ChildItem $pwd -Directory # -Filter v* 
    $cursor = 0
    $selection = $null
    while ($null -eq $selection) {
        $Host.UI.RawUI.CursorPosition = $origpos
        for ($i = 0; $i -lt $vDirs.Length; $i++) {
            $prefix = If ($cursor -eq $i) { ">" } Else { "-" }
            $color = If ($cursor -eq $i) { "DarkGreen" } Else { "DarkYellow" }
            $name = $vDirs[$i].Name
            Write-Host "$prefix $name" -ForegroundColor $color
        }
        $key = [Console]::ReadKey()
        Switch ($key.Key) {
            "UpArrow" { If ($cursor -eq 0) {} Else { $cursor-- } }
            "DownArrow" { If ($cursor -eq $vDirs.Length - 1) {} Else { $cursor++ } }
            "Enter" { $selection = $cursor }
        }
    }
    Write-Host $vDirs[$selection].FullName
}

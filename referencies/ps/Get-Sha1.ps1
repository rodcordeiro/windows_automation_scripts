param
(
    [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [alias('FullName')]
    [string[]] $Files
)
# https://github.com/krispharper/Powershell-Scripts/blob/master/Get-Sha1.ps1
 
process {
    [Reflection.Assembly]::LoadWithPartialName("System.Security") | out-null
    $sha1 = new-Object System.Security.Cryptography.SHA1Managed
    #$pathLength = (get-location).Path.Length + 1

    if ($Files.Count -gt 0) {
        foreach ($file in $Files) {
            $filename = (Get-Item $file).FullName
            # Write-Host $filename
            #$filenameDisplay = $filename.Substring($pathLength)
             
            #write-host $filenameDisplay

            $openFile = [System.IO.File]::Open($filename, "open", "read")
            # '%' is an alias of 'ForEach-Object'. Alias can introduce possible problems and make scripts hard to maintain. 
            # Please consider changing alias to its full content.
            $sha1.ComputeHash($openFile) | ForEach-Object { write-host -NoNewLine $_.ToString("x2") }

            $openFile.Dispose()

            write-host
        }
    }
}

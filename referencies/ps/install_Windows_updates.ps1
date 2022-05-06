#search and list all missing Drivers
$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()
# $Searcher.ServiceID = '7971f918-a847-4430-9279-4a52d1efe18d'
# $Searcher.SearchScope =  1 # MachineOnly
# $Searcher.ServerSelection = 3 # Third Party
Write-Host -Object 'Searching Driver-Updates...' -ForegroundColor Green
$Criteria = "IsInstalled=0 and ISHidden=0"
$SearchResult = $Searcher.Search($Criteria)
$Updates = $SearchResult.Updates
#Show available Drivers
$Updates | Select-Object -Property Title, DriverModel, DriverVerDate, Driverclass, DriverManufacturer
# #Download the Drivers from Microsoft
$UpdatesToDownload = New-Object -Com Microsoft.Update.UpdateColl
$Updates | Foreach-Object -Process {
    [void]$UpdatesToDownload.Add($_)
}
Write-Host -Object 'Downloading Drivers...' -ForegroundColor Green
$UpdateSession = New-Object -Com Microsoft.Update.Session
$Downloader = $UpdateSession.CreateUpdateDownloader()
$Downloader.Updates = $UpdatesToDownload
$Downloader.Download()
#Check if the Drivers are all downloaded and trigger the Installation
$UpdatesToInstall = New-Object -Com Microsoft.Update.UpdateColl
$updates | Foreach-Object -Process {
    if($_.IsDownloaded){
        [void]$UpdatesToInstall.Add($_)
    }
}
Write-Host -Object 'Installing Drivers...'  -ForegroundColor Green
$Installer = $UpdateSession.CreateUpdateInstaller()
$Installer.Updates = $UpdatesToInstall
$InstallationResult = $Installer.Install()
if($InstallationResult.RebootRequired){
    Write-Host -Object 'Reboot required! please reboot now..' -ForegroundColor Red
}
else {
    Write-Host -Object 'Done..' -ForegroundColor Green
}
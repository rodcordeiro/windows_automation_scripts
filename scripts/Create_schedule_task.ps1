# https://adamtheautomator.com/powershell-scheduled-task/

$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-File C:\scripts\Get-LatestAppLog.ps1'

$taskTrigger = New-ScheduledTaskTrigger -AtStartup -AsJob

# The name of your scheduled task.
$taskName = "ExportAppLog"

# Describe the scheduled task.
$description = "Export the 10 newest events in the application log"

# Register the scheduled task
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description

# Get-ScheduledTaskInfo -TaskName ExportAppLog
# Start-ScheduledTask -TaskName ExportAppLog

# Export the scheduled task object to XML
Get-ScheduledTask -TaskName 'Node_apps' | Export-Clixml c:\temp\ExportAppLog.xml
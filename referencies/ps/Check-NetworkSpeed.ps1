# $adapter = Get-WmiObject -Class Win32_NetworkAdapter -Filter DeviceID=7 -ComputerName pc-kharper
$adapter = Get-WmiObject -Class Win32_NetworkAdapter -Filter DeviceID=2

if ($adapter.Speed -ne 1000000000)
{
    Notify "Network Adapter" "Network Adapter is not at 1 Gbps.`nCurrent speed is $($adapter.Speed / 1000000)Mbps"
    # Send-MailMessage -To kharper@annaly.com,vherrera@annaly.com -From kharper@annaly.com -SmtpServer nyprodmx01 -Subject "Network Adapter is not at 1 Gbps" -Body ("Current speed is " + ($adapter.Speed / 1000000) + "Mbps")
}
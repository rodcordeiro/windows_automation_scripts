
$vpn_name = "XXXX"
$vpn_server= "xxx.ddns.net"
$tunnelType = "Pptp"
$domain_name = ""


Add-VPNConnection -Name $vpn_name -ServerAddress $vpn_server -TunnelType $tunnelType -RememberCredential -SplitTunneling

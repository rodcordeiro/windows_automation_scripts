# Check if the directory "C:\Program Files\RustDesk" exists
if (!(Test-Path "C:\Program Files\RustDesk")) {
  # Create the directory if it does not exist
  New-Item -ItemType Directory -Path "C:\Program Files\RustDesk"
}

# Copy the installation file to the temporary directory
$tempDirectory = Join-Path -Path $env:temp -ChildPath "RustDesk"
New-Item -ItemType Directory -Path $tempDirectory | Out-Null
Copy-Item "\\192.168.0.5\Files\Diversos\RustDesk\rustdesk-1.1.9-putes.exe" $tempDirectory | Out-Null

# Install the RustDesk software silently
Start-Process -FilePath (Join-Path -Path $tempDirectory -ChildPath "rustdesk-1.1.9-putes.exe") -ArgumentList "--silent-install" -Wait

# Replace the configuration file in the Windows Service profile
Copy-Item "\\192.168.0.5\Files\Diversos\RustDesk\RustDesk2.toml" "C:\Windows\ServiceProfiles\LocalService\AppData\Roaming\RustDesk\config" -Force

# Restart the RustDesk service for the update to take effect
Stop-Service -Name RustDesk
Start-Service -Name RustDesk

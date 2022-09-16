# https://devtipscurator.wordpress.com/2017/02/01/quick-tip-how-to-wait-for-user-keypress-in-powershell/
Function Pause ($Message = "Press any key to continue...") {
    # Check if running in PowerShell ISE
    If ($psISE) {
       # "ReadKey" not supported in PowerShell ISE.
       # Show MessageBox UI
       $Shell = New-Object -ComObject "WScript.Shell"
       $Button = $Shell.Popup("Click OK to continue.", 0, "Hello", 0)
       Return
    }
  
    $Ignore =
       16,  # Shift (left or right)
       17,  # Ctrl (left or right)
       18,  # Alt (left or right)
       20,  # Caps lock
       91,  # Windows key (left)
       92,  # Windows key (right)
       93,  # Menu key
       144, # Num lock
       145, # Scroll lock
       166, # Back
       167, # Forward
       168, # Refresh
       169, # Stop
       170, # Search
       171, # Favorites
       172, # Start/Home
       173, # Mute
       174, # Volume Down
       175, # Volume Up
       176, # Next Track
       177, # Previous Track
       178, # Stop Media
       179, # Play
       180, # Mail
       181, # Select Media
       182, # Application 1
       183  # Application 2
  
    Write-Host -NoNewline $Message
    While ($KeyInfo.VirtualKeyCode -Eq $Null -Or $Ignore -Contains $KeyInfo.VirtualKeyCode) {
       $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
    }
 }
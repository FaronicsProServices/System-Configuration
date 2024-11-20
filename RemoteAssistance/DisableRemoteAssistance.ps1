# Disables Remote Assistance by setting the 'fAllowToGetHelp' registry key to 0 and outputs a confirmation message.
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0  
Write-Output "Remote Assistance is disabled."

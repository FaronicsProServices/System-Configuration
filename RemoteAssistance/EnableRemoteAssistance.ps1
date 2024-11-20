# Enables Remote Assistance by setting the 'fAllowToGetHelp' registry key to 1.
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 1

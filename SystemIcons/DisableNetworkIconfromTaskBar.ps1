# Adds a registry key to hide the "Network" icon in the system tray (notification area) by setting the 'HideSCANetwork' value to 1.
# Restart the comptuer to apply changes
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HideSCANetwork /T REG_DWORD /D 1 /F

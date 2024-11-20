# Deletes the 'HideSCANetwork' registry key, restoring the visibility of the "Network" icon in the system tray (notification area).
# Restart the computer to apply the changes.
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HideSCANetwork /F

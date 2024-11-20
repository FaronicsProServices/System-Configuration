# Deletes the 'HideClock' registry key, restoring the system clock visibility in the taskbar.
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HideClock /F

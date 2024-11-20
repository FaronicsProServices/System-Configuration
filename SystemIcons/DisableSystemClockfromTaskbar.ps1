# Adds a registry key to hide the system clock in the taskbar by setting the 'HideClock' value to 1.
# Restart computer to apply changes.
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /V HideClock /T REG_DWORD /D 1 /F

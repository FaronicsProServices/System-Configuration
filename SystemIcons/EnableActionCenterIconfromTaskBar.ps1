# Deletes the 'DisableNotificationCenter' registry key, re-enabling the Notification Center (Action Center) in Windows.
# This restores the action center, allowing network-related notifications and other alerts to be visible in the system tray.
# Restart the computer to apply the changes.
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableNotificationCenter /F

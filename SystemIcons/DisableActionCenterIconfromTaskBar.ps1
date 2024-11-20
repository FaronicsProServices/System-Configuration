# Adds a registry key to disable the Notification Center (Action Center) in Windows, which will hide all notifications, including network-related notifications in the system tray.
# Setting 'DisableNotificationCenter' to 1 disables the notification center and prevents any action center icons from appearing in the tray.
# Restart the computer to apply the changes.
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V DisableNotificationCenter /T REG_DWORD /D 1 /F

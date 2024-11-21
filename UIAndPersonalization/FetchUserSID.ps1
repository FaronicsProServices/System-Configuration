# Retrieves a list of user accounts on the system and displays their Name and SID (Security Identifier)
Get-WmiObject win32_useraccount | Select-Object Name,SID

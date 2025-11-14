# Set timezone to Arizona (no DST)
Set-TimeZone -Id "US Mountain Standard Time"

# Disable automatic timezone updates service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -Value 4 -Type DWord

# Disable automatic daylight saving time adjustment (Registry)
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
Set-ItemProperty -Path $regPath -Name "DisableAutoDaylightTimeSet" -Value 1 -Type DWord

# Restrict registry permissions to prevent users from changing timezone
$acl = Get-Acl $regPath

# Create a new rule to deny SetValue (write) permissions for Users group
$rule = New-Object System.Security.AccessControl.RegistryAccessRule("Users", "SetValue", "Deny")

# Add the rule to the ACL
$acl.AddAccessRule($rule)

# Apply the updated ACL to the registry key
Set-Acl -Path $regPath -AclObject $acl

Write-Output "Arizona time zone set, automatic timezone update disabled, daylight saving adjustment disabled, and user changes restricted via registry permissions."

# Set the timezone to Arizona (no DST)
Set-TimeZone -Id "US Mountain Standard Time"

# Disable automatic daylight saving time adjustment (Registry)
$timeZoneRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
Set-ItemProperty -Path $timeZoneRegPath -Name "DisableAutoDaylightTimeSet" -Value 1 -Type DWord

# Disable the timezone auto-update service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate" -Name "Start" -Value 4 -Type DWord

# Set Group Policy registry key to block user from changing timezone
$gpRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop"
if (-not (Test-Path $gpRegPath)) {
    New-Item -Path $gpRegPath -Force | Out-Null
}
Set-ItemProperty -Path $gpRegPath -Name "NoChangingTimeZone" -Value 1 -Type DWord

# Ensure working folder exists for secpol export
if (-not (Test-Path C:\temp)) {
    New-Item -Path C:\temp -ItemType Directory | Out-Null
}

# Remove 'Change the time zone' privilege from all user groups
secedit.exe /export /cfg C:\temp\secpol.cfg
(gc C:\temp\secpol.cfg) -replace 'SeTimeZonePrivilege\s*=.*', 'SeTimeZonePrivilege = *S-1-5-19' | Set-Content C:\temp\secpol.cfg
secedit.exe /configure /db C:\Windows\security\local.sdb /cfg C:\temp\secpol.cfg /areas USER_RIGHTS
Remove-Item C:\temp\secpol.cfg

# Force Group Policy update to apply changes immediately
Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait

Write-Output "Timezone set to Arizona, daylight saving disabled, timezone auto-update disabled, and ALL users blocked from changing timezone (UI grayed out)."

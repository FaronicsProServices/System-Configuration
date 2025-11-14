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

# Force Group Policy update to apply changes immediately
Start-Process -FilePath "gpupdate.exe" -ArgumentList "/force" -Wait

Write-Output "Timezone set to Arizona, daylight saving disabled, timezone auto-update disabled, and user timezone changes blocked via Group Policy."

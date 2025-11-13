# Set the timezone to Arizona (US Mountain Standard Time without DST)
Set-TimeZone -Id "US Mountain Standard Time"

# Disable automatic daylight saving time adjustment (Registry)
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
Set-ItemProperty -Path $registryPath -Name "DisableAutoDaylightTimeSet" -Value 1 -Type DWord

# Disable user ability to change the time zone
# This removes "Change the time zone" privilege from the Users group

# Check if ntrights.exe is available, otherwise notify user
$programPath = (Get-Command ntrights.exe -ErrorAction SilentlyContinue)?.Source
if (-not $programPath) {
    Write-Warning "ntrights.exe not found. Please download the Windows Server Resource Kit tools and add ntrights.exe to PATH for this step."
} else {
    # Remove SeTimeZonePrivilege from Users group
    Start-Process -FilePath "ntrights.exe" -ArgumentList "-r", "SeTimeZonePrivilege", "-u", "Users" -Wait
}

Write-Output "Arizona time zone set, automatic daylight saving disabled, and user privilege to change time zone revoked."

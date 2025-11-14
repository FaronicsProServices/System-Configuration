# Restore the system timezone to India Standard Time (you can change to your desired timezone)
Set-TimeZone -Id "India Standard Time"

# Re-enable automatic daylight saving time adjustment (Registry)
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
Set-ItemProperty -Path $registryPath -Name "DisableAutoDaylightTimeSet" -Value 0 -Type DWord

# Restore user's ability to change the time zone by granting the privilege to the Users group
$command = Get-Command ntrights.exe -ErrorAction SilentlyContinue
if (-not $command) {
    Write-Warning "ntrights.exe not found. Please download the Windows Server Resource Kit and add ntrights.exe to PATH for this step."
} else {
    # Add SeTimeZonePrivilege to Users group
    Start-Process -FilePath $command.Source -ArgumentList "-e", "SeTimeZonePrivilege", "-u", "Users" -Wait
}

Write-Output "Original time zone restored, automatic daylight saving enabled, and user privilege to change time zone granted."

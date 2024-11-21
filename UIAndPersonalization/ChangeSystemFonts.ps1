# This script creates, imports, and removes a registry file to set a new font substitution (e.g., "Segoe UI") in the system. Restart the computer to apply changes.

# Define paths
$fontConfigPath = "C:\FontConfig"
$regFilePath = "$fontConfigPath\new_font.reg"

# Ensure the FontConfig directory exists
if (!(Test-Path -Path $fontConfigPath)) {
    New-Item -Path $fontConfigPath -ItemType Directory -Force | Out-Null
}

# Define the registry content for a single font
$string1 = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts]
"Segoe UI (TrueType)"="" 

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
"Segoe UI"="$args"
"@

# Create the .reg file
try {
    Set-Content -Path $regFilePath -Value $string1 -Force
    Write-Output "Registry file created successfully: $regFilePath"
} catch {
    Write-Host "Error creating registry file: $($_.Exception.Message)"
    exit
}

# Import the .reg file into the registry
try {
    Start-Process regedit.exe -ArgumentList '/s', $regFilePath -Wait -PassThru | Out-Null
    Write-Output "Registry file imported successfully."
} catch {
    Write-Host "Error importing registry file: $($_.Exception.Message)"
    exit
}

# Clean up the .reg file
try {
    Remove-Item -Path $regFilePath -Force
    Write-Output "Temporary registry file removed: $regFilePath"
} catch {
    Write-Host "Error removing temporary registry file: $($_.Exception.Message)"
}

# This script creates, imports, and removes a registry file to configure font mappings for "Segoe UI" and related fonts on the system. Restart the computer to apply changes.

# Define paths
$fontConfigPath = "C:\Faronics"
$regFilePath = "$fontConfigPath\new_font.reg"

# Ensure the Faronics directory exists
if (!(Test-Path -Path $fontConfigPath)) {
    New-Item -Path $fontConfigPath -ItemType Directory -Force | Out-Null
}

# Define the registry content
$string1 = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts]
"Segoe UI (TrueType)"="segoeui.ttf"
"Segoe UI Black (TrueType)"="seguibl.ttf"
"Segoe UI Black Italic (TrueType)"="seguibli.ttf"
"Segoe UI Bold (TrueType)"="segoeuib.ttf"
"Segoe UI Bold Italic (TrueType)"="segoeuiz.ttf"
"Segoe UI Emoji (TrueType)"="seguiemj.ttf"
"Segoe UI Historic (TrueType)"="seguihis.ttf"
"Segoe UI Italic (TrueType)"="segoeuii.ttf"
"Segoe UI Light (TrueType)"="segoeuil.ttf"
"Segoe UI Light Italic (TrueType)"="seguili.ttf"
"Segoe UI Semibold (TrueType)"="seguisb.ttf"
"Segoe UI Semibold Italic (TrueType)"="seguisbi.ttf"
"Segoe UI Semilight (TrueType)"="segoeuisl.ttf"
"Segoe UI Semilight Italic (TrueType)"="seguisli.ttf"
"Segoe UI Symbol (TrueType)"="seguisym.ttf"
"Segoe MDL2 Assets (TrueType)"="segmdl2.ttf"
"Segoe Print (TrueType)"="segoepr.ttf"
"Segoe Print Bold (TrueType)"="segoeprb.ttf"
"Segoe Script (TrueType)"="segoesc.ttf"
"Segoe Script Bold (TrueType)"="segoescb.ttf"

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
"Segoe UI"=- 
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
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s", $regFilePath -Wait | Out-Null
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

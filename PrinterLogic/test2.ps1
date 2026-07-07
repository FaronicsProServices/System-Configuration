# GitHub Raw URLs (Replace with your actual repo URLs)
$urlIcon = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/PrinterLogic/PrinterLogic.ico"
$urlShortcut = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/PrinterLogic/PrinterLogic.url"

# Destination paths
$destIconFolder = "C:\Users\Public\Public Pictures"
$destShortcutFolder = "C:\Users\Public\Desktop"

# Create directories if they don't exist
New-Item -ItemType Directory -Path $destIconFolder, $destShortcutFolder -Force | Out-Null

# Download files
try {
    Invoke-WebRequest -Uri $urlIcon -OutFile "$destIconFolder\PrinterLogic.ico"
    Invoke-WebRequest -Uri $urlShortcut -OutFile "$destShortcutFolder\PrinterLogic.url"
    Write-Output "Files successfully downloaded and deployed from GitHub."
}
catch {
    Write-Error "Failed to download files: $_"
    exit 1
}

$httpsImageUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$localFilePath = "$([Environment]::GetFolderPath('MyPictures'))\PublicComputerBackground.png"

# Ensure destination folder exists
if (!(Test-Path -Path (Split-Path -Path $localFilePath))) {
    New-Item -ItemType Directory -Path (Split-Path -Path $localFilePath) -Force | Out-Null
}

# Download the image
try {
    Invoke-WebRequest -Uri $httpsImageUrl -OutFile $localFilePath
    Write-Host "Image downloaded to: $localFilePath"
} catch {
    Write-Host "ERROR: Failed to download image. $_"
    exit
}

# Set wallpaper registry key
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $localFilePath

# Apply the wallpaper using user32.dll
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
$result = [Wallpaper]::SystemParametersInfo(20, 0, $localFilePath, 3)

if ($result) {
    Write-Host "✅ Wallpaper applied for: $env:USERNAME"
} else {
    Write-Host "❌ Failed to apply wallpaper visually. Check file path and permissions."
}

# Force refresh
Start-Process "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters" -NoNewWindow

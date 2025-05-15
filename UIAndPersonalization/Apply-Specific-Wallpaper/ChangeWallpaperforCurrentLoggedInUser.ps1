$httpsImageUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$localFilePath = "$env:USERPROFILE\Pictures\PublicComputerBackground.png"

# Ensure destination folder exists
if (!(Test-Path -Path (Split-Path -Path $localFilePath))) {
    New-Item -ItemType Directory -Path (Split-Path -Path $localFilePath) -Force | Out-Null
}

# Download the image
try {
    Invoke-WebRequest -Uri $httpsImageUrl -OutFile $localFilePath
    Write-Host "Image downloaded successfully to $localFilePath"
} catch {
    Write-Host "ERROR: Failed to download image. $_"
    exit
}

# Set wallpaper path in registry
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $localFilePath

# Apply wallpaper using SystemParametersInfo
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $localFilePath, 3)

# Force the system to apply the wallpaper
Start-Process "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters" -NoNewWindow

Write-Host "Wallpaper set successfully for user: $env:USERNAME"

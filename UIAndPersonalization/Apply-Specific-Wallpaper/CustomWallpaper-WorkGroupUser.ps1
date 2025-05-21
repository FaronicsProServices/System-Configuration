# 1. Get current user name
$loggedInUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$usernameOnly = $loggedInUser -replace '.*\\', ''

# 2. Define wallpaper location
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$userPictures = "$env:USERPROFILE\Pictures"
$wallpaperPath = "$userPictures\PublicComputerBackground.png"

# 3. Ensure Pictures folder exists
if (!(Test-Path -Path $userPictures)) {
    New-Item -ItemType Directory -Path $userPictures -Force | Out-Null
}

# 4. Download wallpaper
try {
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing
    Write-Host "Image downloaded to: $wallpaperPath"
} catch {
    Write-Host "Failed to download wallpaper. $_"
    exit
}

# 5. Set wallpaper registry values (HKCU does not require admin)
$regPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value "10"  # Fill
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value "0"

# 6. Ensure wallpaper refreshes at every login using HKCU Run key
$runKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $runKeyPath -Name "ReapplyWallpaper" -Value "rundll32.exe user32.dll,UpdatePerUserSystemParameters"

# 7. Apply wallpaper immediately in current session
Start-Process "rundll32.exe" "user32.dll,UpdatePerUserSystemParameters"

Write-Host "Wallpaper set to Fill. Log off or reboot to confirm persistence."

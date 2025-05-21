# 1. Set wallpaper URL and destination
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$wallpaperFileName = "PublicComputerBackground.png"
$wallpaperPath = "$env:USERPROFILE\Pictures\$wallpaperFileName"

# 2. Ensure Pictures folder exists
if (!(Test-Path -Path "$env:USERPROFILE\Pictures")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Pictures" -Force | Out-Null
}

# 3. Download wallpaper image
try {
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing
    Write-Host "Wallpaper downloaded to: $wallpaperPath"
} catch {
    Write-Host "Failed to download wallpaper. $_"
    exit
}

# 4. Apply registry values (HKCU)
$regPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value "10"  # Fill
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value "0"

# 5. Apply wallpaper immediately
Start-Process "rundll32.exe" "user32.dll,UpdatePerUserSystemParameters"

# 6. Persist across logins via Startup folder
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$scriptSelf = "$startupPath\ApplyWallpaper.ps1"

# 7. Copy script to Startup if not already there
if (-not (Test-Path $scriptSelf)) {
    Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination $scriptSelf -Force
    Write-Host "Script copied to Startup folder for persistence."
} else {
    Write-Host "Script already in Startup folder."
}

Write-Host "Wallpaper applied and will persist at each login."

# 1. Get active user session ID (console)
$session = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty UserName
if (-not $session) {
    Write-Host "No interactive user session found."
    exit
}
$loggedInUser = $session

# 2. Get SID for the user
try {
    $user = New-Object System.Security.Principal.NTAccount($loggedInUser)
    $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).Value
} catch {
    Write-Host "Could not resolve SID for: $loggedInUser"
    exit
}

# 3. Extract username for file paths (strip domain prefix if needed)
$usernameOnly = $loggedInUser -replace '.*\\', ''

# 4. Define file paths
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$userPictures = "C:\Users\$usernameOnly\Pictures"
$wallpaperPath = "$userPictures\PublicComputerBackground.png"

# 5. Create destination folder if missing
if (!(Test-Path -Path $userPictures)) {
    New-Item -ItemType Directory -Path $userPictures -Force | Out-Null
}

# 6. Download wallpaper
try {
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing
    Write-Host "Image downloaded to: $wallpaperPath"
} catch {
    Write-Host "Failed to download wallpaper. $_"
    exit
}

# 7. Update registry hive for that user (FIT wallpaper instead of STRETCH)
$regPath = "Registry::HKEY_USERS\$sid\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value "6"  # Fit
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value "0"

# 8. Create scheduled task to apply wallpaper in user session
$taskName = "ApplyWallpaper"
$refreshCmd = "rundll32.exe user32.dll,UpdatePerUserSystemParameters"
schtasks /Create /TN $taskName /TR "$refreshCmd" /SC ONCE /ST 00:00 /RU "$loggedInUser" /RL HIGHEST /F
schtasks /Run /TN $taskName
Start-Sleep -Seconds 5
schtasks /Delete /TN $taskName /F

Write-Host "Log out and log back in to apply the wallpaper change."

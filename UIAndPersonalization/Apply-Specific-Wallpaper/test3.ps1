# 1. Get the currently logged-in user from active session
$activeSession = (quser | Where-Object { $_ -match "Active" }) -split '\s+'
$loggedInUser = $activeSession[0]

# 2. Resolve SID of the user
try {
    $userSID = (New-Object System.Security.Principal.NTAccount($loggedInUser)).Translate([System.Security.Principal.SecurityIdentifier]).Value
} catch {
    Write-Host "Could not find SID for user: $loggedInUser"
    exit
}

# 3. Define paths
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$userPictures = "C:\Users\$loggedInUser\Pictures"
$wallpaperPath = "$userPictures\PublicComputerBackground.png"

# 4. Create folder if missing
if (!(Test-Path -Path $userPictures)) {
    New-Item -ItemType Directory -Path $userPictures -Force | Out-Null
}

# 5. Download the wallpaper
try {
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing
    Write-Host "Image downloaded to: $wallpaperPath"
} catch {
    Write-Host "Failed to download image. $_"
    exit
}

# 6. Update user’s registry hive for wallpaper
$regPath = "Registry::HKEY_USERS\$userSID\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value "2"  # 2 = Stretched
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value "0"

# 7. Create a scheduled task as that user to refresh wallpaper
$taskName = "ApplyWallpaperOnce"
$script = "rundll32.exe user32.dll,UpdatePerUserSystemParameters"
$taskCmd = "schtasks /Create /TN $taskName /TR `"$script`" /SC ONCE /ST 00:00 /RU $loggedInUser /RL HIGHEST /F"
Invoke-Expression $taskCmd
schtasks /Run /TN $taskName
Start-Sleep -Seconds 5
schtasks /Delete /TN $taskName /F

Write-Host "Wallpaper applied for $loggedInUser"

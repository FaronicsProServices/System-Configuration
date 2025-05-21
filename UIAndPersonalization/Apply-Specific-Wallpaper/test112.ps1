# 1. Set wallpaper URL and file name
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$wallpaperFileName = "PublicComputerBackground.png"
$scriptName = "ApplyWallpaper.ps1"

# 2. Define target user (the non-admin autologon user)
$targetUser = "StandardUser"  # <-- Change this to the actual username

# 3. Build path to Startup and Pictures folder
$userProfile = "C:\Users\$targetUser"
$startupFolder = "$userProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$picturesFolder = "$userProfile\Pictures"
$wallpaperPath = "$picturesFolder\$wallpaperFileName"
$embeddedScriptPath = "$startupFolder\$scriptName"

# 4. Create Pictures and Startup folders if missing
New-Item -ItemType Directory -Path $picturesFolder -Force | Out-Null
New-Item -ItemType Directory -Path $startupFolder -Force | Out-Null

# 5. Download wallpaper image
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing
Write-Host "Wallpaper image downloaded to: $wallpaperPath"

# 6. Write the embedded PowerShell script to user's Startup
$scriptContent = @"
# Auto-run wallpaper apply script
\$wallpaperPath = "$wallpaperPath"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value \$wallpaperPath
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "10"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0"
Start-Process "rundll32.exe" "user32.dll,UpdatePerUserSystemParameters"
Remove-Item "`\$MyInvocation.MyCommand.Path" -Force  # Self-delete after run
"@

$scriptContent | Set-Content -Path $embeddedScriptPath -Encoding UTF8
Write-Host "Wallpaper script written to Startup: $embeddedScriptPath"

Write-Host "Wallpaper will be applied on next login of user: $targetUser"

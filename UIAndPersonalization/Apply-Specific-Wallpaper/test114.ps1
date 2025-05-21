# 1. Define wallpaper URL and local name
$wallpaperUrl = "https://github.com/FaronicsProServices/System-Configuration/blob/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png?raw=true"
$wallpaperFileName = "PublicComputerBackground.png"

# 2. Get currently logged-in (console) user
$loggedInUser = (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
if (-not $loggedInUser) {
    Write-Host " No interactive user session detected. Aborting."
    exit 1
}
$username = $loggedInUser -replace '^.*\\', ''
$userProfile = "C:\Users\$username"
$picturesPath = "$userProfile\Pictures"
$startupPath = "$userProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

# 3. Ensure Pictures and Startup folders exist
New-Item -ItemType Directory -Path $picturesPath -Force | Out-Null
New-Item -ItemType Directory -Path $startupPath -Force | Out-Null

# 4. Download wallpaper
$wallpaperPath = "$picturesPath\$wallpaperFileName"
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -UseBasicParsing

# 5. Create per-user wallpaper script in Startup
$applyScript = @"
# Set wallpaper on login for user
\$path = "$wallpaperPath"
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value \$path
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '10'
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'
Start-Process 'rundll32.exe' 'user32.dll,UpdatePerUserSystemParameters'
Remove-Item "`\$MyInvocation.MyCommand.Definition" -Force
"@

$applyScriptPath = "$startupPath\ApplyWallpaper.ps1"
$applyScript | Set-Content -Path $applyScriptPath -Encoding UTF8

Write-Host "Wallpaper installer script placed in: $applyScriptPath"

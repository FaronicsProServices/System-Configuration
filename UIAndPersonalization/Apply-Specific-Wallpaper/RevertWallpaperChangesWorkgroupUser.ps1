# Get currently logged-in user
$session = (Get-CimInstance -Class Win32_ComputerSystem).UserName
if (-not $session) {
    Write-Host "No interactive user logged in. Exiting."
    exit
}

# Resolve SID and profile path
try {
    $user = New-Object System.Security.Principal.NTAccount($session)
    $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).Value
    $profile = (Get-ItemProperty -Path "Registry::HKEY_USERS\$sid\Volatile Environment").USERPROFILE
    $pictures = Join-Path $profile "Pictures"
    $temp = Join-Path $profile "AppData\Local\Temp"
} catch {
    Write-Host "Failed to resolve user SID or profile."
    exit
}

# Cleanup paths
$WallpaperPath = Join-Path $pictures "PublicComputerBackground.png"
$TempScriptPath = Join-Path $temp "ApplyWallpaper.ps1"
$VbsScriptPath = Join-Path $temp "RunWallpaperSilent.vbs"
$TaskName = "ApplyWallpaperAtLogin"

# Remove wallpaper image and script files
Remove-Item -Path $WallpaperPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $TempScriptPath -Force -ErrorAction SilentlyContinue
Remove-Item -Path $VbsScriptPath -Force -ErrorAction SilentlyContinue

# Delete scheduled task silently
schtasks /Delete /TN $TaskName /F | Out-Null

# Restore default wallpaper (Windows 11)
$DefaultWallpaper = "$env:SystemRoot\Web\Wallpaper\Windows\img0.jpg"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $DefaultWallpaper -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 10 -ErrorAction SilentlyContinue  # Fill
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0 -ErrorAction SilentlyContinue

# Revert to Windows light theme
$personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
if (!(Test-Path $personalizePath)) {
    New-Item -Path $personalizePath -Force | Out-Null
}
New-ItemProperty -Path $personalizePath -Name "AppsUseLightTheme" -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $personalizePath -Name "SystemUsesLightTheme" -Value 1 -PropertyType DWORD -Force | Out-Null

# Restore default Windows 11 theme
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "$env:windir\resources\Themes\Windows.theme" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -ErrorAction SilentlyContinue

# Apply changes immediately
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters ,1 ,True

Write-Host "Wallpaper, theme, and personalization fully reverted to Windows 11 defaults for user: $session"

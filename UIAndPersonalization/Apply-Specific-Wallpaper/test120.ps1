$WallpaperURL = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png"
$WallpaperPath = "$env:USERPROFILE\Pictures\PublicComputerBackground.png"
$TaskName = "ApplyWallpaperAtLogin"

# Ensure Pictures folder exists
if (!(Test-Path -Path (Split-Path $WallpaperPath))) {
    New-Item -Path (Split-Path $WallpaperPath) -ItemType Directory -Force | Out-Null
}

# Download wallpaper if not present
if (!(Test-Path $WallpaperPath)) {
    Invoke-WebRequest -Uri $WallpaperURL -OutFile $WallpaperPath -UseBasicParsing
}

# Apply wallpaper using SystemParametersInfo API
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)

# Define the command that will run at login
$TaskScript = @"
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@;
[Wallpaper]::SystemParametersInfo(20, 0, `"$WallpaperPath`", 3);
"@

# Save that command as a temporary script file
$TempScript = "$env:LOCALAPPDATA\Temp\ApplyWallpaper.ps1"
$TaskScript | Out-File -FilePath $TempScript -Encoding UTF8 -Force

# Register scheduled task to run at user logon
schtasks /Create /TN $TaskName /TR "powershell -ExecutionPolicy Bypass -File `"$TempScript`"" /SC ONLOGON /RL LIMITED /F /RU $env:USERNAME | Out-Null

Write-Host "Wallpaper applied and scheduled to re-apply at login. You're all set."

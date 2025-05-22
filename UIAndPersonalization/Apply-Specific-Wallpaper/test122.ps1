# Get currently logged-in interactive user
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

# Define image info
$WallpaperURL = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png"
$WallpaperPath = Join-Path $pictures "PublicComputerBackground.png"
$TempScriptPath = Join-Path $temp "ApplyWallpaper.ps1"
$TaskName = "ApplyWallpaperAtLogin"

# Ensure folders
New-Item -Path $pictures -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -Path $temp -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Download wallpaper if not present
if (!(Test-Path $WallpaperPath)) {
    Invoke-WebRequest -Uri $WallpaperURL -OutFile $WallpaperPath -UseBasicParsing
}

# Create re-apply PowerShell script
@"
Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@;
[Wallpaper]::SystemParametersInfo(20, 0, `"$WallpaperPath`", 3);
"@ | Out-File -FilePath $TempScriptPath -Encoding UTF8 -Force

# Create VBScript to silently run the PowerShell script
$VbsPath = Join-Path $temp "RunWallpaperSilent.vbs"
$VbsContent = "Set WshShell = CreateObject(""WScript.Shell"")" + [Environment]::NewLine +
              "WshShell.Run ""powershell -ExecutionPolicy Bypass -File `""$TempScriptPath`"" "", 0, False"
$VbsContent | Out-File -FilePath $VbsPath -Encoding ASCII -Force

# Register scheduled task that runs VBScript silently
schtasks /Create /TN $TaskName /TR "wscript.exe `"$VbsPath`"" /SC ONLOGON /RL LIMITED /F /RU $session | Out-Null

Write-Host "Wallpaper applied and scheduled to re-apply silently at login for user: $session"

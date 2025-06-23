# RevertWallpaperLockdown_Elevated.ps1
# Self-elevates and reverts wallpaper lockdown across all users without requiring logout

# Self-elevate if not running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Main logic starts here
$ScriptRoot = $PSScriptRoot
if ([string]::IsNullOrEmpty($ScriptRoot)) {
    $ScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

$LogDir = "$ScriptRoot\logs"
$LogFile = "$LogDir\RevertWallpaperLockdown.log"
$drive = $Env:SystemDrive
$users = Get-ChildItem "$drive\Users"
$CurrentUserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value

function CreateLogDir {
    If (!(Test-Path $LogDir)) {
        mkdir $LogDir | out-null
    }
}
function Log {
    param([string]$logstring)
    $Logtime = Get-Date -Format "dd/MM/yyyy HH:mm:ss:fff"
    $logToWrite = "{$Logtime[PID:$PID]} : $logstring"
    Write-Host $logToWrite
    Add-content $LogFile -value $logToWrite
}

function EnableWallpaperModification {
    param($RegBase)

    $ActiveDesktopKey = "$RegBase\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
    $SystemKey        = "$RegBase\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $DesktopKey       = "$RegBase\Control Panel\Desktop"

    if (Test-Path $ActiveDesktopKey) {
        Remove-ItemProperty -Path $ActiveDesktopKey -Name "NoChangingWallPaper" -ErrorAction SilentlyContinue
    }

    if (Test-Path $SystemKey) {
        Remove-ItemProperty -Path $SystemKey -Name "Wallpaper" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $SystemKey -Name "WallpaperStyle" -ErrorAction SilentlyContinue
    }

    if (Test-Path $DesktopKey) {
        Remove-ItemProperty -Path $DesktopKey -Name "Wallpaper" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $DesktopKey -Name "WallpaperStyle" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $DesktopKey -Name "TileWallpaper" -ErrorAction SilentlyContinue
    }
}

function RevertForAllUsers {
    foreach ($user in $users) {
        $userHive = "$($drive)\Users\$($user.Name)\NTUSER.DAT"
        if ($user.Name -ne $env:USERNAME -and (Test-Path $userHive)) {
            Log "Loading user hive for $($user.Name)"
            reg.exe LOAD HKU\Temp "$userHive" | Out-Null
            EnableWallpaperModification -RegBase "Registry::HKEY_USERS\Temp"
            reg.exe UNLOAD HKU\Temp | Out-Null
            Log "Unloaded hive for $($user.Name)"
        }
    }
}

function RevertForLoadedHives {
    $HKEY_USERS = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -notlike "*_Classes" }

    foreach ($Key in $HKEY_USERS) {
        EnableWallpaperModification -RegBase "Registry::$($Key.Name)"
    }
}

# Execution starts here
try {
    Push-Location $ScriptRoot
    CreateLogDir
    Log "=== Reverting Wallpaper Personalization Restrictions with Elevation ==="

    RevertForAllUsers
    RevertForLoadedHives

    Log "Triggering system to refresh wallpaper settings"
    for ($i = 0; $i -lt 3; $i++) {
        Start-Process -FilePath "C:\Windows\System32\RUNDLL32.EXE" -ArgumentList "user32.dll,UpdatePerUserSystemParameters"
        Start-Sleep -Seconds 1
    }

    Log "Reversion completed successfully."
}
finally {
    Pop-Location
}

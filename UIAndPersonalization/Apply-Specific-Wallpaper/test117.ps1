# Get currently logged-in console user (domain\user or just user)
$sessionUser = (Get-CimInstance Win32_ComputerSystem).UserName
if (-not $sessionUser) {
    Write-Host "No interactive user is logged in."
    exit
}

# Strip domain if present
$username = $sessionUser -replace '.*\\', ''
$userProfile = "C:\Users\$username"

# Download destination
$localFilePath = "C:\wallpaper\PublicComputerBackground.png"
$imageUrl = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png"

# Create wallpaper folder if it doesn't exist
if (!(Test-Path "C:\wallpaper")) {
    New-Item -ItemType Directory -Path "C:\wallpaper" -Force | Out-Null
}

# Download wallpaper
try {
    Invoke-WebRequest -Uri $imageUrl -OutFile $localFilePath -UseBasicParsing
    Write-Host "Wallpaper downloaded to: $localFilePath"
} catch {
    Write-Host "Failed to download the wallpaper. $_"
    exit
}

# Get SID of currently logged-in user
try {
    $userObj = New-Object System.Security.Principal.NTAccount($username)
    $sid = $userObj.Translate([System.Security.Principal.SecurityIdentifier]).Value
} catch {
    Write-Host "Could not resolve SID for: $username"
    exit
}

# Registry path for wallpaper
$regPath = "Registry::HKEY_USERS\$sid\Control Panel\Desktop"

# Create registry key if it doesn't exist
if (!(Test-Path $regPath)) {
    New-Item -Path "Registry::HKEY_USERS\$sid\Control Panel" -Name "Desktop" -Force | Out-Null
}

# Set wallpaper values
Set-ItemProperty -Path $regPath -Name Wallpaper -Value $localFilePath
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value "10"  # Fill
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value "0"

Write-Host "Wallpaper registry updated for: $username"
Write-Host "Log out and log back in to apply the new wallpaper."

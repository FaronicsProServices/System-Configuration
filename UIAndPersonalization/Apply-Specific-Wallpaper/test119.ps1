$Data = @{
    WallpaperURL = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png"
    DownloadDirectory = "C:\temp"
    RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
    StatusValue = "1"
}

# Create destination path with correct file extension
$WallpaperDest = "$($Data.DownloadDirectory)\Wallpaper." + ($Data.WallpaperURL -split '\.')[-1]

# Create destination folder
New-Item -ItemType Directory -Path $Data.DownloadDirectory -ErrorAction SilentlyContinue | Out-Null

# Download the wallpaper
Start-BitsTransfer -Source $Data.WallpaperURL -Destination $WallpaperDest

# Create registry key and apply wallpaper settings
New-Item -Path $Data.RegKeyPath -Force -ErrorAction SilentlyContinue | Out-Null
New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImageStatus' -Value $Data.StatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImagePath' -Value $WallpaperDest -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $Data.RegKeyPath -Name 'DesktopImageUrl' -Value $WallpaperDest -PropertyType STRING -Force | Out-Null

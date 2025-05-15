$httpsImageUrl = "https://raw.githubusercontent.com/FaronicsProServices/System-Configuration/refs/heads/main/UIAndPersonalization/Apply-Specific-Wallpaper/Public%20computer%20background%20rules.png"
$localFilePath = "C:\wallpaper\PublicComputerBackground.png"

# Ensure the destination folder exists
if (!(Test-Path "C:\wallpaper")) {
    New-Item -ItemType Directory -Path "C:\wallpaper" -Force | Out-Null
}

# Download the image from GitHub
try {
    Invoke-WebRequest -Uri $httpsImageUrl -OutFile $localFilePath
    Write-Host "Image downloaded successfully."
} catch {
    Write-Host "ERROR: Failed to download the image from $httpsImageUrl. $_"
    exit
}

# Define the specific username (adjust accordingly)
$specifiedUser = "CONTOSO\admin2"

# Get SID for the specified user
function Get-UserSID([string]$username) { 
    try { 
        $user = New-Object System.Security.Principal.NTAccount($username)  
        $sid = $user.Translate([System.Security.Principal.SecurityIdentifier])  
        if (-NOT[string]::IsNullOrEmpty($sid)) { 
            Write-Output $sid.Value 
        } 
    } 
    catch {  
        Write-Output "Failed to get specified user SID."  
        Write-Host "Error: ", $_.Exception.Message 
    } 
} 

Write-Host "--------------Starting script execution--------------" 

$specificUserSID = Get-UserSID $specifiedUser 

if (-NOT $specificUserSID) {
    Write-Host "Could not retrieve SID for the user: $specifiedUser"
    exit
}

$userRegistryPath = "Registry::HKEY_USERS\$($specificUserSID)\Control Panel\Desktop"

# Set the wallpaper in registry
Set-ItemProperty -Path $userRegistryPath -Name wallpaper -Value $localFilePath

Write-Host "Wallpaper registry updated. Restart the device or logoff to apply."
Write-Host "--------------Script execution completed successfully--------------"

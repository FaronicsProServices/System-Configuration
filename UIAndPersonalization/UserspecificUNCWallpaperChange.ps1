$filePathUNC = "\\Server\folder\img.jpg" # specify the UNC path to the image
$localFilePath = "C:\wallpaper\img.jpg" # this folder should either already be there or it should be a common folder on the targeted client

# Copy the file locally
Copy-Item -Path $filePathUNC -Destination $localFilePath -Force

# Define a specific username (Modify this as needed)
$specifiedUser = "username"  # Replace with the actual username

# Function to get SID for a specific user
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
        Write-Host "Error occurred while running script -> ",$_.Exception.Message 
    } 
} 

Write-Host "--------------Starting script execution--------------" 

$specificUserSID = Get-UserSID $specifiedUser 

if (-NOT $specificUserSID) {
    Write-Host "Could not retrieve SID for the user: $specifiedUser"
    exit
}

$userRegistryPath = "Registry::HKEY_USERS\$($specificUserSID)\Control Panel\Desktop"  

# Apply wallpaper for the specified user
Set-ItemProperty -Path $userRegistryPath -Name wallpaper -Value $localFilePath            

Write-Host "--------------Script execution completed successfully--------------" 
Write-Host "Apply Restart device action to reflect the changes immediately" 

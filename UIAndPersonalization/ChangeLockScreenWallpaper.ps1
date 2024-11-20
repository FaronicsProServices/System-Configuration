# Define the parent registry path 
$parentRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" 

# Define the name and value 
$keyName = "LockScreenImagePath" 
$imagePath = "C:\Path\to\the\file" 

# Create the registry key 
New-Item -Path $parentRegistryPath -Name $keyName -Force 

# Set the registry key value 
Set-ItemProperty -Path "$parentRegistryPath" -Name $keyName -Value $imagePath

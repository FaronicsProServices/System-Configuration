# Temporarily bypass the execution policy for this script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# --- BULLETPROOF DRIVE CLEANUP START ---
$DriveLetter = "Y"

# 1. Force remove via traditional Windows Command
net use "${DriveLetter}:" /delete /y 2>$null

# 2. Force remove via Windows COM Object (catches stubborn Explorer maps)
try {
    $net = New-Object -ComObject WScript.Network
    $net.RemoveNetworkDrive("${DriveLetter}:", $true, $true)
} catch {
    # Silently ignore if the drive wasn't there
}

# 3. Clean up the internal PowerShell session environment just in case
if (Get-PSDrive -Name $DriveLetter -ErrorAction SilentlyContinue) { 
    Remove-PSDrive -Name $DriveLetter -Force -ErrorAction SilentlyContinue 
}
# --- BULLETPROOF DRIVE CLEANUP END ---


# Prompt the user for their username
$username = Read-Host -Prompt "Username"

# Define credentials
$netUsePassword = "P0s1Sc@nC0py!"
$netUseUser = "positronic.local\PIIScans"

# Map the drive to the initial shared folder 
# Note: If you still get the "Multiple connections" error from before, change the server name to the IP address here!
New-PSDrive -Name "Y" -PSProvider FileSystem -Root "\\dfw-fs1.positronic.local\HPThinClients" -Persist -Credential (New-Object PSCredential $netUseUser, (ConvertTo-SecureString $netUsePassword -AsPlainText -Force))

# Create a folder in the shared directory with the user's username
New-Item -Path "Y:\$username" -ItemType Directory -Force

# Remove the temporary mapping cleanly
Remove-PSDrive -Name "Y" -Force
net use Y: /delete /y 2>$null

# Map the drive to the user's specific folder
New-PSDrive -Name "Y" -PSProvider FileSystem -Root "\\dfw-fs1.positronic.local\HPThinClients\$username" -Persist -Credential (New-Object PSCredential $netUseUser, (ConvertTo-SecureString $netUsePassword -AsPlainText -Force))

# Pause for user confirmation
Write-Host "Press any key to continue..." -ForegroundColor Yellow
[void][System.Console]::ReadKey($true)

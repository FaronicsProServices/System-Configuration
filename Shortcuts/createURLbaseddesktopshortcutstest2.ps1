# Create-URLShortcuts.ps1
# Creates web shortcuts with custom icons on the Public Desktop for all users

# Public desktop path
$PublicDesktop = "$env:PUBLIC\Desktop"

# Path to browser icon (change if needed)
# Common Chrome path:
$IconPath = "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"

# Check if Chrome exists; fallback to Edge
if (-not (Test-Path $IconPath)) {
    $IconPath = "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe"
}

# Fallback to Windows shell icon if neither browser is found
if (-not (Test-Path $IconPath)) {
    $IconPath = "$env:SystemRoot\system32\SHELL32.dll"
    $IconIndex = 220
} else {
    $IconIndex = 0
}

# Define web links
$webLinks = @(
    @{ Name = "Azure Portal"; URL = "https://portal.azure.com" },
    @{ Name = "Gmail";        URL = "https://mail.google.com" },
    @{ Name = "Outlook";      URL = "https://outlook.live.com" }
)

# Create each shortcut
foreach ($link in $webLinks) {
    $shortcutPath = Join-Path $PublicDesktop "$($link.Name).url"

    Set-Content -Path $shortcutPath -Value @"
[InternetShortcut]
URL=$($link.URL)
IconFile=$IconPath
IconIndex=$IconIndex
"@ -Encoding ASCII
}

Write-Host "✅ Web shortcuts with icons created on Public Desktop."

# Create-URLShortcuts.ps1
# Creates URL shortcuts on Public Desktop using Edge or Chrome icons

$PublicDesktop = "$env:PUBLIC\Desktop"

# Preferred browser icon path (Chrome > Edge > fallback)
$ChromeIconPath = "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
$EdgeIconPath   = "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe"
$ShellIconPath  = "$env:SystemRoot\system32\SHELL32.dll"

# Set default icon path
if (Test-Path $ChromeIconPath) {
    $IconFile = $ChromeIconPath
    $IconIndex = 0
} elseif (Test-Path $EdgeIconPath) {
    $IconFile = $EdgeIconPath
    $IconIndex = 0
} else {
    $IconFile = $ShellIconPath
    $IconIndex = 220
}

# Web shortcuts to create
$webLinks = @(
    @{ Name = "Azure Portal"; URL = "https://portal.azure.com" },
    @{ Name = "Gmail";        URL = "https://mail.google.com" },
    @{ Name = "Outlook";      URL = "https://outlook.live.com" }
)

# Create shortcuts
foreach ($link in $webLinks) {
    $shortcutPath = Join-Path $PublicDesktop "$($link.Name).url"

    Set-Content -Path $shortcutPath -Value @"
[InternetShortcut]
URL=$($link.URL)
IconFile=$IconFile
IconIndex=$IconIndex
"@ -Encoding ASCII
}

Write-Host "✅ Web shortcuts created with browser icons on Public Desktop."

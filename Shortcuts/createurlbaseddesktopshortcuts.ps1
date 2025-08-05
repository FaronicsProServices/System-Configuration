# Create-LNK-Shortcuts.ps1
# Creates Chrome/Edge shortcuts with icons on Public Desktop

# Get public desktop path
$PublicDesktop = "$env:PUBLIC\Desktop"

# Choose browser (Chrome preferred, fallback to Edge)
$chrome = "${env:Program Files\Google\Chrome\Application\chrome.exe"
$edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"

if (Test-Path $chrome) {
    $browserPath = $chrome
} elseif (Test-Path $edge) {
    $browserPath = $edge
} else {
    Write-Error "❌ Chrome or Edge not found."
    exit 1
}

# Define shortcuts
$webLinks = @(
    @{ Name = "Azure Portal"; URL = "https://portal.azure.com" },
    @{ Name = "Gmail";        URL = "https://mail.google.com" },
    @{ Name = "Outlook";      URL = "https://outlook.live.com" }
)

# Create shortcuts
$WScriptShell = New-Object -ComObject WScript.Shell

foreach ($link in $webLinks) {
    $ShortcutFile = Join-Path $PublicDesktop "$($link.Name).lnk"
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)

    $Shortcut.TargetPath = $browserPath
    $Shortcut.Arguments = $link.URL
    $Shortcut.IconLocation = "$browserPath,0"
    $Shortcut.Description = "Open $($link.Name) in browser"
    $Shortcut.Save()
}

Write-Host "✅ LNK shortcuts created on Public Desktop with proper icons."

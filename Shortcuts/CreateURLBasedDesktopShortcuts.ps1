# Create-LNK-Shortcuts.ps1
# Creates .lnk shortcuts on Public Desktop with Chrome or Edge icons

$PublicDesktop = "$env:PUBLIC\Desktop"

# Set Chrome path (64-bit)
$chrome = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
# Set Edge fallback
$edge = "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe"

# Determine available browser
if (Test-Path $chrome) {
    $browserPath = $chrome
} elseif (Test-Path $edge) {
    $browserPath = $edge
} else {
    Write-Error "Chrome or Edge not found on this system."
    exit 1
}

# Define shortcuts
# To add more shortcuts, insert new entries below in the same format:
# @{ Name = "Name to Display"; URL = "https://example.com" },
$webLinks = @(
    @{ Name = "Apply to PCC"; URL = "https://www.pima.edu/admission/apply-to-pima/index.html" },
    @{ Name = "AZTransfer"; URL = "https://mail.google.com" },
    @{ Name = "FSA ID"; URL = "https://studentaid.gov/fsa-id/create-account/launch" },
    @{ Name = "FAFSA - Apply for Aid"; URL = "https://studentaid.gov/h/apply-for-aid/fafsa" }
)


# Create each .lnk shortcut
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

Write-Host "Chrome/Edge shortcuts created on Public Desktop with correct icons."

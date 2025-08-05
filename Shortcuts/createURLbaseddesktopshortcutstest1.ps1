# Create-URLShortcuts.ps1
# This script creates URL shortcuts on the Public Desktop (visible to all users)

$PublicDesktop = "$env:PUBLIC\Desktop"

$webLinks = @(
    @{
        Name = "Azure Portal"
        URL  = "https://portal.azure.com"
    },
    @{
        Name = "Gmail"
        URL  = "https://mail.google.com"
    }
    @{
        Name = "Outlook"
        URL  = "https://outlook.live.com"
    }
)

foreach ($link in $webLinks) {
    $shortcutPath = Join-Path $PublicDesktop "$($link.Name).url"

    Set-Content -Path $shortcutPath -Value @"
[InternetShortcut]
URL=$($link.URL)
IconFile=%SystemRoot%\system32\SHELL32.dll
IconIndex=220
"@
}

Write-Host "✅ Web shortcuts created on Public Desktop."

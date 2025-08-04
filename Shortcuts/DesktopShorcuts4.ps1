# Create-URLShortcuts.ps1
# This script creates URL shortcuts on the Public Desktop (visible to all users)

$PublicDesktop = "$env:PUBLIC\Desktop"

$webLinks = @(
    @{
        Name = "Mistral Chat"
        URL  = "https://chat.mistral.ai/"
    },
    @{
        Name = "Gemini by Google"
        URL  = "https://gemini.google.com/"
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

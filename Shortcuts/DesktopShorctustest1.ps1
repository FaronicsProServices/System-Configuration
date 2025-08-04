# Define browser-specific website shortcuts
$shortcuts = @(
    @{ Name = "Open ChatGPT in Chrome"; Browser = "chrome.exe"; Url = "https://chat.openai.com" },
    @{ Name = "Open Microsoft in Edge"; Browser = "msedge.exe"; Url = "https://microsoft.com" },
    @{ Name = "Open Firefox Addons"; Browser = "firefox.exe"; Url = "https://addons.mozilla.org" }
)

# Location to place the shortcuts
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shell = New-Object -ComObject WScript.Shell

foreach ($s in $shortcuts) {
    $shortcutPath = Join-Path $desktopPath ($s.Name + ".lnk")

    # Create the shortcut
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $s.Browser
    $shortcut.Arguments = $s.Url
    $shortcut.IconLocation = $s.Browser
    $shortcut.Save()
}

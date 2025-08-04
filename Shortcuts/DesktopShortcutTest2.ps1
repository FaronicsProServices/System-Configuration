# Define shortcut list (URL + browser EXE name or full path)
$shortcuts = @(
    @{ Name = "Open ChatGPT in Chrome"; Browser = "chrome.exe"; Url = "https://chat.openai.com" },
    @{ Name = "Open Microsoft in Edge"; Browser = "msedge.exe"; Url = "https://microsoft.com" },
    @{ Name = "Open Firefox Addons"; Browser = "firefox.exe"; Url = "https://addons.mozilla.org" }
)

# Safely get desktop path
$desktopPath = [Environment]::GetFolderPath("Desktop")

if (-not $desktopPath) {
    Write-Error "❌ Could not resolve Desktop path."
    exit 1
}

# Create COM object for WScript.Shell
$shell = New-Object -ComObject WScript.Shell

foreach ($s in $shortcuts) {
    try {
        # Full path for shortcut file
        $shortcutPath = Join-Path -Path $desktopPath -ChildPath ($s.Name + ".lnk")

        # Create the shortcut object
        $shortcut = $shell.CreateShortcut($shortcutPath)

        # Set shortcut properties
        $shortcut.TargetPath = $s.Browser
        $shortcut.Arguments = $s.Url
        $shortcut.IconLocation = $s.Browser
        $shortcut.Save()

        Write-Output "✅ Created shortcut: $shortcutPath"
    } catch {
        Write-Warning "⚠️ Failed to create shortcut for '$($s.Name)': $_"
    }
}

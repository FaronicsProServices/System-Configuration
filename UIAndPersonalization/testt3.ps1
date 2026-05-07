# 1. Disable First Logon Animation
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "EnableFirstLogonAnimation" -Value 0 -Force

# 2. Disable Consumer Features
$CloudPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent"
)

foreach ($Path in $CloudPaths) {
    if (!(Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "DisableWindowsConsumerFeatures" -Value 1 -Force
}

# 3. Disable Automatic Startup Apps (Registry-based)
$RunPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

# List common startup items to remove (e.g., OneDrive, Teams, Edge, etc.)
$StartupItems = @("OneDriveSetup", "TeamsMachineInstaller", "MicrosoftEdgeAutoLaunch")

foreach ($Path in $RunPaths) {
    if (Test-Path $Path) {
        foreach ($Item in $StartupItems) {
            Remove-ItemProperty -Path $Path -Name $Item -ErrorAction SilentlyContinue
        }
    }
}

# 4. Active Setup Cleanup
$ActiveSetupPath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components"
$SafeTargets = @("Microsoft Edge","Internet Explorer","Windows Media Player","OneDrive")

Get-ChildItem $ActiveSetupPath | ForEach-Object {
    $Props = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
    foreach ($Target in $SafeTargets) {
        if ($Props."(Default)" -like "*$Target*") {
            Remove-ItemProperty -Path $_.PSPath -Name "StubPath" -ErrorAction SilentlyContinue
        }
    }
}

# 5. Master Bloatware & Slowdown Offenders List
$Bloatware = @(
    "AD2F1837.HPPrinterControl",
    "AppUp.IntelGraphicsExperience",
    "C27EB4BA.DropboxOEM*",
    "Disney.37853FC22B2CE",
    "DolbyLaboratories.DolbyAccess",
    "DolbyLaboratories.DolbyAudio",
    "E0469640.SmartAppearance",
    "Microsoft.549981C3F5F10",
    "Microsoft.AV1VideoExtension",
    "Microsoft.BingNews",
    "Microsoft.BingSearch",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.GamingApp",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftEdge.Stable",
    "Microsoft.MicrosoftJournal",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftTeams",
    "Microsoft.MixedReality.Portal",
    "Microsoft.News",
    "Microsoft.Office.Lens",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Sway",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.PowerAutomateDesktop",
    "Microsoft.PowerAutomateDesktopCopilotPlugin",
    "Microsoft.Print3D",
    "Microsoft.RemoteDesktop",
    "Microsoft.SkypeApp",
    "Microsoft.SysinternalsSuite",
    "Microsoft.Teams",
    "Microsoft.Todos",
    "Microsoft.Windows.DevHome",
    "Microsoft.WindowsAlarms",
    "Microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "MicrosoftTeams",
    "MicrosoftCorporationII.MicrosoftFamily",
    "MicrosoftCorporationII.QuickAssist",
    "MicrosoftWindows.CrossDevice",
    "MirametrixInc.GlancebyMirametrix",
    "RealtimeboardInc.RealtimeBoard",
    "SpotifyAB.SpotifyMusic",
    "5A894077.McAfeeSecurity",
    "Adobe Creative Cloud All Apps 2-month membership",
    "Intel Connectivity Performance Suite",
    "Intel Unison",
    "Microsoft.Edge.GameAssist"
)

Write-Host "Starting AppX Cleanup (This may take a few minutes)..." -ForegroundColor Cyan

# 6. Remove Provisioned & Installed Packages
foreach ($App in $Bloatware) {
    # Remove from the Windows Image (for NEW users)
    Get-AppxProvisionedPackage -Online |
        Where-Object { $_.DisplayName -eq $App } |
        ForEach-Object { 
            Write-Host "De-provisioning: $App" -ForegroundColor Gray
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue 
        }

    # Remove from current system (for ALL EXISTING users)
    Get-AppxPackage -AllUsers -Name $App |
        ForEach-Object { 
            Write-Host "Uninstalling for all users: $App" -ForegroundColor Yellow
            Remove-AppxPackage -AllUsers -Package $_.PackageFullName -ErrorAction SilentlyContinue 
        }
}

Write-Host "`nDone. Reboot before freezing." -ForegroundColor Green

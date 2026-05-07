# Disable First Logon Animation
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "EnableFirstLogonAnimation" -Value 0 -Force

#Disable Consumer Features
$CloudPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Intent"
)

foreach ($Path in $CloudPaths) {
    if (!(Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name "DisableWindowsConsumerFeatures" -Value 1 -Force
}

#OneDrive Auto-Start
$RunPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
if (Test-Path $RunPath) {
    Remove-ItemProperty -Path $RunPath -Name "OneDriveSetup" -ErrorAction SilentlyContinue
}

#Active Setup Cleanup
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

# Bloatware
$Bloatware = @(
    "AD2F1837.HPPrinterControl",
    "AppUp.IntelGraphicsExperience",
    "C27EB4BA.DropboxOEM*",
    "Disney.37853FC22B2CE",
    "DolbyLaboratories.DolbyAccess",
    "DolbyLaboratories.DolbyAudio",
    "E0469640.SmartAppearance",
    "Microsoft.549981C3F5F10",                    # Cortana
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
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "MicrosoftCorporationII.MicrosoftFamily",
    "MicrosoftCorporationII.QuickAssist",
    "MicrosoftWindows.CrossDevice",
    "MirametrixInc.GlancebyMirametrix",
    "RealtimeboardInc.RealtimeBoard",
    "SpotifyAB.SpotifyMusic",
    "5A894077.McAfeeSecurity",
    "5A894077.McAfeeSecurity_2.1.27.0_x64__wafk5atnkzcwy",
    "Adobe Creative Cloud All Apps 2-month membership",
    "Intel Connectivity Performance Suite",
    "Intel Unison",
    "Microsoft.Edge.GameAssist"
)

# Remove AppX provisioned packages
Get-AppxProvisionedPackage -Online |
    Where-Object { $Bloatware -contains $_.DisplayName } |
    ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue }

# Remove AppX installed packages
foreach ($App in $Bloatware) {
    Get-AppxPackage -AllUsers -Name $App |
        ForEach-Object { Remove-AppxPackage -AllUsers -Package $_.PackageFullName -ErrorAction SilentlyContinue }

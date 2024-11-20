# Define registry paths for the policies
$MessageTextPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$MessageTitlePolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# Set values for the registry keys
$MessageText = "Your legal notice text here"
$MessageTitle = "Your legal notice title here"

# Apply the legal notice text and title to the registry
Set-ItemProperty -Path $MessageTextPolicyPath -Name "legalnoticetext" -Value $MessageText
Set-ItemProperty -Path $MessageTitlePolicyPath -Name "legalnoticecaption" -Value $MessageTitle

# Remove the policy restricting Windows shortcut keys for all currently signed-in users
try
{
    $status = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    Function RestrictShortcut($sid)
    {
        $policyPath = "HKU:\${sid}\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\"
        $keyname = "Explorer"
        if(Test-Path "$policyPath\$keyName")
        {
            Remove-Item -Path "$policyPath\$keyName" -Recurse -Force
        }
    }
    $userDetails=Get-wmiobject win32_useraccount | where-object{$_.status -eq 'ok'}
    $loggedInUserCount = 0
    foreach($user in $userDetails)
    {
        $sid=$user.SID
        $username = $user.Name
        if(Test-Path "HKU:\${sid}")
        {
            Write-Host $username,"is signed-in to the device."
            Write-Host "Enabling Windows Shortcut for :",$username
            RestrictShortcut($sid)
            $loggedInUserCount++
        } 
    }
    if($loggedInUserCount -eq 0)
    {
        Write-Host "Policy hasn't applied to any user, this policy can only be applied when the user is logged in to the device"
    }
    else
    {
        Write-Host "Restart the device to review the changes."
    }
}
catch
{
    Write-Host "Error occurred while running script -> ",$_.Exception.Message
}

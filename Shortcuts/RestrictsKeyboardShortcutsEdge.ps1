# Restrict specific keyboard shortcuts in Microsoft Edge for all currently signed-in users
try
{
    $status = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    Function RestrictShortcut($sid)
    {
        $policyPath = "HKU:\${sid}\SOFTWARE\Policies\Microsoft\Edge"
        $valueName = "ConfigureKeyboardShortcuts"
        $valueData = '{"disabled": ["open_file", "save_page", "new_inprivate_window", "duplicate_tab", "dev_tools", "web_capture", "collections","profile", "print", "focus_search", "home", "settings_and_more_menu"]}'
        # Check if the "Edge" key exists
        if (!(Test-Path $policyPath))
        {
            # Create the "Edge" key
            New-Item -Path $policyPath -Force | Out-Null
        }
        New-ItemProperty -Path $policyPath -Name $valueName -Value $valueData -PropertyType String -Force | Out-Null        
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
            Write-Host "Restricting Edge Shortcut for :",$username
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
        Write-Host "Restart the Edge to review the changes."
    }
}
catch
{
    Write-Host "Error occurred while running script -> ",$_.Exception.Message
}

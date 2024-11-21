# We require the SID of a user to apply the screen saver for that userprofile. $userSID and $filePath needs to be specified. In case no arguments are passed for $userSID then it will by default apply the screensaver to all the users.
$userSID = $args[0] 
$filePath = "C:\Windows\system32\scrnsave.scr" 
  
Write-Host "--------------starting script execution--------------" 
try{ 
    $status = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS 
    Function Set-Screensaver($sid) 
    { 
        if(Test-Path "HKU:\${sid}") 
        { 
            Write-Host "Changing screensaver for user with sid:",$sid 
            Set-ItemProperty -Path "HKU:\${sid}\Control Panel\Desktop" -Name ScreenSaveActive -Value 1 
            Set-ItemProperty -Path "HKU:\${sid}\Control Panel\Desktop" -Name ScreenSaveTimeOut -Value 60 
            Set-ItemProperty -Path "HKU:\${sid}\Control Panel\Desktop" -Name scrnsave.exe -Value $filePath 
        } 
    } 
    if(!$userSID){ 
    $userDetails=Get-wmiobject win32_useraccount | where-object{$_.status -eq 'ok'} 
    foreach($user in $userDetails){ 
        $sid=$user.SID 
        Set-Screensaver($sid) 
    } 
    } 
    else{ 
    Set-Screensaver($userSID) 
    } 
} 
catch 
{ 
    Write-Host "Error occured while running script -> ",$_.Exception.Message 
} 
Write-Host "--------------script execution completed successfully--------------"

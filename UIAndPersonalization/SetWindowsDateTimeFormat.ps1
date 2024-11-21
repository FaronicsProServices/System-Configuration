# This script updates the date format for all active users by modifying the 'sShortDate' registry value for each user's profile
$dateFormat = 'dddd/MMMM/d/yyyy' 
Write-Host "Starting script execution..." 
try{ 
    $status = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS 
    Function Set-DateFormat($sid) 
    { 
        if(Test-Path "HKU:\${sid}") 
        { 
            Write-Host "updating date format for user:",$sid 
            Set-ItemProperty -path "HKU:\${sid}\Control Panel\International\" -name 'sShortDate' -value $dateFormat 
        } 

    } 
    $userDetails=Get-wmiobject win32_useraccount | where-object{$_.status -eq 'ok'} 
    foreach($user in $userDetails){ 
        $sid=$user.SID 
        Set-DateFormat($sid) 
    } 
} 
catch 
{ 
    Write-Host "Error occured while running script -> ",$_.Exception.Message 
} 
Write-Host "Script execution completed successfully!"  

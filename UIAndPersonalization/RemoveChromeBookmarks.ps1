# This script checks if the ManagedBookmarks registry key exists and deletes it if present, restoring default bookmarks in Google Chrome.
$registryPath = 'HKLM:\Software\Policies\Google\Chrome' 
  
# Check if ManagedBookmarks key exists and has data 
$managedBookmarksKey = Get-ItemProperty -Path $registryPath -Name ManagedBookmarks -ErrorAction SilentlyContinue 
  
if ($managedBookmarksKey -ne $null -and $managedBookmarksKey.ManagedBookmarks -ne $null) { 
    # Delete ManagedBookmarks key 
    Remove-ItemProperty -Path $registryPath -Name ManagedBookmarks -Force | Out-Null 
  
    # Display success message 
    Write-Host "ManagedBookmarks registry key deleted and bookmarks restored to default." 
} 
else { 
    # Display nothing to delete message 
    Write-Host " There are currently no bookmarks present that can be deleted." 
}

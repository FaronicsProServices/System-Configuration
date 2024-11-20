#Enable bookmark bar and add bookmarks in chrome 
  
$registryPath = 'HKLM:\Software\Policies\Google\Chrome' 
$enableBookmarkBar  = 1 #set as 0 to disable it. 
  
  
if(-not(Test-Path $registryPath))  
    { 
        New-Item -Path $registryPath -Force | Out-Null  
    } 
#setting BookmarkBarEnabled registry name 
Set-ItemProperty -Path $registryPath -Name BookmarkBarEnabled -Value $enableBookmarkBar -Force | Out-Null 
Write-Host "Chrome policy key created and bookmark bar enabled." 
  
#add required bookmarks 
$bookmarkJson = '[ 
    { 
     "toplevel_name": "My managed bookmarks folder" 
    }, 
    { 
     "name": "Google", 
     "url": "google.com" 
    }, 
    { 
     "name": "Youtube", 
     "url": "youtube.com" 
    }, 
    { 
     "children": [ 
      { 
       "name": "Chromium", 
       "url": "chromium.org" 
      }, 
      { 
       "name": "Chromium Developers", 
       "url": "dev.chromium.org" 
      } 
     ], 
     "name": "Chrome links" 
    } 
   ]' 
Set-ItemProperty -Path $registryPath -Name ManagedBookmarks -Value $bookmarkJson -Force | Out-Null 
Write-Host "ManagedBookmarks registry key created and bookmarks added."

# Apply-Specific-Wallpaper

This repository contains PowerShell scripts for deploying a specific desktop wallpaper across different Windows environments including:

- Microsoft Entra ID (Azure AD) joined devices
- Active Directory Domain Services (AD DS) joined devices
- Local Workgroup-based systems

## 📂 Folder: `UIAndPersonalization/Apply-Specific-Wallpaper`

### 1. `Deploy-Wallpaper-CurrentUser.ps1`

This script is designed to apply a specific wallpaper to the **currently logged-in interactive user**. It supports:

- ✅ Entra ID (Azure AD) users
- ✅ Active Directory Domain Services users
- ✅ Workgroup/local users

**How it works:**
- Automatically detects the currently active user session
- Downloads the wallpaper to the user's Pictures folder
- Updates the user’s registry hive to set the wallpaper
- Triggers a refresh using a scheduled task in the user's session

**No user input is required.** The script is fully automated and works seamlessly with deployment tools like PDQ Deploy and Deep Freeze Cloud.

---

### 2. `SpecificWallpaper-SpecificUser.ps1`

This script applies a specific wallpaper for a **user you specify manually** inside the script.

**How it works:**
- Requires you to set the `$specifiedUser` variable in the script (e.g., `"DOMAIN\john.doe"` or `"localuser"`)
- Retrieves the user's SID
- Sets the wallpaper path in their registry hive

**Note:** This script does **not** detect or apply changes for the currently logged-in user unless specified explicitly.

---

## 📝 Notes

- Wallpapers must be hosted over HTTPS (e.g., via GitHub raw URL)
- After running the script, users may need to **log out and log back in** to see the changes
- Tested on Windows 10 and Windows 11 (Enterprise, Education, and Pro editions)

---

## 📁 Example Folder Structure


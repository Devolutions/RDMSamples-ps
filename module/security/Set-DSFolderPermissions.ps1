<#
.SYNOPSIS
This script override the permissions of a given folder.

.DESCRIPTION
This script override the permissions of a given folder.

.PARAMETER FolderID
N/A

.EXAMPLE
Set-DSFolderPermissions -FolderID $entryID -Permission "Add" -Role "Custom" -Operation "Append" -Items $Items

.NOTES
N/A
#>

<#
Function: Get-DSInheritedPermissions

Description: Get the permissions from a parent folder if the permissions are set to Inherited, Allowed or Disallowed.

Parameter: 
    FolderID: ID of the folder.
#>
function Get-DSInheritedPermissions ()
{
    param (
        [string]$FolderID
    )

    $resultEntry = Get-DSFolder -FolderID $FolderID

    if ($resultEntry.Security -and $resultEntry.security.roleOverride -ne 3 -and $resultEntry.security.roleOverride -ne 4 -and $resultEntry.security.roleOverride -ne $null)
    {
        $result = $resultEntry
    } else {
        If (-NOT $resultEntry.group) {
            $folderID = (Get-DSFolders -vaultID $resultEntry.RepositoryID -IncludeSubFolders | Where-Object { $_.connectionType -eq 92 }).ID
            $result = Get-DSFolder -FolderID $vaultId
        } Else {
            $group = $resultEntry.group
            $folderName = $group.Replace($resultEntry.Name, "")
            if ($folderName -match '\\$') {
                $folderName = $folderName.Substring(0, $folderName.Length - 1)
            }

            if ([string]::IsNullOrEmpty($resultEntry.RepositoryID)) {
                $vaultID = "00000000-0000-0000-0000-000000000000"
            }
            else {
                $vaultID = "$resultEntry.RepositoryID"
            }
        
            if ([string]::IsNullOrEmpty($folderName)) {
                $folderID = (Get-DSFolders -vaultID $vaultID -IncludeSubFolders | Where-Object { $_.group -eq "" }).ID
                $result = Get-DSFolder -FolderID $folderID
            } else {
                $folderID = (Get-DSFolders -vaultID $vaultID -IncludeSubFolders | Where-Object { $_.group -eq $folderName }).ID
                $result = Get-DSInheritedPermissions $folderID
            }
        }
        
                
    }

    return $result
}

<#
Function: Add-DSSecurityProperty

Description: Add the security property to a folder object with permissions set to Inherited.

Parameter: 
    FolderID: ID of the folder.
#>
function Add-DSSecurityProperty ()
{
    param (
        [string]$FolderID
    )

    $folder = Get-DSFolder -FolderId $FolderID

    $security = (Get-DSInheritedPermissions -FolderID $folder.ID).security

    $folder | Add-Member -Name security -Value $security -MemberType NoteProperty

    # Fix the folder path to avoid virtual folders
    $group = $folder.group.Replace($folder.name, "")
    if ($group[$group.Length - 1] -eq "\")
    {
        $group = $group.SubString(0, $group.Length - 1)
    }
    $folder.group = $group

    Update-DSEntryBase -JsonBody (ConvertTo-Json -InputObject $folder -Depth 10)
}

<#
Function: Edit-DSSecurityProperty

Description: When a folder permissions are set to Allowed or Disallowed, replace the security property with its parent permissions folder.

Parameter: 
    FolderID: ID of the folder.
#>
function Edit-DSSecurityProperty ()
{
    param (
        [string]$FolderID
    )

    $folder = Get-DSFolder -FolderId $FolderID

    $security = (Get-DSInheritedPermissions -FolderID $folder.ID).security
    $folder.security = $security

    # Fix the folder path to avoid virtual folders
    $group = $folder.group.Replace($folder.name, "")
    if ($group[$group.Length - 1] -eq "\")
    {
        $group = $group.SubString(0, $group.Length - 1)
    }
    $folder.group = $group

    Update-DSEntryBase -JsonBody (ConvertTo-Json -InputObject $folder -Depth 10)
}

<#
Function: Set-DSFolderPermissions

Description: Set the permissions on a folder with the given users and/or uer groups.

Parameter: 
    FolderID: ID of the folder.
    Permission: Permission to update.
    Role: Role to set on the permission between Inherited, Custom, Allowed or Disallowed.
    Operation: Append or replace the current permissions.
    Items: Users and/or user groups we want to add/replace on permissions.
#>
function Set-DSFolderPermissions ()
{
    param (
        [Parameter(Mandatory)]
        [string]$FolderID,
        [Parameter(Mandatory)]
        [ValidateSet('View','Add','Edit','Move','Delete','ViewPassword','ViewSensitive','Connect','EditSecurity','ConnectionHistory','PasswordHistory','Remotetools','Inventory','Attachment','EditAttachment','Handbook','EditHandbook','EditInformation')]
        [string]$Permission,
        [Parameter(Mandatory)]
        [ValidateSet('Inherited','Custom','Allowed', 'Disallowed')]
        [string]$Role,
        [Parameter(Mandatory)]
        [ValidateSet('Append','Replace')]
        [string]$Operation,
        $Items
    )

    $resultEntry = Get-DSEntry -EntryID $FolderID 
    if (![bool]($resultEntry.PSobject.Properties.name -match "Security"))
    {
        Add-DSSecurityProperty $resultEntry.ID
    }
    elseif ($resultEntry.security.roleOverride -eq 3 -or $resultEntry.security.roleOverride -eq 4 -or $resultEntry.security.roleOverride -eq $null -or $resultEntry.security.permissions -eq $null)
    {
        Edit-DSSecurityProperty $resultEntry.ID
    }

    $ItemsID = @()

    # Permissions to update
    switch ($Permission)
    {
        "View" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::View; Break}
        "Add" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Add; Break}
        "Edit" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Edit; Break}
        "Move" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Move; Break}
        "Delete" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Delete; Break}
        "ViewPassword" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::ViewPassword; Break}
        "ViewSensitive" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::ViewSensitive; Break}
        "EditSecurity" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::EditSecurity; Break}
        "ConnectionHistory" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::ConnectionHistory; Break}
        "PasswordHistory" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::PasswordHistory; Break}
        "Remotetools" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Remotetools; Break}
        "Inventory" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Inventory; Break}
        "Attachment" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Attachment; Break}
        "EditAttachment" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::EditAttachment; Break}
        "Handbook" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::Handbook; Break}
        "EditHandbook" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::EditHandbook; Break}
        "EditInformation" {$Right = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleRight]::EditInformation; Break}
    }

    # Retrieve back the entry properties if it has been update from above Add or Edit security properties functions
    $Folder = Get-DSEntry -EntryID $FolderID

    # Right to update
    switch ($Role)
    {
        "Custom" 
        {
            if ($Folder.security.permissions -eq $null)
            {
                $perms = New-Object RemoteDesktopManager.PowerShellModule.Private.models.ConnectionPermission
                $perms.Right = $Right
                $perms.Override = 'Custom'
                
                foreach($Item in $Items)
                {
                    $user = Get-DSUser -All | where {$_.Name -eq $Item}
                    if ($user)
                    {
                        $ItemsID += $user.ID
                    }
                    
                    $usergroup = Get-DSRole -All | where {$_.Name -eq $Item}
                    If ($usergroup)
                    {
                        $ItemsID += $usergroup.ID
                    }
                }

                $perms.roles += $ItemsID

                Set-DSEntityPermission -EntityID $FolderID -Permissions $perms
                $Folder = Get-DSEntry -EntryID $FolderID
            }
            else 
            {
                $perms = New-Object RemoteDesktopManager.PowerShellModule.Private.models.ConnectionPermission
                $perms.Right = $Right
                $perms.Override = 'Custom'
                foreach($permissions in $Folder.security.permissions)
                {
                    if ($permissions.Right -eq $Right)
                    {
                        foreach($Item in $Items)
                        {
                            $user = Get-DSUser -All | where {$_.Name -eq $Item}
                            if ($user)
                            {
                                $ItemsID += $user.ID
                            }
                            
                            $usergroup = Get-DSRole -All | where {$_.Name -eq $Item}
                            If ($usergroup)
                            {
                                $ItemsID += $usergroup.ID
                            }
                        }
                        switch ($Operation)
                        {
                            "Append" {$perms.roles += $ItemsID; Break}
                            "Replace" {$perms.roles = $ItemsID; Break}
                        }

                        Set-DSEntityPermission -EntityID $FolderID -Permissions $perms
                        $Folder = Get-DSEntry -EntryID $FolderID
                        Break
                    }
                    Break
                }
            }
        }
        "Inherited"
        {
            $Folder.security.roleOverride  = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleOverride]::Inherited
            Break
        }
        "Never" 
        {
            $Folder.security.roleOverride  = [RemoteDesktopManager.PowerShellModule.Private.enums.SecurityRoleOverride]::Never
            Break
        }
    }

    $group = $Folder.group.Replace($Folder.name, "")
    if ($group[$group.Length - 1] -eq "\")
    {
        $group = $group.SubString(0, $group.Length - 1)
    }
    $Folder.group = $group

    Update-DSEntryBase -JsonBody (ConvertTo-Json -InputObject $Folder -Depth 10)
}
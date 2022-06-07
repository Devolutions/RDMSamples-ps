##########
#
# Object : Export folders' permissions of all vaults
#
# Parameters   :
# $dsName      : Name of the RDM data source.
# $fileName    : Name and full path of the exported CSV file.
# $logFileName : Name and full path of the log file. To be used with the -Verbose switch for maximum log information.
#
# CSV file headers
# Vault             : Name of the Vault
# Folder            : Folder full path (no leading or trailing "\")
# RoleOverride      : Default, Everyone, Never or Custom
# ViewRoles         : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Add               : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Edit              : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Delete            : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# ViewPassword      : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Execute           : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# EditSecurity      : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# ConnectionHistory : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# PasswordHistory   : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Remotetools       : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Inventory         : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Attachment        : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# EditAttachment    : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# Handbook          : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# EditHandbook      : Default, Everyone, Never or list of Roles and/or Users separated with ";"
# EditInformation   : Default, Everyone, Never or list of Roles and/or Users separated with ";"

param (
    [Parameter(Mandatory=$True,Position=1)]
    [string]$dsName,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$fileName,
    [Parameter(Mandatory=$false,Position=3)]
    [string]$logFileName
    )

#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# CSV file creation
Set-Content -Path $filename -Value '"Vault","Folder","RoleOverride","ViewRoles","Add","Edit","Delete","ViewPassword","Execute","EditSecurity","ConnectionHistory","PasswordHistory","Remotetools","Inventory","Attachment","EditAttachment","Handbook","EditHandbook","EditInformation"'
# $createCSV = {} | Select "Vault","Folder","RoleOverride","ViewRoles","Add","Edit","Delete","ViewPassword","Execute","EditSecurity","ConnectionHistory","PasswordHistory","Remotetools","Inventory","Attachment","EditAttachment","Handbook","EditHandbook","EditInformation" | Export-Csv $fileName
# $csvFile = Import-Csv $fileName

# Set the data source
$ds = Get-RDMDataSource -Name $dsName
Set-RDMCurrentDataSource $ds

if (-not [string]::IsNullOrEmpty($logFileName))
{
    Start-Transcript -Path $logFileName -Force
}

$vaults = Get-RDMRepository

foreach ($vault in $vaults)
{
    # Set the default vault
    # $vault = Get-RDMRepository -Name $vault
    Set-RDMCurrentRepository $vault
    $vaultName = $vault.Name
    Write-Verbose "Vault $vaultName selected..."
    
    $folders = Get-RDMSession | where {$_.ConnectionType -eq "Group"}

    foreach ($folder in $folders)
    {
        $csvFile = [PSCustomObject]@{
            Vault = $vaultName
            Folder = $folder.Group
            RoleOverride = $folder.Security.RoleOverride
            ViewRoles = ""
            Add = ""
            Edit = ""
            Delete = ""
            ViewPassword = ""
            Execute = ""
            EditSecurity = ""
            ConnectionHistory = ""
            PasswordHistory = ""
            RemoteTools = ""
            Inventory = ""
            Attachment = ""
            EditAttachment = ""
            Handbook = ""
            EditHandbook = ""
            EditInformation = ""
        }
        
        # $csvFile.Vault = $vaultName
        # $csvFile.Folder = $folder.Group
        # $csvFile.RoleOverride = $folder.Security.RoleOverride
        if ($csvFile.RoleOverride -eq "Custom")
        {
            if ($folder.Security.ViewOverride -in "Everyone", "Default", "Never")
            {
                $csvFile.ViewRoles = $folder.Security.ViewOverride
            }
            else 
            {
                $csvFile.ViewRoles = $folder.Security.ViewRoles
            }

            $folderPermissions = $folder.Security.Permissions
            foreach ($folderPermission in $folderPermissions)
            {
                $permission = $folderPermission.Right
                $permroles = $folderPermission.RoleValues
                $permroles = $permroles -replace [Regex]::Escape(","), "; "
                $csvFile."$permission" = $permroles
            }
        }
        
        $csvFile | Export-Csv $fileName -Append
        Write-Verbose "Permissions exported for folder $folder..."
    }

    Write-Verbose "Permissions exported for vault $vault..."
}

Write-Host "Done!!!"

if (-not [string]::IsNullOrEmpty($logFileName))
{
    Stop-Transcript
}

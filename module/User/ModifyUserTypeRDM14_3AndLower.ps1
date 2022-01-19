#The following script will modify the User type property from Read only to User.
#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$users = Get-RDMUser
foreach ($user in $users)
{
    if (!($user.CanAdd -and $user.CanEdit -and $user.CanDelete))
    {
        $user.CanAdd = $true
        $user.CanEdit = $true
        $user.CanDelete = $true
        $user.CustomSecurity = $user.CustomSecurity.Replace('<CanMove>false</CanMove>', "")
        $user.CustomSecurity = $user.CustomSecurity.Replace('<DenyAddInRoot>true</DenyAddInRoot>', "")
        Set-RDMUser $user
        $username = $user.Name
        Write-Host "$username updated!"
    }
}
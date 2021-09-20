#The following script will modify the User type property from Read only to User.

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
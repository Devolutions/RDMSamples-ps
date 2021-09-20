###########################################################################
#
# This script will modify all the vault permissions to the listed ones
#
###########################################################################

$RDMroot = Get-RDMRootSession

$setPermissions = @{
	"Add" = "Default"
	"Edit" = "Default"
	"Delete" = "Default"
	"Execute" = "Default"
	"EditSecurity" = "Default"
	"ViewPassword" = "Everyone"
	"PasswordHistory" = "Everyone"
	"ConnectionHistory" = "Everyone"
}


$properties = @()
foreach ($perm in $setPermissions.GetEnumerator()) {
    $properties += New-Object PSObject –Property @{
        Override="$($perm.Value)";
        Right="$($perm.Name)";
        Roles=@("");
        RoleValues="";
    }
}

$RDMroot.Security.RoleOverride = "Custom"
$RDMroot.Security.Permissions = $properties
$RDMroot | Set-RDMRootSession

Update-RDMUI
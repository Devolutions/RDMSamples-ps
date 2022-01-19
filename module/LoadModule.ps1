###########################################################################
#
# This script will load the module from the default installation path
#
###########################################################################
#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

<# 
    The Get-RDMInstance is useful to confirm not only which instance you are connected to in the case where you run
    multiple RDM's side by side, but it also returns the path of the configuration file that is loaded. This is useful 
    if you are running in a virtualized environment, or if you have overriden the default path.
#>
Get-RDMInstance
<# 
    The Get-RDMCurrentDataSource returns the currently selected datasource. This may vary depending on the use having
    specified a "default" datasource, having the last used datasource selected at startup, and so on.
#>
Get-RDMCurrentDataSource 
<# 
    For advanced datasources, there is an additional level subdividing your information, namely Vaults. 
    If your current datasource does not support Vaults, you will simply see a warming message
#>
Get-RDMCurrentVault

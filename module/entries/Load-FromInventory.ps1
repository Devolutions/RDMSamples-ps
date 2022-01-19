#source: https://forum.devolutions.net/topics/31577/powershell-remote-sessions-in-rdm

#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$Sessions = Get-RDMSession | where {$_.ConnectionType -eq "RDPConfigured"}
foreach ($Session in $Sessions)
{
  Invoke-RDMLoadFromInventorySession $session 
  Set-RDMSession $session -Refresh
}
Update-RDMUI
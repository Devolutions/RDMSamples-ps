#source: https://forum.devolutions.net/topics/33523/programmatically-setting-userspecific-settings

#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$pv = Get-RDMPrivateSession -Name MyCreds
$sess = Get-RDMSession -Name MyRDPSession
$newuss = New-Object Devolutions.RemoteDesktopManager.Business.BaseConnectionOverride
$newuss.OverrideCredential = $true
$newuss.CredentialConnectionID = '245A4245-48E7-4DF5-9C4C-11861D8E1F81'
$newuss.PersonalCredentialConnectionID = $pv.ID
Set-RDMUserSpecificSettings -Session $sess -UserSpecificSettings $newuss
Update-RDMUI
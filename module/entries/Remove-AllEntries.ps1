#source: https://forum.devolutions.net/topics/34622/deleting-entries-from-vaults

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

#loop into all vaults and delete all entries

$vaults = Get-RDMVault
foreach ($vault in $vaults){
    Set-RDMCurrentRepository $vault
    Update-RDMUI
    $session = Get-RDMSession
	Foreach ($s in $session)
	{
		$s.Group = ''
	}
	Set-RDMSession -Session $session
	Update-RDMUI
	Get-RDMSession | Remove-RDMSession -Force
	Update-RDMUI
    }

Update-RDMUI
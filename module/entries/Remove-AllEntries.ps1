#source: https://forum.devolutions.net/topics/34622/deleting-entries-from-vaults


#load the RDM module
if ( ! (Get-module RemoteDesktopManager.PowerShellModule )) {
    Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1"
}

# ** The name of the data source needs to be modified **
Get-RDMDataSource -Name "name_of_datasource" | Set-RDMCurrentDataSource
Update-RDMUI

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
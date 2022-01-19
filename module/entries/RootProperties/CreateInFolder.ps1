###########################################################################
#
# This script will create an entry in the specified folder
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$computerName = "windjammer10";
$folderName = "PowerShell Samples";
$folder = New-RDMSession -Type "Group" -Name $folderName
$folder.Group = $folderName
Set-RDMSession -Session $folder -Refresh;
$session = New-RDMSession -Host $computerName -Type "RDPConfigured" -Name $computerName;
$session.Group = $folderName
Set-RDMSession -Session $session -Refresh;
Update-RDMUI;

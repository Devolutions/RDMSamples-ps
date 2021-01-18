###########################################################################
#
# This script will create an entry in the specified folder
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
$computerName = "windjammer10";
$folderName = "PowerShell Samples";
$folder = New-RDMSession -Type "Group" -Name $folderName
$folder.Group = $folderName
Set-RDMSession -Session $folder -Refresh;
$session = New-RDMSession -Host $computerName -Type "RDPConfigured" -Name $computerName;
$session.Group = $folderName
Set-RDMSession -Session $session -Refresh;
Update-RDMUI;

###########################################################################
#
# This script will create an entry with an Alternate Shell
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
$computerName = "MyPSMServer.domain.com";
$session = New-RDMSession -Host $computerName -Type "RDPConfigured" -Name $computerName;
$session.AlternateShell = "PSM /u PrivilegedAccountName /a destination.domain.com /c PSM-RDP"
Set-RDMSession -Session $session -Refresh;
Update-RDMUI;

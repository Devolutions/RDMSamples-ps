###########################################################################
#
# This script will create an entry with an Alternate Shell
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$computerName = "MyPSMServer.domain.com";
$session = New-RDMSession -Host $computerName -Type "RDPConfigured" -Name $computerName;
$session.AlternateShell = "PSM /u PrivilegedAccountName /a destination.domain.com /c PSM-RDP"
Set-RDMSession -Session $session -Refresh;
Update-RDMUI;

###########################################################################
#
# This script will create an entry with minimal data
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

$computerName = "windjammer10";
$theusername = "david";
$thedomain = "windjammer";
$thepassword = "<<strong password>>";
$session = New-RDMSession -Host $computerName -Type "RDPConfigured" -Name $computerName;
Set-RDMSession -Session $session -Refresh;
<# 
    The Update-RMUI call is to allow the entry to be physically saved and available 
    for the rest of the script. It may not be necessary for a types of data sources 
    and our objective is to make it unnecessary for this scenario.
#>
Update-RDMUI;
Set-RDMSessionUsername -ID $session.ID $theusername;
Set-RDMSessionDomain -ID $session.ID $thedomain;
$pass = ConvertTo-SecureString $thepassword -asplaintext -force;
Set-RDMSessionPassword -ID $session.ID -Password $pass;

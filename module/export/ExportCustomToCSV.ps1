###########################################################################
#
# This script will export your CURRENT VAULT to a CSV file while 
# customizing the properties that are exported. 
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

$sessions = Get-RDMSession;
$CSVFileName = $PSScriptRoot + '\LimitedExport.csv'
Write-Output "writing to $CSVFileName"
# simply add to the -property filter to have more fields in your output
# note that passwords require more work and are covered in another sample
$sessions | Select-Object -property Name, Group, ConnectionType | export-csv $CSVFileName -notypeinformation

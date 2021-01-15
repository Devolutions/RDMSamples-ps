###########################################################################
#
# This script will export your CURRENT VAULT to a CSV file while 
# customizing the properties that are exported. 
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
$sessions = Get-RDMSession;
$CSVFileName = $PSScriptRoot + '\LimitedExport.csv'
Write-Output "writing to $CSVFileName"
# simply add to the -property filter to have more fields in your output
# note that passwords require more work and are covered in another sample
$sessions | Select-Object -property Name, Group, ConnectionType | export-csv $CSVFileName -notypeinformation

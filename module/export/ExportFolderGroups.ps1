#source: https://forum.devolutions.net/topics/35643/export-certain-foldersgroups

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$sessions = Get-RDMSession | where {$_.ConnectionType -eq "Group" -and $_.Group.Split('\').Length -le 2} 
$CSVFileName = $PSScriptRoot + '\LimitedExport.csv'
Write-Output "writing to $CSVFileName"
# simply add to the -property filter to have more fields in your output
# note that passwords require more work and are covered in another sample

$sessions | Select-Object -property Name, Group | export-csv $CSVFileName -notypeinformation
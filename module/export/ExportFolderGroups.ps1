#source: https://forum.devolutions.net/topics/35643/export-certain-foldersgroups

Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1"

#get datasource and set it as current datasource to use as default
$datasource = Get-RDMDataSource #-Name CloudSolutions
Set-RDMCurrentDataSource $datasource[0].ID
$sessions = Get-RDMSession | where {$_.ConnectionType -eq "Group" -and $_.Group.Split('\').Length -le 2} 
$CSVFileName = $PSScriptRoot + '\LimitedExport.csv'
Write-Output "writing to $CSVFileName"
# simply add to the -property filter to have more fields in your output
# note that passwords require more work and are covered in another sample

$sessions | Select-Object -property Name, Group | export-csv $CSVFileName -notypeinformation
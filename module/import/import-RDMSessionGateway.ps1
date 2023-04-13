#source: https://forum.devolutions.net/topics/34839/creer-session-rdm-dans-un-datasource-rdms

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$csv = Import-CSV C:\Script\rdm.csv
foreach ($list in $csv) {
$name=$list.name
$ip=$list.ip
$os=$list.OS
$Datacenter=$list.Datacenter
foreach($datacentergroup in $datacenter) { $datacentergroup = "DataCenter\$datacenter" }
$Partners=$list.Partners

if ($os -eq "Windows")
    {New-RDMSession -Name $list.Name -Group $datacentergroup -Type RDPConfigured -host $list.ip -SetSession
    Write-Host 'Import $list.Name to RDM in progress'
    Update-RDMUI
    $rdmsgw = Get-RDMSession -Name $list.name
    $rdmsgw.VPN.ExistingGatewayID = 'd6e28338-dc7a-4f2a-adb8-9f1bbb0e0253'
    Set-RDMSession $rdmsgw
    Update-RMUI
    }

if ($os -eq "Linux")
    {New-RDMSession -Name $list.Name -Group $datacentergroup -Type SSHShell -host $list.ip -SetSession}

Write-Host New Session $name added
}
Write-Host All the session was imported.
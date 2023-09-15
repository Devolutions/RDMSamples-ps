#source: https://forum.devolutions.net/topics/33500/searching-over-all-vaults-and-generate-a-report

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

# Set a Parameter for the limit date and csv File name
$Expiration = get-date -Year 2021 -Month 4 -Day 7
$FileName = 'c:\temp\ExpirationReport.csv'

# Processing
$Vaults = Get-RDMRepository
Foreach ($v in $Vaults){
    Set-RDMCurrentRepository -Repository $v;
    Update-RDMUI;
    $Sessions = Get-RDMSession | ? {($_.MetaInformation.Warranty -is [datetime]) -and ($_.MetaInformation.Warranty -lt $Expiration)};
    ForEach ($s in $Sessions){
        $csvRecord = [PSCustomObject]@{
            'Vault' = $v.Name
            'EntryName' = $s.Name
            'OS' = $s.MetaInformation.OS
            'Comment' = $s.Description
            'WarrantyExpiration' = $s.MetaInformation.Warranty
        } #CustomObject
        Export-Csv -InputObject $csvRecord -Append -Path $FileName;
    } #Sessions

} #vaults

#source: https://forum.devolutions.net/topics/33500/searching-over-all-vaults-and-generate-a-report

# depending from where you run it, you might need to import the powershell module
Import-Module "C:\Program Files (x86)\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1;"
#If you have multiple data source configured on your RDM installation ;
Set-RDMCurrentDataSource -DataSource (Get-RDMDataSource -Name '<DataSource Name>');
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
#source: https://forum.devolutions.net/topics/33589/how-to-set-properties-on-data-source-using-powershell

if (-not (Get-Module RemoteDesktopManager.PowerShellModule)) {
    Import-Module 'C:\Program Files (x86)\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1'
}

$ds = New-RDMDataSource -SQLServer -Server YourSQLServer -Database YourSQLDatabase -Name YourDataSourceName -IntegratedSecurity
Set-RDMDatasourceProperty -DataSource $ds -Property AutoGoOffline -Value $true
Set-RDMDatasourceProperty -DataSource $ds -Property AllowOfflineMode -Value $true
Set-RDMDatasourceProperty -DataSource $ds -Property AllowOfflineEdit -Value $true
Set-RDMDataSource $ds
#source https://forum.devolutions.net/topics/34248/cant-get-powershell-module-to-work-stable
Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1"

if ($(Get-RDMCurrentDataSource).Name -ne $rdm_datasource_name)
{
    if ($rdm_datasource_name -in $((Get-RDMDataSource).name)) # datasource present but not currently selected
    {
        $ds = Get-RDMDataSource -Name $rdm_datasource_name
        Set-RDMCurrentDataSource $ds[0]
        Update-RDMUI
    }
    else # rdm datasource doesn't exist yet
    {
        # connect to correct datasource
        New-RDMDataSource -Database $rdm_db_name -Name $rdm_datasource_name -Server $rdm_db_server -IntegratedSecurity -SQLServer -SetDatasource
        
        # remove all the other datasources
        Get-RDMDataSource | Where-Object -FilterScript {$_.Name -ne $rdm_datasource_name} | Remove-RDMDataSource

        # rebuild cache
        Update-RDMUI
    }
}
else
{
    # rebuild cache
    Update-RDMUI
}
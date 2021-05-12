[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $Vault,
    [Parameter()]
    [String]
    $DataSource
)

    #Verify if the RDM PS module is loaded, if not, import it
    if ( ! (Get-module RemoteDesktopManager.PowerShellModule )) {
        Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1" 
    }
    
    #set the current data source, if needed
    if (![string]::IsNullorEmpty($DataSource)) {
        Set-RDMCurrentDataSource "$Datasource"
    }
    #set the current repository/vault, if needed
    if ("" -ne $Vault) {
        Set-RDMCurrentRepository -Repository  $vault
    }
    Update-RDMUI
    #retrieve the session, using the ID
    $RDMsession = Get-RDMSession | Where-Object {$_.id -eq $Session}
    #
    #
    #
    #save the session back in the Data Source
    Set-RDMSession -Session $RDMsession
    }
    catch {
        Write-Output $Error[0]
    }


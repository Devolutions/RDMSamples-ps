#source: https://forum.devolutions.net/topics/31577/powershell-remote-sessions-in-rdm

#Verify if the RDM PS module is loaded, if not, import it
if ( ! (Get-module RemoteDesktopManager.PowerShellModule )) {
    Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1" 
}

$Sessions = Get-RDMSession | where {$_.ConnectionType -eq "RDPConfigured"}
foreach ($Session in $Sessions)
{
  Invoke-RDMLoadFromInventorySession $session 
  Set-RDMSession $session -Refresh
}
Update-RDMUI
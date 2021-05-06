Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1"

# Getting a list of Entries that have SubConnections
$parents = Get-RDMSession | where SubConnections


foreach ($parent in $parents)
{
      <# Getting the SubConnections where ConnectionType in this case is Sftp
         This can be tweaked to fit any need. #>
      $subcons = $parent.SubConnections | where ConnectionType -eq "Sftp"
      $child = $subcons
      
      <#Runs the UnParent
      **PS: There will be a Confirmation prompt for each entry being un-parented #> 
      Invoke-RDMUnparentSession -Session $subcons
      
      # Changes the Connection type to FTP but again can be tweaked to change anything
      $child.ConnectionType = "Ftp"
      # Saves changes made above
      Set-RDMSession $child -Refresh
      # In this case we wanted to re-parent the entry
      Invoke-RDMParentSession -Session $child -ParentSession $parent  
}
Update-RDMUI

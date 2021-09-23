#source: https://forum.devolutions.net/topics/30416/powershell--create-new-entry

if (-not (Get-Module RemoteDesktopManager.PowerShellModule)) {
    Import-Module 'C:\Program Files (x86)\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1'
}


$ps = New-RDMSession -Name $entryName -Type Credential -Group $group.Group
$ps.Credentials.CredentialType = "PasswordList"
$psArray = @()
$psEntry = New-Object "RemoteDesktopManager.PowerShellModule.PsOutputObject.PSPasswordListItem"
$psEntry.User = $username
$psEntry.Password = $passwd
$psEntry.Domain = $domain
$psEntry.Description = $description
$psArray += $psEntry
$ps.Credentials.PasswordList = $psArray

Set-RDMSession $ps -Refresh
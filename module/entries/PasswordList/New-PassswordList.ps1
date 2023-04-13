#source: https://forum.devolutions.net/topics/30416/powershell--create-new-entry

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds


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
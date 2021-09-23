#source: https://forum.devolutions.net/topics/35604/import-script--create-a-credential-then-a-folder-object-from-a-templat

Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1" 
$creds =New-RDMSession -Name "VMware server root" -Type Credential -Group "Acme Inc\Credentials\Vendors" 
$creds.Credentials.UserName="root" 
Set-RDMSession $creds -refresh
Set-RDMSessionPassword -ID $creds.ID -Password (ConvertTo-SecureString "monkey123" -AsPlainText -Force) -refresh
$grouptemp = New-RDMSession -Name "VMwareHost5" -Type TemplateGroup -TemplateID "95d5739b-2fd9-4c7b-a1e0-3152774cff98" -Group "Acme Inc\Client assets" 
Set-RDMSession $grouptemp -refresh
$groupobj = Get-RDMSession | where {$_.name -eq "VMwareHost5"}
$groupobj.CredentialConnectionID = $creds.ID 
$groupobj.GroupDetails.Host ="VMwareHost5"
$groupobj.GroupDetails.IP ="192.168.1.33"
$groupobj.Description = "in datacenter 5; rack 21; row 15/Dell ST: ABC123456"
Set-RDMSession $groupobj –Refresh
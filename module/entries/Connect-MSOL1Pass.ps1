#source: https://forum.devolutions.net/topics/35567/powershell-session--login-to-365-services-without-the-need-to-fill-in-
#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$session = Get-RDMSession -Name 1password
$user = Get-RDMSessionUsername -Session $session
$pass = Get-RDMSessionPassword -Session $session 
$LiveCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Pass
Import-Module MSOnline
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -COnnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking
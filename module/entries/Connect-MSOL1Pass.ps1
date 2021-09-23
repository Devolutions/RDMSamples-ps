#source: https://forum.devolutions.net/topics/35567/powershell-session--login-to-365-services-without-the-need-to-fill-in-


$session = Get-RDMSession -Name 1password
$user = Get-RDMSessionUsername -Session $session
$pass = Get-RDMSessionPassword -Session $session 
$LiveCred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Pass
Import-Module MSOnline
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -COnnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking
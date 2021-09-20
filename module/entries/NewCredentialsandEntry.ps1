###########################################################################
#
# This script will create a credential entry and an RDP entry using that newly generated credential.
#
###########################################################################
#create credential
$creds =New-RDMSession -Name "creds" -Type Credential -Group "Credentials"
$creds.Credentials.UserName="administrator"
Set-RDMSession $creds -Refresh
Set-RDMSessionPassword -ID $creds.ID -Password (ConvertTo-SecureString "test123$" -AsPlainText -Force)

#create rdp using the credential from above
$rdp = New-RDMSession -Name "$computername" -Type RDPConfigured -Group "Machines"
$rdp.Host = "192.168.1.1" #IP of machine
$rdp.CredentialConnectionID = $creds.ID

#saves the machine
Set-RDMSession $rdp –Refresh
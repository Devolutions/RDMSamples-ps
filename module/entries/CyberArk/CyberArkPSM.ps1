###########################################################################
#
# Creates a pair of CyberArk PSM Server & CyberArk PSM Connection entries
#
# Note that the CyberArk PSM Server entry relies on the existance of
# a Shared Template (database) of the RDP Type.
# 
###########################################################################
#-------------------------------[Initialization]------------------------------
<# 
an RDP Template can be created by this simple command

$template = New-RDMTemplate -Name 'RDP Template' -Type 'RDPConfigured' -Destination 'Database' -SetTemplate

if you have a pre-existing template you can fetch it with

$template = Get-RDMTemplate -Type shared | where-object {$_.Name -eq "PSM-Full"}
#>
#-----------------------------------[Main]-------------------------------------
<# 
  Part 1 - creating the CyberArk PSM Server entry

  notes:
  
  1.    The $template variable must have been initialized by either a create or fetch statement
  2.    Typical customers have a single PSM Server entry that either points to a single server, or 
        a single address representing a server farm in a HA/LB topology
#>
$sessServer = New-RDMSession -Type "CyberArkJump" -Name "PSMServer1"
<# 
    the Component List should be taken from the PSM Definition itself
    Please refer to the PAS REST API for http://<IIS_Server_Ip>/PasswordVault/API/PSM/Connectors
#>
$sessServer.CyberArkPSM.ComponentList = @('PSM-RDP','PSM-SSH') 
$sessServer.CyberArkPSM.CyberArkServer = 'psm1.domain.loc'
$sessServer.CyberArkPSM.TemplateID = $template.ID
$sessServer.CyberArkPSM.UseMyAccountSettings = $true
Set-RDMSession $sessServer
Update-RDMUI

<# 
  Part 2 - creating the CyberArk PSM Connection entry

  You need one entry per combination of endpoints/privileged account that you want to use
#>
$sessConnection = New-RDMSession -Type "CyberArkPSM" -Name "PSMConnection1"
# the Component MUST be ONE of the ones defined in the PSM Server entry
$sessConnection.CyberArkPSM.Component = "PSM-RDP"
# the Host is the FQDN of the endpoint that you intend to reach via the PSM
$sessConnection.CyberArkPSM.Host = "endpoint.dom.loc"
<# 
    the Privileged Account is the "label" with which to locate the account across all of the
    safes that the user has access to.

    This field is the single most reason for support sessions with this integration as it 
    mostly depends on how your CyberArk instance is operated by the Vault admins.

    We have seen the following across our community:

    upn : "user@domain.loc"
    samAccountname : "user"
    upn less top level domain (!) : "user@domain"
#>
$sessConnection.CyberArkPSM.PrivilegedAccount = "account-identifier"
# the CyberArkJumpConnectionID was created above
$sessConnection.CyberArkPSM.CyberArkJumpConnectionID = $sessServer.ID
Set-RDMSession $sessConnection
Update-RDMUI

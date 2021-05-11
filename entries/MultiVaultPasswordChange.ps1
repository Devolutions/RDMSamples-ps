#requires -version 4
<#
.SYNOPSIS
  Change password on an individual Credential entry shared between all Vaults

.DESCRIPTION
  Option to change all Credential entries password sharing the same name across all Vaults
  
  SN: This is not a secure option we recommend having a separate Vault with shared credentials 

.PARAMETER <Parameter_Name>
  None

.INPUTS
  Confirmation will be required for EACH Un-Parent

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Eric St-Martin
  Creation Date:  05/05/2021
  Purpose/Change: Initial script development
.EXAMPLE

#>

#-------------------------------[Initialisations]------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins
Import-Module RemoteDesktopManager.PowerShellModule

#---------------------------------[Functions]----------------------------------


#---------------------------------[Execution]----------------------------------

$repos = Get-RDMRepository

# Prompts for new password as secured text
$newPass = Read-Host "Enter new password" -AsSecureString

foreach ($r in $repos)
{
    Set-RDMCurrentRepository $r
    
    # Please note ChangeME must be change to the name you would like 
    $creds = Get-RDMSession | where {$_.Name -EQ "ChangeME" -and $_.ConnectionType -eq "Credential"}
    
    Set-RDMSessionPassword $creds.ID -Password $newPass

    Write-Host $r.Name"\"$creds.Name"password has been successfully change."
}
Update-RDMUI

Write-Host "Changes completed!"

#----------------------------------[Closure]-----------------------------------
# If running in the console only, ask to press a key
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.FlushInputBuffer()  
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}

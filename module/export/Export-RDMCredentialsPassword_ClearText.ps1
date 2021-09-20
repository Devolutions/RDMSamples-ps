#####################################################################
#                                                                   #
# WARNING, THE RESULTING FILE WILL CONTAIN PASSWORDS IN CLEAR TEXT  #
#                                                                   #
#####################################################################

<##################
Description  : This script exports the sessions, including the passwords in clear text, from a data source to a CSV file.
Prerequisite :  - Remote Desktop Manager must be installed on the computer.
Version      : 1.1
Date         : 2021-09-07
###################>

#Verify if the RDM PS module is loaded, if not, import it
if ( ! (Get-module RemoteDesktopManager.PowerShellModule )) {
    Import-Module "${env:ProgramFiles(x86)}\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1" 
}

#Location of the CSV file you want to export the RDM sessions to
$exportFileName = "c:\Backup\RDMCredentialsData_$(get-date -f yyyy-MM-dd).csv"

#Refreshes the connection to prevent errors further on
Update-RDMUI

#Retrieve all the vault and loop in them
$vaults = Get-RDMVault
foreach ($vault in $vaults){
    #Change the current vault to proceed with the export
    Set-RDMCurrentRepository $vault
    Update-RDMUI
    #Get all the sessions in the current vault
    $RDMsessions = Get-RDMSession | Where-Object {$_.ConnectionType -ne "Group"}  | Select-Object -Property Name, ID, ConnectionType, Group, Host, HostUserName

    #Iterate in every session
    foreach ($session in $RDMsessions){
        #Add the password field as clear text to the session
        $session | Add-Member -MemberType NoteProperty "Password" -Value (get-RDMSessionPassword -ID $session.id -AsPlainText)
        #Export the session to a CSV file to the path configured earlier. 
        $session | Export-Csv -Path $exportFileName -Append -NoTypeInformation
    }
}


Import-Module RemoteDesktopManager

#source: https://forum.devolutions.net/topics/8476/inventory-report-and-populating-information-tab
if (-not (Get-Module RemoteDesktopManager.PowerShellModule)) {
    Import-Module 'C:\Program Files (x86)\Devolutions\Remote Desktop Manager\RemoteDesktopManager.PowerShellModule.psd1'
}
# Set your DS (Data Source), mine is on our SQL server
# You can find your data source under in your RDM under File/Data Sources
$DS = Get-RDMDataSource -Name MySQLServerName



# Next, I get all of the sessions under my group name.
# This grabs everything, including folders, etc.
$Sessions = Get-RDMSession -GroupName "Michael" -IncludeSubFolders



# Next, for testing, I wanted to update the IP Address on a single server 
# in the RDM.
ForEach ($Session in $Sessions)

{
    # So, if the Host name matched the server I was looking for then I would run my script.
    # For me, if I wanted to run through all my servers I would change the IF line to:
    #     If($Session.ConnectionType -eq "RDPConfigured")
    # You can get as creative as you'd like.

    If($Session.Host -eq "NameOfServerToUpdate")
    {

        # I just wanted to see it found the correct host.
        $Session.Host
        $IPv4Address = (Get-ADComputer -Identity $Session.Host -Properties IPv4Address).IPv4Address
        # And here I just wanted to what IPAddress was found.
        $IPv4Address
        Set-RDMSessionProperty -ID $Session.ID -Path "MetaInformation" -Property "IP" -Value $IPv4Address
        # Do not forget to do a refresh on your RDM console to see the updated information.
    }
}
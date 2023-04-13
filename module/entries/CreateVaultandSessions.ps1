#source: https://forum.devolutions.net/topics/33844/create-vaults-and-sessions

#check if RDM PS module is installed
if(-not (Get-Module Devolutions.PowerShell -ListAvailable)){
    Install-Module Devolutions.PowerShell -Scope CurrentUser
}

function CreateVaultsandSessions
{
    Param(
      # Overall total number of entries
      [Parameter(Mandatory=$True,Position=1)]
      [int]$maxSession,

      # Starting number for the vault name
      [Parameter(Mandatory=$True,Position=2)]
      [int]$startVaultNb,

      # Number of sessions per vault
      [Parameter(Mandatory=$True,Position=3)]
      [int]$nbSessPerVault
      )

    # Update the data source name here
    $ds = Get-RDMDataSource -Name 'YourDataSourceNameHere'
    Set-RDMCurrentDataSource $ds
    Update-RDMUI

    $vault = $nbSessPerVault
    $vaultSuf = $startVaultNb
    $vaultName = "vault$vaultSuf"
    for ($noSession = 1; $noSession -le $maxSession; $noSession++) {
        if ($vault -eq $nbSessPerVault) {
            $vaultName = "vault$vaultSuf"
            $vault = New-RDMRepository -Name $vaultName -Description "Vault $vaultName" -SetRepository
            Write-Host "Vault $vaultName created" -f Yellow
            Set-RDMCurrentRepository -Repository $vault
		    Update-RDMUI
            $vault = 0
            $vaultSuf++
        }

	    $name = "Session" + $noSession
        $session = New-RDMSession -Type "RDPConfigured" -Name $name
	    $session.Host = "Host$noSession"
        Set-RDMSession -Session $session -Refresh

	    $passwd = ConvertTo-SecureString "Host$noSession" -AsPlainText -Force
	    Set-RDMSessionPassword -Session $session -Password $passwd
	    Set-RDMSessionUsername -Session $session -Username "Host$noSession"
        Set-RDMSession $session

        Write-Host "Session Session$noSession created" -f Green
        $vault++
    }

    Update-RDMUI
}


$maxSessions = 100
$startVaultNb = 1
$nbSessionsPerVault = 25

CreateVaultsandSessions $maxSessions $startVaultNb $nbSessionsPerVault
#source: https://forum.devolutions.net/topics/34565/is-it-possible-to-changeset-the-credentials-setting-on-the-vault-using

$vault = Get-RDMVault -Name "VaultName"
Set-RDMCurrentRepository $vault
Update-RDMUI
$root = Get-RDMRootSession
$root.CredentialConnectionID = "88E4BE76-4C5B-4694-AA9C-D53B7E0FE0DC"
Set-RDMRootSession $root -Refresh
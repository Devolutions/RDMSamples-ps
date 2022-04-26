#source https://forum.devolutions.net/topics/34184/importing-metainfomation-from-csv-file
#check if RDM PS module is installed
if(-not (Get-Module RemoteDesktopManager -ListAvailable)){
	Install-Module RemoteDesktopManager -Scope CurrentUser
}

# Adapt the data source name
$ds = Get-RDMDataSource -Name "NameOfYourDataSourceHere"
Set-RDMCurrentDataSource $ds

$lineno = 0

Get-Content "C:\temp\RDMImportTest.csv" | ForEach-Object {
	$lineno = $lineno + 1

	$fields = $_.split(",")  
	$DeviceName = $fields[0] -replace "^""", "" -replace """$", ""   
	$Status = $fields[1] -replace "^""", "" -replace """$", ""
	$Title = $fields[2] -replace "^""", "" -replace """$", ""
	$Audience = $fields[3] -replace "^""", "" -replace """$", ""
	$Subnet = $fields[4] -replace "^""", "" -replace """$", ""
	$IP = $fields[5] -replace "^""", "" -replace """$", ""
	$Description = $fields[6] -replace "^""", "" -replace """$", ""
	$VMHost = $fields[7] -replace "^""", "" -replace """$", ""
	$POC = $fields[8] -replace "^""", "" -replace """$", ""
	$Priority = $fields[9] -replace "^""", "" -replace """$", ""
	$Category = $fields[10] -replace "^""", "" -replace """$", ""
	$Domain = $fields[11] -replace "^""", "" -replace """$", ""
	$WindowsMachine = $fields[12] -replace "^""", "" -replace """$", ""
	$OS = $fields[13] -replace "^""", "" -replace """$", ""
	$BackupType = $fields[14] -replace "^""", "" -replace """$", ""
	$Location = $fields[15] -replace "^""", "" -replace """$", ""

	Write-Output "Inserting RDM Entries from input line $lineno : $DeviceName"

	$ServerEntry = New-RDMSession -Name $DeviceName -Type "RDPConfigured"
	Set-RDMSession $ServerEntry 
	Update-RDMUI
	$SessionEntry.MetaInformation.MachineName = "$DeviceName" 
	$SessionEntry.MetaInformation.Version = "$Status" 
	$SessionEntry.MetaInformation.AssetTag = "$Title" 
	$SessionEntry.MetaInformation.CustomField1Value = "$Audience" 
	$SessionEntry.MetaInformation.Rack = "$VMHost" 
	$SessionEntry.MetaInformation.FirstName = "$POC" 
	$SessionEntry.MetaInformation.CustomField3Value = "$Priority" 
	$SessionEntry.MetaInformation.CustomField2Value = "$Category" 
	$SessionEntry.MetaInformation.Domain = "$Domain" 
	$SessionEntry.MetaInformation.CustomField4Value = "$BackupType" 
	$SessionEntry.MetaInformation.Site = "$Location"
	$SessionEntry.Description = "$Description" 
	Set-RDMSession $ServerEntry
}
Update-RDMUI
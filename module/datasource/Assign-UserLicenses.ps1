###########################################################################
#
# This script will Assign a given License (Through the serial) to a given user (Username) 
#
###########################################################################

function Set-LicenseSerialToUser(
    # Parameter help description
    [String]
    $Serial,
    [String]
    $UserName    
)
{
# Getuser
$User = Get-RDMUser -Name $UserName

# fetch license from serial
$License = Get-RDMLicense -Serial $Serial

# get the assignation
$userlicense = $License.Users | Where-Object{$_.UserID -eq $User.ID}
$userlicense.IsMember = $True

# save changes
Set-RDMLicense -License $License
}
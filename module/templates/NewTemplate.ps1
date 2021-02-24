###########################################################################
#
# This script will create a shared template in the CURRENT DATASOURCE 
#
###########################################################################
#-----------------------------------[Main]-------------------------------------
$template = New-RDMTemplate -Name 'RDP Template' -Type 'RDPConfigured' -Destination 'Database' -SetTemplate
$template
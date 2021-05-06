 
 #Sample Custom Batch Action edit
 
 #Name will be change to quoted text
 
  $connection.Name = "Super PC";
  $connection.HostDetails.Host = "000.000.0.0";
  $connection.MetaInformation.Site = "USA, Chicago";
  $connection.Terminal.UseSftpForFileTransfer = "true";
  $RDM.Save();
  
<# More info on Batch_actions: https://help.remotedesktopmanager.com/pscustomactions.html


To retrieve the exact name of the field, right-click on your session and select Clipboard – Copy. 
You can then paste the information in a text editor to retrieve the name of the field(s) that you would like to
modify via the Custom PowerShell Command.

Sample fields:
  <Connection>
    
	<ConnectionType>Host</ConnectionType>
    <Name>PC</Name>
    <OpenEmbedded>true</OpenEmbedded>
    
	<HostDetails>
      <Host>localhost</Host>
    </HostDetails>
	
    <MetaInformation>
      
	  <Architecture>32-bit</Architecture>
      <BladeDetails>AT</BladeDetails>
      <Domain>Windjammer</Domain>
      <IP>000.000.0.0</IP>
      <IsVirtualMachine>true</IsVirtualMachine>
      <MachineName>localhost</MachineName>
      <OS>Windows 10</OS>
      <PurchaseDate>2021-05-02T14:04:49.924944-04:00</PurchaseDate>
      <SerialNumber>123456</SerialNumber>
      <ServiceTag>Support</ServiceTag>
      <Site>Montreal</Site>
      <SupportServiceLevel>2</SupportServiceLevel>
      <Vendor>Microsoft</Vendor>
      <VirtualMachineName>Windows Server 2019</VirtualMachineName>
      <VirtualMachineType>VMware</VirtualMachineType>
      <Warranty>2021-05-07T14:04:49.924944-04:00</Warranty>
      
   </MetaInformation>
	
  </Connection>
 #>

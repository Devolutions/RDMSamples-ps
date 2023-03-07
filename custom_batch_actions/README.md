# Remote Desktop Manager - Edit (Special Action)
Remote Desktop Manager (RDM) samples of PowerShell snippets that can be used in RDM's "Edit -> Edit (special actions) -> Custom PowerShell command"

## Sample Custom Powershell Script action edit
```powershell
$connection.Name = "Super PC";
$connection.HostDetails.Host = "127.4.67.100";
$connection.MetaInformation.Site = "USA, Chicago";
$connection.Terminal.UseSftpForFileTransfer = $true;
$RDM.Save();
```




## How to get the information

To retrieve the exact name of the field, right-click on your session and select Clipboard > Copy. Switch over to the Preview tab, or you can paste the information in a text editor to retrieve the name of the field(s) that you would like to modify via the Custom PowerShell Command.

> ***Note:** Your session will need to have the fields you are trying to find configured with fake/real information before doing the above step. IE: If you want to get the Host field, the host field will need to have text before doing the right-click Clipboard > Copy*

> **Reference**: [Custom PowerShell Script][1]

## How to get started

So you have your information needing to be changed, what do you do now...

*  Firstly, the beginning of each piece of information being changed needs to start with **$connection**. For example: 
```powershell
$connection.Name = "Super PC";
```
*  Secondly, most of the information is grouped to make this easier to read/find. Some of the information will have a subgroup to the Connection group. As an example, below we have **< Connection >**. This is the main group and is why we start with **$connection**, now the subgroup here is **< HostDetails >** which has the **< Host >**, so if you wanted to change the **"Host"** you would need to do the following statement: **$connection.HostDetails.Host = "127.4.67.100";** 
```xml
<Connection>
  
  <ConnectionType>Host</ConnectionType>
  <Name>PC</Name>
  <OpenEmbedded>true</OpenEmbedded>
  
  <HostDetails>
    <Host>localhost</Host>
  </HostDetails>
  
</Connection>
```
> ***Note**: There are many different subgroups within RDM, to name a few simpler ones: **HostDetails**, **Terminal**, **MetaInformation**.*

* Thirdly, for data types that need to be change. We have different data types in RDM, ***Strings, Dropdowns and Bools*** to name a few. If you wanted to change a checkbox ( *bool* ) you would need to use ***$true or $false***. If you want to change a drop down you would need to use single quotes ''. If its a textbox you would be looking at changing a string which need to be in double quotes "". For example:  

```powershell
# Bool type
$connection.Terminal.UseSftpForFileTransfer = $true;

# Dropdowns types
$connection.VPN.Mode = 'Inherited';

# String type
$connection.Name = "Super PC";
```


*  Finally, it is very important that you always end with the following code to confirm the changes are saved: 
```powershell
$RDM.Save();
```

> [Some more examples][2]


  [1]: https://helprdm.devolutions.net/pscustomactions.html
  [2]: https://helprdm.devolutions.net/powershell_batchactionssamples.html

# The Triad of Username / Domain / Password
## Introduction
The credentials are stored, in a secure fashion everywhere, but with a lot of variance depending ot the entry type and a few other factors.
## Concepts
Entries can use credentials in multiple ways.  
* Default : stored directly in the entry
* inherited : uses the one specified on its container
* Link : link to a credential entry stored in the same vault
* My personal credentials : uses what is stored in File - My Account Settings
* none : formally sets that no credentials are defined (as opposed to being blank)
* Find By name (user vault) : does a textual search in the user vault.
## Samples
### Default (stored in entry)
#### Writing the credential triad
```powershell
$connection.SetCredentials('banderson', 'Passw0rd!', 'corpo.loc')
$RDM.Save()
```
#### Setting the password to one that is generated 
```powershell
$connection.SetPassword([System.Web.Security.Membership]::GeneratePassword(20, 4));
$RDM.Save();
```
Notes
You can find the full information of the GeneratePassword method at <a href="https://docs.microsoft.com/en-us/dotnet/api/system.web.security.membership.generatepassword?view=netframework-4.8" target="_blank">system.web.security.membership.generatepassword</a>

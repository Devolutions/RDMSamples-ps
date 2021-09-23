#source https://forum.devolutions.net/topics/34575/powershell-problem-with-creating-a-password-list-as-a-subconnection

$subsessions = $session.SubConnections

    $passwordListSystem = $subsessions | Where-Object{$_.Name -match "_Credentials"}



    if($passwordListSystem.Length -ne 0){

        Update-RDMUI

        Remove-RDMSession $passwordListSystem[0].ID -Force

        Update-RDMUI



        $session = Get-RDMSession | Where-Object {$_.ID -eq $session.ID}

    }



    $PWListNeeded = $true

    if($PWListNeeded){

        $passwordList = New-RDMSession -Type "Credential" -Name "_Credentials"

        Set-RDMSession $passwordList 

        $passwordList.Credentials.CredentialType = "PasswordList"

        Set-RDMSession $passwordList 

        Update-RDMUI

        Invoke-RDMParentSession -ParentSession $session -Session $passwordList

        Update-RDMUI



        $session = Get-RDMSession | Where-Object {$_.ID -eq $session.ID}

    }
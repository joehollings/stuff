$Domain = "domain.local"
$username = "owscs\joe.hollings.adm"
$adminpassword = "" | ConvertTo-SecureString -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $adminpassword)
Add-Computer -DomainName $Domain -Credential $psCred
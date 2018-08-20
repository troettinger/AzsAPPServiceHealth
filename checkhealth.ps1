#Import Module for WebApps
import-module .\webapps.psm1 -Force

#Set Parameter
$secpasswd = ConvertTo-SecureString "emailaccountpassword" -AsPlainText -Force
$emailcredential = New-Object System.Management.Automation.PSCredential ("emailaccountusername", $secpasswd)
$armendpoint = "https://adminmanagement.local.azurestack.external"
$armpasswd = ConvertTo-SecureString "MyServiceAdminPassword" -AsPlainText -Force
$armcredential = New-Object System.Management.Automation.PSCredential ("serviceadmin@mydirectory.onmicrosoft.com", $armpasswd)
$location ="local"
$From = "EmailAddressSender"
$To = "EmailAddressReceipt"
$Subject = "WebApps Alert $location"
$SMTPServer = "mailserver"
$SMTPPort = "587"


#Query Status
$Servers=Get-AzsWebAppStatus -location $location -armendpoint $armendpoint -armcredentials $armcredential
Foreach ($server in $servers){
$servername = $server.name
If ($Server.Status-ne "Ready"){


#Send Alert Email
$Body =  "An Error was detected with your WebApp RP installation on $location. Please check the Server $servername the Azure Stack Admin Portal"
Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Credential $emailcredential -UseSsl

}}





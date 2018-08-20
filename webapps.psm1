function Get-AzsWebAppStatus {
    [CmdletBinding(DefaultParameterSetName = 'GetAzsWebbAppStatus')]

    Param(    
        

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String] $location,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [String] $armendpoint,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential] $Armcredentials
        
    )

    $azureEnvironment=Add-AzureRmEnvironment -Name "AzureStackWebAppAdmin" -ARMEndpoint $armendpoint

    $azureAccount = Add-AzureRmAccount -Environment "AzureStackWebAppAdmin" -Credential $Armcredentials 

    $AzureSubscription = Get-AzureRmSubscription |where-object {$_.Name -eq "Default Provider Subscription"}
    $AzureSubscriptionID = $AzureSubscription.ID

     # Retrieve the access token
     $tokens = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.TokenCache.ReadItems()
     $token = $tokens |Where Resource -EQ $azureEnvironment.ActiveDirectoryServiceEndpointResourceId |Where DisplayableId -EQ $azureAccount.Context.Account.Id |Sort ExpiresOn |Select -Last 1

     $uri1 = "$($azureEnvironment.ResourceManagerUrl.ToString().TrimEnd('/'))/subscriptions/$($AzureSubscriptionID.ToString())/resourceGroups/AppService.$location/providers/Microsoft.Web.Admin/locations/$location/servers?api-version=2016-08-01"
     $Headers = @{ 'authorization' = "Bearer $($Token.AccessToken)"} 
     $Servers = (Invoke-RestMethod -Method GET -Uri $uri1 -Headers $Headers)
     $Serversprop=$servers.properties
     $Serversprop
}
     Export-ModuleMember -Function Get-AzsWebAppStatus
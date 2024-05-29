# A client ID needs to be configured for each customer. See here for for more info: https://developer-docs.citrix.com/en-us/citrix-cloud/citrix-cloud-api-overview/get-started-with-citrix-cloud-apis.html#:~:text=Create%20an%20API%20client%201%20In%20the%20Citrix,have%20been%20created%20successfully%20.%20...%20More%20items
param (
    [Parameter(Mandatory=$true)]
    [string] $ccId,
    [Parameter(Mandatory=$true)]
    [string] $clientId
)

# Authenticate to Azure.
Connect-AzAccount -Identity

# Get ClientSecret from key vault
$clientSecret = Get-AzKeyVaultSecret -VaultName "kv-owscs-hub" -Name "$clientId" -AsPlainText

# Get Bearer token
$tokenUrl = 'https://api-eu.cloud.com/cctrustoauth2/root/tokens/clients'
$response = Invoke-WebRequest $tokenUrl -Method POST -Body @{
grant_type = "client_credentials"
client_id = $clientId
client_secret = $clientSecret}

$token =  (ConvertFrom-Json $response.Content)
$bearerToken = $token.access_token

# Get Site ID
$requestUri = "https://api.cloud.com/cvad/manage/me"
$headers = @{
    "Accept" = "application/json";
    "Authorization" = "CWSAuth Bearer=$bearerToken";
    "Citrix-CustomerId" = $ccId;
}

$response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $headers 
$siteId = $response.Customers.sites.id

# Get Catalog ID
$requestUri = "https://api.cloud.com/cvad/manage/MachineCatalogs"
$headers = @{
    "Accept" = "application/json";
    "Authorization" = "CWSAuth Bearer=$bearerToken";
    "Citrix-CustomerId" = $ccId;
    "Citrix-InstanceId" = $siteid;
}

$response = Invoke-RestMethod -Uri $requestUri -Method GET -Headers $headers
$catalogIds = $response.Items.id

foreach ($catalog in $catalogIds) {
    # Get master image ID
    $body = @{
        "async" = "false"
    }
    $headers = @{
        "accept" = "*/*"
        "Citrix-CustomerId" = $ccId
        "Citrix-InstanceId" = $siteId
        "Citrix-Locale" = "en-US"
        "Authorization" = "CwsAuth bearer=$bearerToken"
    }
    $response = Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$catalog/LastMasterImage" `
        -Body $body `
        -Headers $headers `
        -UserAgent "Mozilla/5.0"
    $XDPath = $response.Image.XDPath
    
    # Update Machine Catalog
    $requestUri = [string]::Format("https://api.cloud.com/cvad/manage/MachineCatalogs/$catalog/`$UpdateProvisioningScheme?async=true")
    $headers = @{"Accept"="application/json";
                "Content-Type"="application/json"
                "Authorization"="CwsAuth bearer=$bearerToken"
                "Citrix-CustomerID"=$ccId
                "Citrix-InstanceID"=$siteId}
    $body = @{
    MasterImagePath = $XDPath;
    StoreOldImage = "true";}

    $jsonBody = (ConvertTo-Json $body)
    $response = Invoke-RestMethod -Uri $requestUri -Method POST -Headers $headers -Body $jsonBody
}
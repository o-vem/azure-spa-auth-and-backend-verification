[CmdletBinding()]
param(    
    [PSCredential] $Credential,
    [Parameter(Mandatory=$False, HelpMessage='Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
    [string] $tenantId,
    [Parameter(Mandatory=$False, HelpMessage='Azure environment to use while running the script (it defaults to AzureCloud)')]
    [string] $azureEnvironmentName
)

#Requires -Modules AzureAD -RunAsAdministrator


if ($null -eq (Get-Module -ListAvailable -Name "AzureAD")) { 
    Install-Module "AzureAD" -Scope CurrentUser                                            
} 
Import-Module AzureAD
$ErrorActionPreference = "Stop"

Function Cleanup
{
    if (!$azureEnvironmentName)
    {
        $azureEnvironmentName = "AzureCloud"
    }

    <#
    .Description
    This function removes the Azure AD applications for the sample. These applications were created by the Configure.ps1 script
    #>

    # $tenantId is the Active Directory Tenant. This is a GUID which represents the "Directory ID" of the AzureAD tenant 
    # into which you want to create the apps. Look it up in the Azure portal in the "Properties" of the Azure AD. 

    # Login to Azure PowerShell (interactive if credentials are not already provided:
    # you'll need to sign-in with creds enabling your to create apps in the tenant)
    if (!$Credential -and $TenantId)
    {
        $creds = Connect-AzureAD -TenantId $tenantId -AzureEnvironmentName $azureEnvironmentName
    }
    else
    {
        if (!$TenantId)
        {
            $creds = Connect-AzureAD -Credential $Credential -AzureEnvironmentName $azureEnvironmentName
        }
        else
        {
            $creds = Connect-AzureAD -TenantId $tenantId -Credential $Credential -AzureEnvironmentName $azureEnvironmentName
        }
    }

    if (!$tenantId)
    {
        $tenantId = $creds.Tenant.Id
    }
    $tenant = Get-AzureADTenantDetail
    $tenantName =  ($tenant.VerifiedDomains | Where-Object { $_._Default -eq $True }).Name
    
    # Removes the applications
    Write-Host "Cleaning-up applications from tenant '$tenantName'"

    Write-Host "Removing 'service' (ms-identity-javascript-tutorial-c4s1-api) if needed"
    try
    {
        Get-AzureADApplication -Filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-api'"  | ForEach-Object {Remove-AzureADApplication -ObjectId $_.ObjectId }
    }
    catch
    {
	    Write-Host "Unable to remove the 'ms-identity-javascript-tutorial-c4s1-api' . Try deleting manually." -ForegroundColor White -BackgroundColor Red
    }
    $apps = Get-AzureADApplication -Filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-api'"
    if ($apps)
    {
        Remove-AzureADApplication -ObjectId $apps.ObjectId
    }

    foreach ($app in $apps) 
    {
        Remove-AzureADApplication -ObjectId $app.ObjectId
        Write-Host "Removed ms-identity-javascript-tutorial-c4s1-api.."
    }
    # also remove service principals of this app
    try
    {
        Get-AzureADServicePrincipal -filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-api'" | ForEach-Object {Remove-AzureADServicePrincipal -ObjectId $_.Id -Confirm:$false}
    }
    catch
    {
	    Write-Host "Unable to remove ServicePrincipal 'ms-identity-javascript-tutorial-c4s1-api' . Try deleting manually from Enterprise applications." -ForegroundColor White -BackgroundColor Red
    }
    Write-Host "Removing 'spa' (ms-identity-javascript-tutorial-c4s1-spa) if needed"
    try
    {
        Get-AzureADApplication -Filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-spa'"  | ForEach-Object {Remove-AzureADApplication -ObjectId $_.ObjectId }
    }
    catch
    {
	    Write-Host "Unable to remove the 'ms-identity-javascript-tutorial-c4s1-spa' . Try deleting manually." -ForegroundColor White -BackgroundColor Red
    }
    $apps = Get-AzureADApplication -Filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-spa'"
    if ($apps)
    {
        Remove-AzureADApplication -ObjectId $apps.ObjectId
    }

    foreach ($app in $apps) 
    {
        Remove-AzureADApplication -ObjectId $app.ObjectId
        Write-Host "Removed ms-identity-javascript-tutorial-c4s1-spa.."
    }
    # also remove service principals of this app
    try
    {
        Get-AzureADServicePrincipal -filter "DisplayName eq 'ms-identity-javascript-tutorial-c4s1-spa'" | ForEach-Object {Remove-AzureADServicePrincipal -ObjectId $_.Id -Confirm:$false}
    }
    catch
    {
	    Write-Host "Unable to remove ServicePrincipal 'ms-identity-javascript-tutorial-c4s1-spa' . Try deleting manually from Enterprise applications." -ForegroundColor White -BackgroundColor Red
    }
}

Cleanup -Credential $Credential -tenantId $TenantId


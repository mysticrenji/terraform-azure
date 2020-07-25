# Terraform with Azure Cloud

<h1>Instructions to install prerequisites for Terraform Azure Providers<h1>

<h3>
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash </br>

Run the below snippet in powershell core

az account list --query [*].[name,id] </br>

$subscriptionId = 'xxxx-xxxxx-xxxxx' </br>

$sp = az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$subscriptionId" -n TerraformTesting | ConvertFrom-Json </br>

$env:ARM_SUBSCRIPTION_ID = $subscriptionId </br>
$env:ARM_CLIENT_ID = $sp.appId </br>
$env:ARM_CLIENT_SECRET = $sp.password </br>
$env:ARM_TENANT_ID = $sp.tenant </br>
</h3>

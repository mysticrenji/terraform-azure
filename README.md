# Terraform with Azure Cloud

<h1>Instructions to install prerequisites for Terraform Azure Providers<h1>

<h3>
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash </br>

// Get the subscription ID registered </br>
az login  </br>
az account list --query [*].[name,id] </br>

az ad sp create-for-rbac \
  --role="Contributor" \
  --scopes="/subscriptions/<$subscriptionid>"

export ARM_CLIENT_ID= </br>
export ARM_SUBSCRIPTION_ID= </br>
export ARM_TENANT_ID=</br>
export ARM_CLIENT_SECRET=</br>
</h3>


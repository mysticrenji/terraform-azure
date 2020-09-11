provider "azurerm" {
  # AzureRM provider 2.x
  version = "~>2.0"
  # v2.x required "features" block
  features {}
}

terraform {
 backend "remote" {
   organization = "mysticrenji"

   workspaces {
     name = "terraform-azureiot"
   }
 }
}

# Create a resource group
resource "azurerm_resource_group" "b59" {
  name     = "b59-iot-rg"
  location = "North Central US"
}

# Create an Azure IoT Hub
resource "azurerm_iothub" "b59iothub" {
    name                = "b59iothub"
    resource_group_name = azurerm_resource_group.b59.name
    location            = azurerm_resource_group.b59.location

    sku {
        name     = "F1"
        capacity = 1
    }
}

# Create an IoT Hub Access Policy
data "azurerm_iothub_shared_access_policy" "b59iothub_iothubowner" {
    name                = "iothubowner"
    resource_group_name = azurerm_resource_group.b59.name
    iothub_name         = azurerm_iothub.b59iothub.name
}

# Create a Device Provisioning Service
resource "azurerm_iothub_dps" "b59dps" {
    name                = "b59dps"
    resource_group_name = azurerm_resource_group.b59.name
    location            = azurerm_resource_group.b59.location

    sku {
        name     = "F1"
        capacity = 1
    }

    linked_hub {
        connection_string = data.azurerm_iothub_shared_access_policy.b59iothub_iothubowner.primary_connection_string
        location = azurerm_iothub.b59iothub.location
    }
}

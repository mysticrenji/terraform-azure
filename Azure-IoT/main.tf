provider "azurerm" {
    version = "~>2.0"
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


resource "azurerm_resource_group" "azureiot" {
  name     = "terraform-azureiot"
  location = "us west"
}

resource "azurerm_iothub" "azureiothub" {
  name                = "Example-IoTHub"
  resource_group_name = azurerm_resource_group.azureiot.name
  location            = azurerm_resource_group.azureiot.location

  sku {
    name     = "F1"
    capacity = "1"
  }

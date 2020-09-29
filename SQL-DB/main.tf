provider "azurerm" {
  version = "=2.13.0"
  features {}
}

# terraform {
#   backend "azurerm" {
#     key = "terraform.tfstate"
#   }
# }

# resource "azurerm_resource_group" "presentation" {
#   name     = "${var.ResourceGroupName}"
#   location = "${var.location}"
#   tags = {
#     environment = "${var.presentation}"
#   }
# }

resource "azurerm_virtual_network" "presentation" {
  name                = "${var.VNETName}"
  resource_group_name = "${var.ResourceGroupName}"
  location            = "${var.location}"
  address_space       = ["10.5.5.0/24"]
}

resource "azurerm_subnet" "presentation" {
  name                 = "subnet1"
  virtual_network_name = "${azurerm_virtual_network.presentation.name}"
  resource_group_name  = "${var.ResourceGroupName}"
  address_prefixes     = ["10.5.5.0/28"]
  service_endpoints    = ["Microsoft.Sql"]

}

resource "azurerm_sql_firewall_rule" "presentation" {
  name                = "AlllowAzureServices"
  resource_group_name = "${var.ResourceGroupName}"
  server_name         = "${azurerm_sql_server.presentation.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_server" "presentation" {
  name                         = "${var.SqlServerName}"
  resource_group_name          = "${var.ResourceGroupName}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${var.SQLServerAdminUser}"
  administrator_login_password = "${var.SQLServerAdminPassword}"
  tags = {
    environment = "${var.presentation}"
  }
}

resource "azurerm_sql_database" "presentation" {
  name                = "${var.SqlDatabaseName}"
  resource_group_name = "${var.ResourceGroupName}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.presentation.name}"
  edition             = "${var.Edition}"
  #requested_service_objective_name = "${var.ServiceObjective}"

  tags = {
    environment = "${var.presentation}"
  }
}

output "fqdn" {
  value = azurerm_sql_server.presentation.fully_qualified_domain_name
}

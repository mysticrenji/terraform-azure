## <https://www.terraform.io/docs/providers/azurerm/index.html>
provider "azurerm" {
    version = "~>2.0"
    features {}
}

terraform {
 backend "remote" {
   organization = "mysticrenji"

   workspaces {
     name = "terraform-azure"
   }
 }
}

resource "null_resource" "terraform-github-actions" {
 triggers = {
   value = "This resource was created using GitHub Actions!"
 }
}

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "Terraform-GitHubActions"
  location = "eastus"

  tags = {
      environment = "Terraform-GitHubActions"
  }
}

resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "Terraform-GitHubActions"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform-GitHubActions"
    }
}

resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform-GitHubActions"
    }
}

resource "azurerm_network_interface" "myterraformnic" {
    name                        = "myNIC"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "Terraform-GitHubActions"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# resource "random_id" "randomId" {
#     keepers = {
#         # Generate a new ID only when a new resource group is defined
#         resource_group = azurerm_resource_group.myterraformgroup.name
#     }
    
#     byte_length = 8
#}

# resource "azurerm_storage_account" "mystorageaccount" {
#     name                        = "diag${random_id.randomId.hex}"
#     resource_group_name         = azurerm_resource_group.myterraformgroup.name
#     location                    = "eastus"
#     account_replication_type    = "LRS"
#     account_tier                = "Standard"

#     tags = {
#         environment = "Terraform-GitHubActions"
#     }
# }

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" { value = "tls_private_key.example_ssh.private_key_pem" }

resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                  = "Standard_B1s"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "Terraform-GitHubActions"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        #public_key     = file("~/.ssh/id_rsa.pub")
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

    #boot_diagnostics {
    #    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    #}

    tags = {
        environment = "Terraform-GitHubActions"
    }
}

output "azurerm_public_ip" { value = "data.azurerm_public_ip.myterraformpublicip.ip_address" }

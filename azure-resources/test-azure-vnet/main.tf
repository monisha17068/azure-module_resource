# Create virtual network
# The resource names in the module get prefixed by module.<module-instance-name> when instantiated
# provider "azurerm" {
#   features {}
#   version=   "=2.46.0" 
#   #1.42.0"
#   subscription_id = "ea3c6933-c647-4fe7-8281-dde36a250653"
  
#   tenant_id       = "35dda2e1-5d95-42f5-8826-497f51dd4dd0"

#   client_id       = "06a97084-15d6-4906-bb8f-f8a041db97a7"
#    client_secret   = "Zoo8Q~7YyRFLBN0ItE8vUWuOfGrFC0sq~xyYQdwu"
# }

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name 
  location = var.location 
}

resource "azurerm_virtual_network" "network" {
    name                = var.name

    address_space       = var.address_space 
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name

    tags = {
        environment = "Terraform Demo"
    }
}

#Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "${var.resource_group_name}-Subnet"
    resource_group_name  = "${var.resource_group_name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefixes     = "10.0.1.0/24"
}


# # Create public IPs
resource "azurerm_public_ip" "my_vm_public_ip" {
    name                         = "${var.resource_group_name}_VMPublicIP"
    location                     = "${var.location}"
    resource_group_name          = azurerm_resource_group.example.name
    allocation_method   = var.allocation_method 
    tags = {
        environment = "Terraform Demo"
    }
}

# # Create network interface
resource "azurerm_network_interface" "network_interface" {
    name                      = var.network_interface_name
    location                  = "${var.location}"
    resource_group_name       = azurerm_resource_group.example.name
    #network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "${var.resource_group_name}NICconfig"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.my_vm_public_ip.id}"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

   

# # Associating Network interface with NSG

resource "azurerm_network_interface_security_group_association" "nsg_interface_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


# # Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.resource_group_name}-NetSG"
    location            = "${var.location}"
    resource_group_name = azurerm_resource_group.example.name

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
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
}

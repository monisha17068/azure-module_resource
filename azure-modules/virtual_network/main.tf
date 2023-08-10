# Create virtual network
# The resource names in the module get prefixed by module.<module-instance-name> when instantiated
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "${var.resource_group_name}virtualNetwork"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "${var.resource_group_name}Subnet"
    resource_group_name  = "${var.resource_group_name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefixes       = ["10.0.1.0/24"]
}


# Create public IPs
resource "azurerm_public_ip" "my_vm_public_ip" {
    name                         = "${var.resource_group_name}VMPublicIP"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    allocation_method   = "Static"
    tags = {
        environment = "Terraform Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "${var.resource_group_name}NIC"
    location                  = "${var.location}"
    resource_group_name       = "${var.resource_group_name}"
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

   

# Associating Network interface with NSG

resource "azurerm_network_interface_security_group_association" "nsg_interface_association" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.resource_group_name}NetSG"
    location            = "${var.location}"
    resource_group_name = "${var.resource_group_name}"

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

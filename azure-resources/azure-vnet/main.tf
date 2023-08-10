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

    #  dynamic "ddos_protection_plan" {
    # for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []

    # content {
    #   enable = ddos_protection_plan.value.enable
    #   id     = ddos_protection_plan.value.id
    # }
     dynamic "ddos_protection_plan" {
    for_each = var.create_ddos_plan == true ? range(1):range(0)
    iterator = v
    content {
      id = azurerm_network_ddos_protection_plan.main_ddos[0].id
      enable = true
    }
  }

  }






# #Create subnet
# resource "azurerm_subnet" "subnets" {
#     for_each = var.subnets
#      name = each.value["name"]
#     #name                 = "${var.resource_group_name}-Subnet"
#     resource_group_name  = "${var.resource_group_name}"
#     virtual_network_name = "${azurerm_virtual_network.network.name}"
#     address_prefixes     =  "${var.address_prefixes}"
# }


resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.network.name
  name                 = each.value["name"]
  address_prefixes     = each.value["address_prefixes"]
}

resource "azurerm_network_ddos_protection_plan" "main_ddos" {
  count = var.create_ddos_plan ? 1:0
  name = "ddos_protection_plan"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
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
# resource "azurerm_network_interface" "network_interface" {
#     name                      = var.network_interface_name
#     location                  = "${var.location}"
#     resource_group_name       = azurerm_resource_group.example.name
#     #network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

#     ip_configuration {
#         name                          = "${var.resource_group_name}NICconfig"
#         subnet_id                     = "${azurerm_subnet.subnets}"
#         private_ip_address_allocation = "dynamic"
#         public_ip_address_id          = "${azurerm_public_ip.my_vm_public_ip.id}"
#     }

#     tags = {
     
#         environment = "Terraform Demo"
#     }
# }

   

# # Associating Network interface with NSG

# resource "azurerm_network_interface_security_group_association" "nsg_interface_association" {
#   network_interface_id      = azurerm_network_interface.network_interface.id
#   network_security_group_id = azurerm_network_security_group.myterraformnsg.id
# }


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
resource "azurerm_firewall" "example" {
  name                = "testfirewall"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  
  ip_configuration {
    name                 = "configuration"
    #subnet_id            =  azurerm_subnet.subnets[each.key].name
    
    # ["${azurerm_subnet.subnets[subnet_1].id}"]
    #  azurerm_subnet.subnets[each.key].id
    public_ip_address_id = azurerm_public_ip.my_vm_public_ip.id
  }
}

output "vnet_id" {
    value = azurerm_virtual_network.network.id
}

output "subnet_id" {
    value = tomap({
        for k, s in azurerm_subnet.subnets : k => s.id



    })
  
}
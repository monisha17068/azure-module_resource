provider "azurerm" {
  features {}
  version=   "=2.46.0" 
  #1.42.0"

  subscription_id = "67c86510-9270-470e-9352-855e37b1ceaf"
  
  
  tenant_id       = "8087a1f2-a282-469d-845f-f1b65e044f69"
  #"8087a1f2-a282-469d-845f-f1b65e044f69"

  client_id       ="db16148c-a73f-4d04-903b-c163c2a87881"
  
  #"db16148c-a73f-4d04-903b-c163c2a87881"
   #"4cf35477-bdf7-4737-bb93-bfd0226b43d1"
   client_secret   ="yfX8Q~WdkpgGjfi98QpROdOAV0xq4PXgVeTNAbUu"

  # subscription_id = "ea3c6933-c647-4fe7-8281-dde36a250653"
  
  # tenant_id       = "35dda2e1-5d95-42f5-8826-497f51dd4dd0"

  # client_id       = "06a97084-15d6-4906-bb8f-f8a041db97a7"
  #  client_secret   = "Zoo8Q~7YyRFLBN0ItE8vUWuOfGrFC0sq~xyYQdwu"
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name 
  location = var.location 
}
resource "azurerm_virtual_network" "network" {
    name                = var.virtual_network_name

    address_space       = var.address_space 
    location            = var.location
    resource_group_name = azurerm_resource_group.example.name
    #vnet_id = var.vnet_id
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name 
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.network.name
   #subnet_id     = var.subnet_id 
   

  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "my_vm_public_ip" {
    name                         = "${var.resource_group_name}_VMPublicIP"
    location                     = "${var.location}"
    resource_group_name          = azurerm_resource_group.example.name
    allocation_method   = var.allocation_method 
    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface" "network_interface" {
    name                      = var.network_interface_name
    location                  = "${var.location}"
    resource_group_name       = azurerm_resource_group.example.name
    #network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "${var.resource_group_name}NICconfig"
        subnet_id                     = "${azurerm_subnet.internal.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.my_vm_public_ip.id}"
    }

}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_availability_set" "DemoAset" {
  name                = "example-aset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_machine" "main" {
  name= var.instance_name
  #name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  vm_size               = var.vm_size 
  #subnet_id     = var.subnet_id 
  
  #admin_username      = var.admin_username 


  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }
  
  
  availability_set_id = azurerm_availability_set.DemoAset.id
#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("/opt/terraform-poc/terraform-resources/azure/azure-vm")
#   }
  #disable_password_authentication = var.disable_password_authentication

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
  
   

  storage_image_reference  {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    #encryption_at_host_enabled = true
  }
  os_profile {
    computer_name  = "test"
    admin_username = var.admin_username 
    admin_password = var.admin_password 

#     admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("/opt/terraform-poc/terraform-resources/azure/azure-vm")
#   }
  }
#    admin_ssh_key {
#     username   = "azureuser"
#     public_key = tls_private_key.example_ssh.public_key_openssh
#   }

  os_profile_linux_config {
    disable_password_authentication = false
    # ssh_keys {
    #   path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    #   key_data = "${file("${var.ssh_key}")}"
    # }
  }

  
  tags = {
    environment = "staging"
  }
  
  boot_diagnostics {
    enabled= false
    storage_uri =""
  }

}

output "vnet_id" {
  value= "${azurerm_virtual_network.network.id}"
}

output "subnet_id" {
  value= "${azurerm_subnet.internal.id}"
}
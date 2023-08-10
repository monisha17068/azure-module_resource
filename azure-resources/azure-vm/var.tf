variable location {
  default="eastus"
}

# variable "prefix" {
#     default="azure"
# }

variable "admin_username" {
  default="testadmin"
}

variable "admin_password"{
  default="Password1234!"
}

variable "address_space" {
  default=["10.0.0.0/16"]
}

variable "subnet_name"{
  default="internal"
}

variable "storage_image_reference" {
  default={
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

variable "storage_os_disk" {
  default={
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

variable "vm_size" {
  default="Standard_DS1_v2"
}

variable "instance_name" {
  default="test"
}

variable "virtual_network_name" {
  default="virtual_network"
}

variable resource_group_name {
  default = "test_resource_group"
  description = "Resource group name"
}

variable "allocation_method" {
  default="Static"
}

variable "network_interface_name" {
  default="azure-network-interface"
}

variable "subnet_id" {  
}

variable "vnet_id" {
}

# variable vnetwork_interface_id {
#   default = ""
#   description = "Virtual network interface ID"
# }

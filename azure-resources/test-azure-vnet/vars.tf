variable location {
  default="eastus"
}

variable "address_space" {
  default=["10.0.0.0/16"]
}

variable "name" {
  default="azure-network"
}
variable resource_group_name {
  default = "azure-res"
  description = "Resource group name"
}

variable "allocation_method" {
  default="Static"
}

variable "network_interface_name" {
  default="azure-interface"
}


# variable vnetwork_interface_id {
#   default = ""
#   description = "Virtual network interface ID"
# }

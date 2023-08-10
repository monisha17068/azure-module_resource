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

variable "ddos_protection_plan" {
  description = "The set of DDoS protection plan configuration"
  type = object({
    enable = bool
    id     = string
  })
  default = null
}

variable "network_interface_name" {
  default="azure-interface"
}


# variable "address_prefixes"{
#   type=list(string)
#   default=["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "subnets" {
#   description = "The virtal networks subnets with their properties."
#   type        = map(string)
#   default={
#     subnet_1= "public"
#     subnet_2="private"
#   }
# }


variable "subnets" {
  type = map(any)
  default = {
    subnet_1 = {
      name             = "subnet_1"
      address_prefixes = ["10.13.1.0/24"]
    }
    subnet_2 = {
      name             = "subnet_2"
      address_prefixes = ["10.13.2.0/24"]
    }
  }
}

variable "create_ddos_plan" {
  description = "If set to true, create DDOS plan for vnet"
  type = bool
}
# variable vnetwork_interface_id {
#   default = ""
#   description = "Virtual network interface ID"
# }

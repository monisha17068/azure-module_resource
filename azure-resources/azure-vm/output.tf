output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

# output "public_ip" {
#   value = azurerm_public_ip.my_vm_public_ip.ip_address
# }
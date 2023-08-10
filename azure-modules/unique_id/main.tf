resource "random_id" "uid" {
  keepers = {
    resource_group = "${var.resource_group_name}"
  }
  byte_length = 2
}

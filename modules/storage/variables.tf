variable "location" { type = string }
variable "workload_resource_group_name" { type = string }
variable "network_resource_group_name" { type = string }
variable "private_endpoint_subnet_id" { type = string }
variable "private_dns_zone_ids" { type = map(string) }
variable "tags" { type = map(string) }
variable "function_storage_public_network_access_enabled" { type = bool }
variable "admin_public_ip_ranges" {
  type    = list(string)
  default = []
}

variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tenant_id" { type = string }
variable "enable_vpn" { type = bool }
variable "vpn_client_address_space" { type = list(string) }
variable "tags" { type = map(string) }

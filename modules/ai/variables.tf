variable "location" { type = string }
variable "openai_location" { type = string }
variable "workload_resource_group_id" { type = string }
variable "workload_resource_group_name" { type = string }
variable "network_resource_group_name" { type = string }
variable "private_endpoint_subnet_id" { type = string }
variable "private_dns_zone_ids" { type = map(string) }
variable "document_storage_account_id" { type = string }
variable "app_identity_principal_id" { type = string }
variable "function_identity_principal_id" { type = string }
variable "chat_model_name" { type = string }
variable "chat_model_version" { type = string }
variable "embedding_model_name" { type = string }
variable "embedding_model_version" { type = string }
variable "embedding_dimensions" {
  type    = number
  default = 3072
}
variable "search_public_network_access_enabled" {
  type    = bool
  default = false
}
variable "openai_public_network_access_enabled" {
  type    = bool
  default = false
}
variable "admin_public_ip_ranges" {
  type    = list(string)
  default = []
}
variable "tags" { type = map(string) }

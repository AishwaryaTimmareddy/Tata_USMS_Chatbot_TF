variable "location" { type = string }
variable "workload_resource_group_name" { type = string }
variable "network_resource_group_name" { type = string }
variable "app_subnet_id" { type = string }
variable "function_subnet_id" { type = string }
variable "private_endpoint_subnet_id" { type = string }
variable "app_gateway_subnet_id" { type = string }
variable "private_dns_zone_ids" { type = map(string) }
variable "app_identity_id" { type = string }
variable "app_identity_client_id" { type = string }
variable "app_identity_principal_id" { type = string }
variable "app_public_network_access_enabled" { type = bool }
variable "admin_public_ip_ranges" {
  type    = list(string)
  default = []
}
variable "function_identity_id" { type = string }
variable "function_identity_client_id" { type = string }
variable "function_identity_principal_id" { type = string }
variable "function_public_network_access_enabled" { type = bool }
variable "function_storage_account_name" { type = string }
variable "function_storage_access_key" {
  type      = string
  sensitive = true
}
variable "document_storage_account_url" { type = string }
variable "document_storage_account_id" { type = string }
variable "document_storage_blob_endpoint" { type = string }
variable "document_storage_queue_endpoint" { type = string }
variable "search_endpoint" { type = string }
variable "openai_endpoint" { type = string }
variable "content_safety_endpoint" { type = string }
variable "cosmos_endpoint" { type = string }
variable "key_vault_uri" { type = string }
variable "application_insights_connection_string" {
  type      = string
  sensitive = true
}
variable "container_image" { type = string }
variable "acr_public_network_access_enabled" { type = bool }
variable "app_gateway_certificate_secret_id" {
  type    = string
  default = null
}
variable "app_gateway_host_name" {
  type    = string
  default = null
}
variable "tags" { type = map(string) }

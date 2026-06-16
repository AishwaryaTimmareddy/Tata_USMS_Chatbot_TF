output "application_gateway_public_ip" {
  value = module.compute.application_gateway_public_ip
}

output "app_service_hostname" {
  value = module.compute.app_service_hostname
}

output "acr_login_server" {
  value = module.compute.acr_login_server
}

output "search_endpoint" {
  value = module.ai.search_endpoint
}

output "openai_endpoint" {
  value = module.ai.openai_endpoint
}

output "cosmos_endpoint" {
  value = module.database.cosmos_endpoint
}

output "key_vault_uri" {
  value = module.security.key_vault_uri
}

output "bootstrap_admin_upn" {
  value = module.identity.bootstrap_admin_upn
}

output "bootstrap_admin_initial_password" {
  value     = module.identity.bootstrap_admin_initial_password
  sensitive = true
}

output "bootstrap_test_upn" {
  value = module.identity.bootstrap_test_upn
}

output "bootstrap_test_initial_password" {
  value     = module.identity.bootstrap_test_initial_password
  sensitive = true
}

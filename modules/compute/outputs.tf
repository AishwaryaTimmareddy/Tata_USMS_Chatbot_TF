output "app_service_id" { value = azurerm_linux_web_app.this.id }
output "app_service_hostname" { value = azurerm_linux_web_app.this.default_hostname }
output "app_service_staging_slot_id" { value = azurerm_linux_web_app_slot.staging.id }
output "app_service_staging_hostname" { value = azurerm_linux_web_app_slot.staging.default_hostname }
output "function_app_id" { value = azurerm_linux_function_app.this.id }
output "acr_login_server" { value = azurerm_container_registry.this.login_server }
output "application_gateway_id" { value = azurerm_application_gateway.this.id }
output "application_gateway_public_ip" { value = azurerm_public_ip.gateway.ip_address }

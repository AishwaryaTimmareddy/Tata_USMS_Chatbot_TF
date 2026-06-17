output "search_service_id" { value = azurerm_search_service.this.id }
output "search_endpoint" { value = "https://${azurerm_search_service.this.name}.search.windows.net" }
output "openai_account_id" { value = azurerm_cognitive_account.openai.id }
output "openai_endpoint" { value = azurerm_cognitive_account.openai.endpoint }
output "content_safety_account_id" { value = azurerm_cognitive_account.content_safety.id }
output "content_safety_endpoint" { value = azurerm_cognitive_account.content_safety.endpoint }
output "search_index_name" { value = "usms-knowledge-index" }
output "search_indexer_name" { value = "usms-knowledge-indexer" }

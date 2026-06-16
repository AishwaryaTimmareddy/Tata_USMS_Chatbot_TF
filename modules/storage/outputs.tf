output "document_storage_account_id" { value = azurerm_storage_account.documents.id }
output "document_storage_account_url" { value = azurerm_storage_account.documents.primary_blob_endpoint }
output "document_storage_blob_endpoint" { value = azurerm_storage_account.documents.primary_blob_endpoint }
output "document_storage_queue_endpoint" { value = azurerm_storage_account.documents.primary_queue_endpoint }
output "function_storage_account_name" { value = azurerm_storage_account.function.name }
output "function_storage_access_key" {
  value     = azurerm_storage_account.function.primary_access_key
  sensitive = true
}
output "knowledge_container_name" { value = azurerm_storage_container.knowledge.name }

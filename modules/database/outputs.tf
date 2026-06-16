output "cosmos_account_id" { value = azurerm_cosmosdb_account.this.id }
output "cosmos_endpoint" { value = azurerm_cosmosdb_account.this.endpoint }
output "cosmos_database_name" { value = azurerm_cosmosdb_sql_database.this.name }

output "id" {
  value = azurerm_load_test.this.id
}

output "name" {
  value = azurerm_load_test.this.name
}

output "data_plane_uri" {
  value = azurerm_load_test.this.data_plane_uri
}

output "principal_id" {
  value = azurerm_load_test.this.identity[0].principal_id
}

resource "azurerm_load_test" "this" {
  name                = "lt-aichatbot-prod-cin-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  description         = "Production performance validation for the USMS Saffron Knowledge Assistant."
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "operator" {
  for_each = var.operator_principal_ids

  scope                = azurerm_load_test.this.id
  role_definition_name = "Load Test Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "metrics_reader" {
  for_each = var.monitored_resource_ids

  scope                = each.value
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_load_test.this.identity[0].principal_id
}

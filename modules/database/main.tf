resource "azurerm_cosmosdb_account" "this" {
  name                          = "cosmos-aichatbot-prod-cin-001"
  location                      = var.location
  resource_group_name           = var.workload_resource_group_name
  offer_type                    = "Standard"
  kind                          = "GlobalDocumentDB"
  public_network_access_enabled = length(var.admin_public_ip_ranges) > 0
  ip_range_filter              = var.admin_public_ip_ranges
  free_tier_enabled             = false
  tags                          = var.tags
  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  backup {
    type = "Continuous"
    tier = "Continuous7Days"
  }
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = "usms-chatbot"
  resource_group_name = var.workload_resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  autoscale_settings {
    max_throughput = 1000
  }
}

locals {
  containers = {
    users         = "/id"
    conversations = "/userId"
    feedback      = "/userId"
  }
}

resource "azurerm_cosmosdb_sql_container" "this" {
  for_each              = local.containers
  name                  = each.key
  resource_group_name   = var.workload_resource_group_name
  account_name          = azurerm_cosmosdb_account.this.name
  database_name         = azurerm_cosmosdb_sql_database.this.name
  partition_key_paths   = [each.value]
  partition_key_version = 2
}

resource "azurerm_private_endpoint" "this" {
  name                = "pe-aichatbot-prod-cin-cosmos-001"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags
  private_service_connection {
    name                           = "psc-cosmos"
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["cosmos"]]
  }
}

resource "azurerm_cosmosdb_sql_role_assignment" "app" {
  resource_group_name = var.workload_resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "${azurerm_cosmosdb_account.this.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = var.app_identity_principal_id
  scope               = azurerm_cosmosdb_account.this.id
}

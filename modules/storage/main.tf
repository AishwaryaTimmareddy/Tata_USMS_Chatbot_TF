resource "azurerm_storage_account" "documents" {
  name                             = "staichatbotprodcin001"
  resource_group_name              = var.workload_resource_group_name
  location                         = var.location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  account_kind                     = "StorageV2"
  access_tier                      = "Hot"
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  public_network_access_enabled    = length(var.admin_public_ip_ranges) > 0
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  tags                             = var.tags
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.admin_public_ip_ranges
  }
  blob_properties {
    versioning_enabled = true
    delete_retention_policy { days = 30 }
    container_delete_retention_policy { days = 30 }
  }
}

resource "azurerm_storage_container" "knowledge" {
  name                  = "knowledge"
  storage_account_id    = azurerm_storage_account.documents.id
  container_access_type = "private"
}

resource "azurerm_storage_account" "function" {
  name                            = "stfuncaichatprodcin001"
  resource_group_name             = var.workload_resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = var.function_storage_public_network_access_enabled || length(var.admin_public_ip_ranges) > 0
  allow_nested_items_to_be_public = false
  tags                            = var.tags
  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
    ip_rules       = var.admin_public_ip_ranges
  }
}

locals {
  endpoints = {
    documents_blob  = { id = azurerm_storage_account.documents.id, service = "blob", dns = "blob" }
    documents_queue = { id = azurerm_storage_account.documents.id, service = "queue", dns = "queue" }
    function_blob   = { id = azurerm_storage_account.function.id, service = "blob", dns = "blob" }
    function_file   = { id = azurerm_storage_account.function.id, service = "file", dns = "file" }
    function_queue  = { id = azurerm_storage_account.function.id, service = "queue", dns = "queue" }
    function_table  = { id = azurerm_storage_account.function.id, service = "table", dns = "table" }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = local.endpoints
  name                = "pe-aichatbot-prod-cin-${replace(each.key, "_", "-")}-001"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags
  private_service_connection {
    name                           = "psc-${each.key}"
    private_connection_resource_id = each.value.id
    subresource_names              = [each.value.service]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids[each.value.dns]]
  }
}

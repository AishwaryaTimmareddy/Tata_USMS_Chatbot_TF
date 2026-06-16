data "azurerm_client_config" "current" {}

resource "random_password" "jwt" {
  length  = 64
  special = true
}

resource "random_password" "bootstrap_admin" {
  length  = 32
  special = true
}

resource "azurerm_key_vault" "this" {
  name                          = "kv-aichat-prod-cin-001"
  location                      = var.location
  resource_group_name           = var.security_resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 90
  public_network_access_enabled = var.public_network_access_enabled || length(var.admin_public_ip_ranges) > 0
  tags                          = var.tags
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.admin_public_ip_ranges
  }
}

locals {
  vault_roles = {
    terraform = { role = "Key Vault Administrator", principal = data.azurerm_client_config.current.object_id }
    app       = { role = "Key Vault Secrets User", principal = var.app_identity_principal_id }
    function  = { role = "Key Vault Secrets User", principal = var.function_identity_principal_id }
  }
}

resource "azurerm_role_assignment" "vault" {
  for_each             = local.vault_roles
  scope                = azurerm_key_vault.this.id
  role_definition_name = each.value.role
  principal_id         = each.value.principal
}

resource "azurerm_key_vault_secret" "jwt" {
  name         = "jwt-secret-key"
  value        = random_password.jwt.result
  key_vault_id = azurerm_key_vault.this.id
  depends_on   = [azurerm_role_assignment.vault]
}

resource "azurerm_key_vault_secret" "bootstrap_admin" {
  name         = "app-bootstrap-admin-password"
  value        = random_password.bootstrap_admin.result
  key_vault_id = azurerm_key_vault.this.id
  depends_on   = [azurerm_role_assignment.vault]
}

resource "azurerm_private_endpoint" "vault" {
  name                = "pe-aichatbot-prod-cin-keyvault-001"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags
  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_ids["vault"]]
  }
}

resource "azurerm_security_center_subscription_pricing" "this" {
  for_each = {
    AppServices     = null, CosmosDbs = null, KeyVaults = "PerKeyVault",
    StorageAccounts = "DefenderForStorageV2", Containers = null, Arm = "PerSubscription"
  }
  resource_type = each.key
  tier          = "Standard"
  subplan       = each.value
}

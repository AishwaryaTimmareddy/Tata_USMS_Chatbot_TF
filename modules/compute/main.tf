resource "azurerm_container_registry" "this" {
  name                          = "acraichatbotprodcin001"
  resource_group_name           = var.workload_resource_group_name
  location                      = var.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = var.acr_public_network_access_enabled
  tags                          = var.tags
}

locals {
  app_service_admin_ip_ranges = [
    for ip_range in var.admin_public_ip_ranges :
    length(regexall("/", ip_range)) > 0 ? ip_range : "${ip_range}/32"
  ]
}

resource "azurerm_service_plan" "app" {
  name                   = "asp-aichatbot-prod-cin-001"
  resource_group_name    = var.workload_resource_group_name
  location               = var.location
  os_type                = "Linux"
  sku_name               = "P1v2"
  zone_balancing_enabled = true
  tags                   = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                            = "app-aichatbot-prod-cin-001"
  resource_group_name             = var.workload_resource_group_name
  location                        = var.location
  service_plan_id                 = azurerm_service_plan.app.id
  virtual_network_subnet_id       = var.app_subnet_id
  public_network_access_enabled   = var.app_public_network_access_enabled || length(var.admin_public_ip_ranges) > 0
  https_only                      = true
  key_vault_reference_identity_id = var.app_identity_id
  tags                            = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.app_identity_id]
  }

  site_config {
    always_on                                     = true
    ftps_state                                    = "Disabled"
    minimum_tls_version                           = "1.2"
    scm_use_main_ip_restriction                   = true
    vnet_route_all_enabled                        = true
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = var.app_identity_client_id
    application_stack {
      docker_image_name   = var.container_image
      docker_registry_url = "https://${azurerm_container_registry.this.login_server}"
    }
    dynamic "ip_restriction" {
      for_each = local.app_service_admin_ip_ranges
      content {
        name       = "admin-${ip_restriction.key + 1}"
        priority   = 100 + ip_restriction.key
        action     = "Allow"
        ip_address = ip_restriction.value
      }
    }
  }

  app_settings = {
    APP_ENV                               = "production"
    AZURE_CLIENT_ID                       = var.app_identity_client_id
    WEBSITES_PORT                         = "8000"
    WEBSITE_PULL_IMAGE_OVER_VNET          = "1"
    AZURE_OPENAI_ENDPOINT                 = var.openai_endpoint
    AZURE_OPENAI_CHAT_DEPLOYMENT          = "chat"
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT     = "embedding"
    AZURE_CONTENT_SAFETY_ENDPOINT         = var.content_safety_endpoint
    AZURE_SEARCH_ENDPOINT                 = var.search_endpoint
    AZURE_SEARCH_INDEX_NAME               = "usms-knowledge-index"
    AZURE_SEARCH_INDEXER_NAME             = "usms-knowledge-indexer"
    AZURE_STORAGE_ACCOUNT_URL             = var.document_storage_account_url
    AZURE_STORAGE_CONTAINER               = "knowledge"
    AZURE_COSMOS_ENDPOINT                 = var.cosmos_endpoint
    AZURE_COSMOS_DATABASE                 = "usms-chatbot"
    AZURE_COSMOS_USERS_CONTAINER          = "users"
    AZURE_COSMOS_CONVERSATIONS_CONTAINER  = "conversations"
    AZURE_COSMOS_FEEDBACK_CONTAINER       = "feedback"
    JWT_SECRET_KEY                        = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/jwt-secret-key)"
    BOOTSTRAP_ADMIN_USERNAME              = "saffronadmin"
    BOOTSTRAP_ADMIN_EMAIL                 = "aichatbot-admin@usmssaffron.onmicrosoft.com"
    BOOTSTRAP_ADMIN_PASSWORD              = "@Microsoft.KeyVault(SecretUri=${var.key_vault_uri}secrets/app-bootstrap-admin-password)"
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.application_insights_connection_string
  }

  lifecycle {
    ignore_changes = [tags["hidden-link: /app-insights-resource-id"]]
  }
}

resource "azurerm_service_plan" "function" {
  name                = "asp-aichatbot-prod-cin-function-001"
  resource_group_name = var.workload_resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "EP1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "this" {
  name                          = "func-aichatbot-prod-cin-001"
  resource_group_name           = var.workload_resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.function.id
  storage_account_name          = var.function_storage_account_name
  storage_account_access_key    = var.function_storage_access_key
  virtual_network_subnet_id     = var.function_subnet_id
  public_network_access_enabled = var.function_public_network_access_enabled
  https_only                    = true
  tags                          = var.tags
  identity {
    type         = "UserAssigned"
    identity_ids = [var.function_identity_id]
  }
  site_config {
    minimum_tls_version                    = "1.2"
    ftps_state                             = "Disabled"
    vnet_route_all_enabled                 = true
    application_insights_connection_string = var.application_insights_connection_string
    application_stack { python_version = "3.11" }
  }
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME         = "python"
    AZURE_CLIENT_ID                  = var.function_identity_client_id
    AZURE_STORAGE_CONTAINER          = "knowledge"
    DocumentStorage__blobServiceUri  = var.document_storage_blob_endpoint
    DocumentStorage__queueServiceUri = var.document_storage_queue_endpoint
    DocumentStorage__credential      = "managedidentity"
    DocumentStorage__clientId        = var.function_identity_client_id
    AZURE_SEARCH_ENDPOINT            = var.search_endpoint
    AZURE_SEARCH_INDEXER_NAME        = "usms-knowledge-indexer"
    SCM_DO_BUILD_DURING_DEPLOYMENT   = "true"
    ENABLE_ORYX_BUILD                = "true"
    WEBSITE_CONTENTOVERVNET          = "1"
  }

  lifecycle {
    ignore_changes = [tags["hidden-link: /app-insights-resource-id"]]
  }
}

locals {
  private_endpoints = {
    app      = { id = azurerm_linux_web_app.this.id, service = "sites", dns = "web" }
    function = { id = azurerm_linux_function_app.this.id, service = "sites", dns = "web" }
    acr      = { id = azurerm_container_registry.this.id, service = "registry", dns = "acr" }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = local.private_endpoints
  name                = "pe-aichatbot-prod-cin-${each.key}-001"
  resource_group_name = var.network_resource_group_name
  location            = var.location
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

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = var.app_identity_principal_id
}

resource "azurerm_role_assignment" "app_document_blob" {
  scope                = var.document_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.app_identity_principal_id
}

resource "azurerm_role_assignment" "function_document_blob" {
  scope                = var.document_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = var.function_identity_principal_id
}

resource "azurerm_role_assignment" "function_document_queue" {
  scope                = var.document_storage_account_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = var.function_identity_principal_id
}

resource "azurerm_public_ip" "gateway" {
  name                = "pip-aichatbot-prod-cin-appgw-001"
  resource_group_name = var.network_resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_application_gateway" "this" {
  name                = "agw-aichatbot-prod-cin-001"
  resource_group_name = var.network_resource_group_name
  location            = var.location
  tags                = var.tags
  identity {
    type         = "UserAssigned"
    identity_ids = [var.app_identity_id]
  }
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
  gateway_ip_configuration {
    name      = "gateway"
    subnet_id = var.app_gateway_subnet_id
  }
  frontend_port {
    name = var.app_gateway_certificate_secret_id == null ? "http" : "https"
    port = var.app_gateway_certificate_secret_id == null ? 80 : 443
  }
  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }
  dynamic "ssl_certificate" {
    for_each = var.app_gateway_certificate_secret_id == null ? [] : [1]
    content {
      name                = "production"
      key_vault_secret_id = var.app_gateway_certificate_secret_id
    }
  }
  backend_address_pool {
    name  = "app"
    fqdns = [azurerm_linux_web_app.this.default_hostname]
  }
  backend_http_settings {
    name                                = "app-https"
    protocol                            = "Https"
    port                                = 443
    cookie_based_affinity               = "Disabled"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
  }
  http_listener {
    name                           = "public"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = var.app_gateway_certificate_secret_id == null ? "http" : "https"
    protocol                       = var.app_gateway_certificate_secret_id == null ? "Http" : "Https"
    ssl_certificate_name           = var.app_gateway_certificate_secret_id == null ? null : "production"
    host_name                      = var.app_gateway_host_name
  }
  request_routing_rule {
    name                       = "app"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "public"
    backend_address_pool_name  = "app"
    backend_http_settings_name = "app-https"
  }
}

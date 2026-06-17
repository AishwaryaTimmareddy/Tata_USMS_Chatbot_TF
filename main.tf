module "networking" {
  source = "./modules/networking"

  location                 = var.location
  resource_group_name      = azurerm_resource_group.this["network"].name
  tenant_id                = var.tenant_id
  enable_vpn               = var.enable_vpn
  vpn_client_address_space = var.vpn_client_address_space
  tags                     = local.tags
}

module "identity" {
  source = "./modules/identity"

  location               = var.location
  resource_group_name    = azurerm_resource_group.this["security"].name
  resource_group_ids     = { for key, value in azurerm_resource_group.this : key => value.id }
  admin_object_ids       = var.admin_object_ids
  contributor_object_ids = var.contributor_object_ids
  reader_object_ids      = var.reader_object_ids
  create_bootstrap_users = var.create_bootstrap_users
  bootstrap_admin_upn    = var.bootstrap_admin_upn
  bootstrap_test_upn     = var.bootstrap_test_upn
  tags                   = local.tags
}

module "storage" {
  source = "./modules/storage"

  location                                       = var.location
  workload_resource_group_name                   = azurerm_resource_group.this["workload"].name
  network_resource_group_name                    = azurerm_resource_group.this["network"].name
  private_endpoint_subnet_id                     = module.networking.private_endpoint_subnet_id
  private_dns_zone_ids                           = module.networking.private_dns_zone_ids
  function_storage_public_network_access_enabled = var.function_storage_public_network_access_enabled
  admin_public_ip_ranges                         = var.admin_public_ip_ranges
  tags                                           = local.tags
}

module "database" {
  source = "./modules/database"

  location                     = var.location
  workload_resource_group_name = azurerm_resource_group.this["workload"].name
  network_resource_group_name  = azurerm_resource_group.this["network"].name
  private_endpoint_subnet_id   = module.networking.private_endpoint_subnet_id
  private_dns_zone_ids         = module.networking.private_dns_zone_ids
  app_identity_principal_id    = module.identity.app_identity_principal_id
  admin_public_ip_ranges       = var.admin_public_ip_ranges
  tags                         = local.tags
}

module "ai" {
  source = "./modules/ai"

  location                             = var.location
  openai_location                      = var.openai_location
  workload_resource_group_id           = azurerm_resource_group.this["workload"].id
  workload_resource_group_name         = azurerm_resource_group.this["workload"].name
  network_resource_group_name          = azurerm_resource_group.this["network"].name
  private_endpoint_subnet_id           = module.networking.private_endpoint_subnet_id
  private_dns_zone_ids                 = module.networking.private_dns_zone_ids
  document_storage_account_id          = module.storage.document_storage_account_id
  app_identity_principal_id            = module.identity.app_identity_principal_id
  function_identity_principal_id       = module.identity.function_identity_principal_id
  chat_model_name                      = var.chat_model_name
  chat_model_version                   = var.chat_model_version
  chat_deployment_capacity             = var.chat_deployment_capacity
  embedding_model_name                 = var.embedding_model_name
  embedding_model_version              = var.embedding_model_version
  embedding_deployment_capacity        = var.embedding_deployment_capacity
  search_public_network_access_enabled = var.search_public_network_access_enabled
  manage_search_data_plane             = var.manage_search_data_plane
  openai_public_network_access_enabled = var.openai_public_network_access_enabled
  admin_public_ip_ranges               = var.admin_public_ip_ranges
  tags                                 = local.tags
}

module "security" {
  source = "./modules/security"

  location                       = var.location
  tenant_id                      = var.tenant_id
  security_resource_group_name   = azurerm_resource_group.this["security"].name
  network_resource_group_name    = azurerm_resource_group.this["network"].name
  private_endpoint_subnet_id     = module.networking.private_endpoint_subnet_id
  private_dns_zone_ids           = module.networking.private_dns_zone_ids
  app_identity_principal_id      = module.identity.app_identity_principal_id
  function_identity_principal_id = module.identity.function_identity_principal_id
  public_network_access_enabled  = var.key_vault_public_network_access_enabled
  admin_public_ip_ranges         = var.admin_public_ip_ranges
  tags                           = local.tags
}

module "compute" {
  source = "./modules/compute"

  location                               = var.location
  workload_resource_group_name           = azurerm_resource_group.this["workload"].name
  network_resource_group_name            = azurerm_resource_group.this["network"].name
  app_subnet_id                          = module.networking.app_subnet_id
  function_subnet_id                     = module.networking.function_subnet_id
  private_endpoint_subnet_id             = module.networking.private_endpoint_subnet_id
  app_gateway_subnet_id                  = module.networking.app_gateway_subnet_id
  private_dns_zone_ids                   = module.networking.private_dns_zone_ids
  app_identity_id                        = module.identity.app_identity_id
  app_identity_client_id                 = module.identity.app_identity_client_id
  app_identity_principal_id              = module.identity.app_identity_principal_id
  app_public_network_access_enabled      = var.app_public_network_access_enabled
  admin_public_ip_ranges                 = var.admin_public_ip_ranges
  function_identity_id                   = module.identity.function_identity_id
  function_identity_client_id            = module.identity.function_identity_client_id
  function_identity_principal_id         = module.identity.function_identity_principal_id
  function_public_network_access_enabled = var.function_public_network_access_enabled
  function_storage_account_name          = module.storage.function_storage_account_name
  function_storage_access_key            = module.storage.function_storage_access_key
  document_storage_account_url           = module.storage.document_storage_account_url
  document_storage_account_id            = module.storage.document_storage_account_id
  document_storage_blob_endpoint         = module.storage.document_storage_blob_endpoint
  document_storage_queue_endpoint        = module.storage.document_storage_queue_endpoint
  search_endpoint                        = module.ai.search_endpoint
  openai_endpoint                        = module.ai.openai_endpoint
  content_safety_endpoint                = module.ai.content_safety_endpoint
  cosmos_endpoint                        = module.database.cosmos_endpoint
  key_vault_uri                          = module.security.key_vault_uri
  application_insights_connection_string = module.monitoring.application_insights_connection_string
  container_image                        = var.container_image
  app_gateway_certificate_secret_id      = var.app_gateway_certificate_secret_id
  app_gateway_host_name                  = var.app_gateway_host_name
  acr_public_network_access_enabled      = var.acr_public_network_access_enabled
  tags                                   = local.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  subscription_id     = var.subscription_id
  location            = var.location
  resource_group_name = azurerm_resource_group.this["monitoring"].name
  alert_email_address = var.alert_email_address
  monthly_budget_inr  = var.monthly_budget_inr
  diagnostic_resource_ids = {
    app_gateway    = module.compute.application_gateway_id
    app_service    = module.compute.app_service_id
    function_app   = module.compute.function_app_id
    storage        = module.storage.document_storage_account_id
    cosmos         = module.database.cosmos_account_id
    search         = module.ai.search_service_id
    openai         = module.ai.openai_account_id
    content_safety = module.ai.content_safety_account_id
    key_vault      = module.security.key_vault_id
  }
  alert_resource_ids = {
    app_gateway  = module.compute.application_gateway_id
    app_service  = module.compute.app_service_id
    function_app = module.compute.function_app_id
    storage      = module.storage.document_storage_account_id
    cosmos       = module.database.cosmos_account_id
    search       = module.ai.search_service_id
  }
  tags = local.tags
}

module "governance" {
  source = "./modules/governance"

  subscription_id = var.subscription_id
  location        = var.location
  required_tags   = local.tags
  resource_group_ids = {
    for key, resource_group in azurerm_resource_group.this : key => resource_group.id
  }
}

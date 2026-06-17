import {
  to = azurerm_resource_group.this["monitoring"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-monitoring-001"
}

import {
  to = azurerm_resource_group.this["network"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001"
}

import {
  to = azurerm_resource_group.this["security"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001"
}

import {
  to = azurerm_resource_group.this["workload"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001"
}

import {
  to = module.governance.azurerm_policy_definition.required_tag
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Authorization/policyDefinitions/aichatbot-require-resource-tag"
}

import {
  to = module.identity.azuread_user.bootstrap_admin[0]
  id = "/users/3d63471c-9a8d-487b-acf0-11d7d3990a73"
}

import {
  to = module.identity.azuread_user.bootstrap_test[0]
  id = "/users/20441ec5-3b00-44ad-bde1-f3e8993574ef"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["AppServices"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/AppServices"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["StorageAccounts"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/StorageAccounts"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["KeyVaults"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/KeyVaults"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["Containers"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/Containers"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["CosmosDbs"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/CosmosDbs"
}

import {
  to = module.security.azurerm_security_center_subscription_pricing.this["Arm"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Security/pricings/Arm"
}

import {
  to = module.ai.azurerm_search_service.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Search/searchServices/srch-aichatbot-prod-cin-001"
}

import {
  to = module.ai.azurerm_cognitive_account.openai
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/oai-aichatbot-prod-eus-001"
}

import {
  to = module.ai.azapi_resource.foundry
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/aif-aichatbot-prod-cin-001"
}

import {
  to = module.ai.azapi_resource.search_openai_shared_private_link
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Search/searchServices/srch-aichatbot-prod-cin-001/sharedPrivateLinkResources/spl-openai"
}

import {
  to = module.compute.azurerm_container_registry.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.ContainerRegistry/registries/acraichatbotprodcin001"
}

import {
  to = module.compute.azurerm_service_plan.app
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Web/serverFarms/asp-aichatbot-prod-cin-001"
}

import {
  to = module.compute.azurerm_service_plan.function
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Web/serverFarms/asp-aichatbot-prod-cin-function-001"
}

import {
  to = module.compute.azurerm_public_ip.gateway
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/publicIPAddresses/pip-aichatbot-prod-cin-appgw-001"
}

import {
  to = module.database.azurerm_cosmosdb_account.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-aichatbot-prod-cin-001"
}

import {
  to = module.governance.azurerm_policy_set_definition.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Authorization/policySetDefinitions/aichatbot-prod-baseline"
}

import {
  to = module.identity.azurerm_user_assigned_identity.app
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aichatbot-prod-cin-app-001"
}

import {
  to = module.identity.azurerm_user_assigned_identity.function
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-aichatbot-prod-cin-function-001"
}

import {
  to = module.monitoring.azurerm_log_analytics_workspace.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-monitoring-001/providers/Microsoft.OperationalInsights/workspaces/law-aichatbot-prod-cin-001"
}

import {
  to = module.monitoring.azurerm_monitor_action_group.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-monitoring-001/providers/Microsoft.Insights/actionGroups/ag-aichatbot-prod-cin-critical-001"
}

import {
  to = module.networking.azurerm_virtual_network.hub
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-hub-001"
}

import {
  to = module.networking.azurerm_virtual_network.spoke
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001"
}

import {
  to = module.networking.azurerm_network_security_group.this["appgw"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/networkSecurityGroups/nsg-aichatbot-prod-cin-appgw-001"
}

import {
  to = module.networking.azurerm_network_security_group.this["app"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/networkSecurityGroups/nsg-aichatbot-prod-cin-app-001"
}

import {
  to = module.networking.azurerm_network_security_group.this["function"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/networkSecurityGroups/nsg-aichatbot-prod-cin-function-001"
}

import {
  to = module.networking.azurerm_network_security_group.this["private"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/networkSecurityGroups/nsg-aichatbot-prod-cin-private-001"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["file"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["queue"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["table"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["web"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["cosmos"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["vault"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["acr"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"
}

import {
  to = module.networking.azurerm_private_dns_zone.this["cognitive"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
}

import {
  to = module.security.azurerm_key_vault.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.KeyVault/vaults/kv-aichat-prod-cin-001"
}

import {
  to = module.storage.azurerm_storage_account.documents
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/staichatbotprodcin001"
}

import {
  to = module.storage.azurerm_storage_account.function
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/stfuncaichatprodcin001"
}

import {
  to = module.storage.azurerm_storage_container.knowledge
  id = "https://staichatbotprodcin001.blob.core.windows.net/knowledge"
}

import {
  to = module.security.azurerm_role_assignment.vault["function"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.KeyVault/vaults/kv-aichat-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/87f8c7b1227ff383d8823efc5f75f971"
}

import {
  to = module.security.azurerm_role_assignment.vault["terraform"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.KeyVault/vaults/kv-aichat-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/0245957c1a220002142a82266127e461"
}

import {
  to = module.security.azurerm_role_assignment.vault["app"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.KeyVault/vaults/kv-aichat-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/6938e69233cfe9b90cac22ad79144be9"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net/virtualNetworkLinks/link-blob-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["file"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net/virtualNetworkLinks/link-file-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["queue"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net/virtualNetworkLinks/link-queue-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["table"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net/virtualNetworkLinks/link-table-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["web"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net/virtualNetworkLinks/link-web-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net/virtualNetworkLinks/link-search-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["cosmos"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com/virtualNetworkLinks/link-cosmos-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["vault"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net/virtualNetworkLinks/link-vault-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["acr"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/virtualNetworkLinks/link-acr-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com/virtualNetworkLinks/link-openai-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.spoke["cognitive"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com/virtualNetworkLinks/link-cognitive-spoke"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net/virtualNetworkLinks/link-blob-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["file"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net/virtualNetworkLinks/link-file-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["queue"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net/virtualNetworkLinks/link-queue-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["table"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.table.core.windows.net/virtualNetworkLinks/link-table-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["web"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net/virtualNetworkLinks/link-web-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net/virtualNetworkLinks/link-search-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["cosmos"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com/virtualNetworkLinks/link-cosmos-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["vault"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net/virtualNetworkLinks/link-vault-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["acr"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurecr.io/virtualNetworkLinks/link-acr-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com/virtualNetworkLinks/link-openai-hub"
}

import {
  to = module.networking.azurerm_private_dns_zone_virtual_network_link.hub["cognitive"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com/virtualNetworkLinks/link-cognitive-hub"
}

import {
  to = module.networking.azurerm_subnet.this["appgw"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-hub-001/subnets/snet-aichatbot-prod-cin-appgw-001"
}

import {
  to = module.networking.azurerm_subnet.this["gateway"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-hub-001/subnets/GatewaySubnet"
}

import {
  to = module.networking.azurerm_subnet.this["app"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-app-001"
}

import {
  to = module.networking.azurerm_subnet.this["function"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-function-001"
}

import {
  to = module.networking.azurerm_subnet.this["private"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-privateendpoint-001"
}

import {
  to = module.networking.azurerm_subnet_network_security_group_association.this["appgw"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-hub-001/subnets/snet-aichatbot-prod-cin-appgw-001"
}

import {
  to = module.networking.azurerm_subnet_network_security_group_association.this["app"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-app-001"
}

import {
  to = module.networking.azurerm_subnet_network_security_group_association.this["function"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-function-001"
}

import {
  to = module.networking.azurerm_subnet_network_security_group_association.this["private"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/subnets/snet-aichatbot-prod-cin-privateendpoint-001"
}

import {
  to = module.networking.azurerm_virtual_network_peering.hub_to_spoke
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-hub-001/virtualNetworkPeerings/peer-hub-to-spoke"
}

import {
  to = module.networking.azurerm_virtual_network_peering.spoke_to_hub
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/virtualNetworks/vnet-aichatbot-prod-cin-spoke-001/virtualNetworkPeerings/peer-spoke-to-hub"
}

import {
  to = module.governance.azurerm_resource_group_policy_assignment.this["monitoring"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-monitoring-001/providers/Microsoft.Authorization/policyAssignments/aichatbot-prod-baseline"
}

import {
  to = module.governance.azurerm_resource_group_policy_assignment.this["network"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Authorization/policyAssignments/aichatbot-prod-baseline"
}

import {
  to = module.governance.azurerm_resource_group_policy_assignment.this["security"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-security-001/providers/Microsoft.Authorization/policyAssignments/aichatbot-prod-baseline"
}

import {
  to = module.governance.azurerm_resource_group_policy_assignment.this["workload"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Authorization/policyAssignments/aichatbot-prod-baseline"
}

import {
  to = module.monitoring.azurerm_application_insights.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-monitoring-001/providers/Microsoft.Insights/components/appi-aichatbot-prod-cin-001"
}

import {
  to = module.monitoring.azurerm_consumption_budget_subscription.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/providers/Microsoft.Consumption/budgets/budget-aichatbot-prod-monthly"
}

import {
  to = module.database.azurerm_cosmosdb_sql_database.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-aichatbot-prod-cin-001/sqlDatabases/usms-chatbot"
}

import {
  to = module.database.azurerm_cosmosdb_sql_container.this["users"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-aichatbot-prod-cin-001/sqlDatabases/usms-chatbot/containers/users"
}

import {
  to = module.database.azurerm_cosmosdb_sql_container.this["conversations"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-aichatbot-prod-cin-001/sqlDatabases/usms-chatbot/containers/conversations"
}

import {
  to = module.database.azurerm_cosmosdb_sql_container.this["feedback"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.DocumentDB/databaseAccounts/cosmos-aichatbot-prod-cin-001/sqlDatabases/usms-chatbot/containers/feedback"
}

import {
  to = module.ai.azurerm_cognitive_deployment.chat
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/oai-aichatbot-prod-eus-001/deployments/chat"
}

import {
  to = module.ai.azurerm_cognitive_deployment.embedding
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/oai-aichatbot-prod-eus-001/deployments/embedding"
}

import {
  to = module.ai.azapi_resource.foundry_project
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/aif-aichatbot-prod-cin-001/projects/proj-aichatbot-prod-cin-001"
}

import {
  to = module.compute.azurerm_linux_web_app.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Web/sites/app-aichatbot-prod-cin-001"
}

import {
  to = module.compute.azurerm_linux_function_app.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Web/sites/func-aichatbot-prod-cin-001"
}

import {
  to = module.compute.azurerm_application_gateway.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/applicationGateways/agw-aichatbot-prod-cin-001"
}

import {
  to = module.ai.azurerm_private_endpoint.this["search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-search-001"
}

import {
  to = module.ai.azurerm_private_endpoint.this["openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-openai-001"
}

import {
  to = module.ai.azurerm_private_endpoint.this["foundry"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-foundry-001"
}

import {
  to = module.compute.azurerm_private_endpoint.this["app"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-app-001"
}

import {
  to = module.compute.azurerm_private_endpoint.this["function"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-function-001"
}

import {
  to = module.compute.azurerm_private_endpoint.this["acr"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-acr-001"
}

import {
  to = module.database.azurerm_private_endpoint.this
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-cosmos-001"
}

import {
  to = module.security.azurerm_private_endpoint.vault
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-keyvault-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["documents_blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-documents-blob-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["documents_queue"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-documents-queue-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["function_blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-function-blob-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["function_file"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-function-file-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["function_queue"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-function-queue-001"
}

import {
  to = module.storage.azurerm_private_endpoint.this["function_table"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-network-001/providers/Microsoft.Network/privateEndpoints/pe-aichatbot-prod-cin-function-table-001"
}

import {
  to = module.security.azurerm_key_vault_secret.jwt
  id = "https://kv-aichat-prod-cin-001.vault.azure.net/secrets/jwt-secret-key/90eab01eaa3d419aa18d883f8c2ec09f"
}

import {
  to = module.security.azurerm_key_vault_secret.bootstrap_admin
  id = "https://kv-aichat-prod-cin-001.vault.azure.net/secrets/app-bootstrap-admin-password/0273d5aaa0b94e8294dd73d18da9832f"
}

import {
  to = module.ai.azurerm_role_assignment.this["app_search_service"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Search/searchServices/srch-aichatbot-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/20db7f412082d16b69d23ac37ed6e144"
}

import {
  to = module.ai.azurerm_role_assignment.this["app_search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Search/searchServices/srch-aichatbot-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/a2fbde2d6eec651d090b3607a7550b6a"
}

import {
  to = module.ai.azurerm_role_assignment.this["function_search"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Search/searchServices/srch-aichatbot-prod-cin-001/providers/Microsoft.Authorization/roleAssignments/08ee19c9046008afdfcb0fc7c9de62a2"
}

import {
  to = module.ai.azurerm_role_assignment.this["app_openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/oai-aichatbot-prod-eus-001/providers/Microsoft.Authorization/roleAssignments/6abe36144d8a69bab17a670afe6be893"
}

import {
  to = module.ai.azurerm_role_assignment.this["search_openai"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.CognitiveServices/accounts/oai-aichatbot-prod-eus-001/providers/Microsoft.Authorization/roleAssignments/810b5e4de6b9eaf3a93551318ab02b02"
}

import {
  to = module.ai.azurerm_role_assignment.this["search_blob"]
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/staichatbotprodcin001/providers/Microsoft.Authorization/roleAssignments/13797464119a3bbf8c8c9eb81823e016"
}

import {
  to = module.compute.azurerm_role_assignment.acr_pull
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.ContainerRegistry/registries/acraichatbotprodcin001/providers/Microsoft.Authorization/roleAssignments/57ed32b5500758c14107286177cf3734"
}

import {
  to = module.compute.azurerm_role_assignment.app_document_blob
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/staichatbotprodcin001/providers/Microsoft.Authorization/roleAssignments/b73259cef33139c50a84c23982dec64d"
}

import {
  to = module.compute.azurerm_role_assignment.function_document_blob
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/staichatbotprodcin001/providers/Microsoft.Authorization/roleAssignments/e4f307d640edcf74d56f9c92c63dd4bc"
}

import {
  to = module.compute.azurerm_role_assignment.function_document_queue
  id = "/subscriptions/c5f8a2a5-c92f-4daf-9151-078400953600/resourceGroups/rg-aichatbot-prod-cin-workload-001/providers/Microsoft.Storage/storageAccounts/staichatbotprodcin001/providers/Microsoft.Authorization/roleAssignments/330520ae1c2520804cfdd68de07710c9"
}

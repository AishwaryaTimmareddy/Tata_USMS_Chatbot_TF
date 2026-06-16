locals {
  stem = "aichatbot-prod-cin"
  private_dns_zones = {
    blob      = "privatelink.blob.core.windows.net"
    file      = "privatelink.file.core.windows.net"
    queue     = "privatelink.queue.core.windows.net"
    table     = "privatelink.table.core.windows.net"
    web       = "privatelink.azurewebsites.net"
    search    = "privatelink.search.windows.net"
    cosmos    = "privatelink.documents.azure.com"
    vault     = "privatelink.vaultcore.azure.net"
    acr       = "privatelink.azurecr.io"
    openai    = "privatelink.openai.azure.com"
    cognitive = "privatelink.cognitiveservices.azure.com"
  }
  subnets = {
    appgw    = { vnet = "hub", prefix = "10.40.0.0/24", name = "snet-${local.stem}-appgw-001" }
    gateway  = { vnet = "hub", prefix = "10.40.1.0/27", name = "GatewaySubnet" }
    app      = { vnet = "spoke", prefix = "10.41.0.0/24", name = "snet-${local.stem}-app-001" }
    function = { vnet = "spoke", prefix = "10.41.1.0/24", name = "snet-${local.stem}-function-001" }
    private  = { vnet = "spoke", prefix = "10.41.2.0/24", name = "snet-${local.stem}-privateendpoint-001" }
  }
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${local.stem}-hub-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.40.0.0/16"]
  tags                = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${local.stem}-spoke-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.41.0.0/16"]
  tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  for_each = {
    for key, subnet in local.subnets : key => subnet
    if key != "gateway"
  }

  name                = "nsg-${local.stem}-${each.key}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  dynamic "security_rule" {
    for_each = each.key == "appgw" ? [1] : []
    content {
      name                       = "AllowGatewayManager"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = each.key == "appgw" ? [1] : []
    content {
      name                       = "AllowAzureLoadBalancer"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = each.key == "appgw" ? [1] : []
    content {
      name                       = "AllowPublicWeb"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["80", "443"]
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = each.value.vnet == "hub" ? azurerm_virtual_network.hub.name : azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value.prefix]

  dynamic "delegation" {
    for_each = contains(["app", "function"], each.key) ? [1] : []
    content {
      name = "app-service"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for key, subnet in local.subnets : key => subnet
    if key != "gateway"
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = var.enable_vpn
  depends_on                = [azurerm_virtual_network_gateway.vpn]
}

resource "azurerm_private_dns_zone" "this" {
  for_each            = local.private_dns_zones
  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  for_each              = local.private_dns_zones
  name                  = "link-${each.key}-spoke"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.spoke.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each              = local.private_dns_zones
  name                  = "link-${each.key}-hub"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.hub.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_public_ip" "vpn" {
  count               = var.enable_vpn ? 1 : 0
  name                = "pip-${local.stem}-vpn-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  count               = var.enable_vpn ? 1 : 0
  name                = "vpngw-${local.stem}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1AZ"
  generation          = "Generation1"
  tags                = var.tags
  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.vpn[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.this["gateway"].id
  }
  vpn_client_configuration {
    address_space        = var.vpn_client_address_space
    vpn_client_protocols = ["OpenVPN"]
    aad_tenant           = "https://login.microsoftonline.com/${var.tenant_id}"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/${var.tenant_id}/"
  }
}

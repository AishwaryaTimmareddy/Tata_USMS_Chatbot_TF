output "app_gateway_subnet_id" { value = azurerm_subnet.this["appgw"].id }
output "app_subnet_id" { value = azurerm_subnet.this["app"].id }
output "function_subnet_id" { value = azurerm_subnet.this["function"].id }
output "private_endpoint_subnet_id" { value = azurerm_subnet.this["private"].id }
output "hub_vnet_id" { value = azurerm_virtual_network.hub.id }
output "spoke_vnet_id" { value = azurerm_virtual_network.spoke.id }
output "private_dns_zone_ids" {
  value = { for key, zone in azurerm_private_dns_zone.this : key => zone.id }
}

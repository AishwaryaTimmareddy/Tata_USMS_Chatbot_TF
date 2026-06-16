locals {
  stem = "aichatbot-prod-cin"

  tags = {
    Environment = "Prod"
    Project     = var.project
    Owner       = var.owner
    CostCenter  = var.cost_center
    CreatedBy   = var.created_by
    ManagedBy   = var.managed_by
  }

  resource_groups = {
    network    = "rg-${local.stem}-network-001"
    workload   = "rg-${local.stem}-workload-001"
    security   = "rg-${local.stem}-security-001"
    monitoring = "rg-${local.stem}-monitoring-001"
  }

}

resource "azurerm_resource_group" "this" {
  for_each = local.resource_groups

  name     = each.value
  location = var.location
  tags     = local.tags
}

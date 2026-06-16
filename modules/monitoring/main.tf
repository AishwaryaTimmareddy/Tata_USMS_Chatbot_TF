resource "azurerm_log_analytics_workspace" "this" {
  name                = "law-aichatbot-prod-cin-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = "appi-aichatbot-prod-cin-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-aichatbot-prod-cin-critical-001"
  resource_group_name = var.resource_group_name
  short_name          = "aichatcrit"
  email_receiver {
    name          = "operations"
    email_address = var.alert_email_address
  }
  tags = var.tags
}

resource "azurerm_consumption_budget_subscription" "this" {
  name            = "budget-aichatbot-prod-monthly"
  subscription_id = "/subscriptions/${var.subscription_id}"
  amount          = var.monthly_budget_inr
  time_grain      = "Monthly"

  time_period {
    start_date = "2026-06-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.alert_email_address]
    contact_groups = [azurerm_monitor_action_group.this.id]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = [var.alert_email_address]
    contact_groups = [azurerm_monitor_action_group.this.id]
  }
}

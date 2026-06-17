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

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_resource_ids

  name                       = "diag-aichatbot-prod-${each.key}-001"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  dynamic "enabled_log" {
    for_each = each.key == "storage" ? [] : [1]
    content {
      category_group = "allLogs"
    }
  }

  dynamic "enabled_metric" {
    for_each = each.key == "storage" ? ["Capacity", "Transaction"] : each.key == "cosmos" ? ["Requests", "SLI"] : ["AllMetrics"]
    content {
      category = enabled_metric.value
    }
  }
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

locals {
  metric_alerts = {
    app_gateway_unhealthy_hosts = {
      scope            = var.alert_resource_ids["app_gateway"]
      metric_namespace = "Microsoft.Network/applicationGateways"
      metric_name      = "UnhealthyHostCount"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 0
      description      = "Application Gateway has one or more unhealthy backend hosts."
    }
    app_gateway_failed_requests = {
      scope            = var.alert_resource_ids["app_gateway"]
      metric_namespace = "Microsoft.Network/applicationGateways"
      metric_name      = "FailedRequests"
      aggregation      = "Total"
      operator         = "GreaterThan"
      threshold        = 10
      description      = "Application Gateway is returning failed requests."
    }
    app_service_http_5xx = {
      scope            = var.alert_resource_ids["app_service"]
      metric_namespace = "Microsoft.Web/sites"
      metric_name      = "Http5xx"
      aggregation      = "Total"
      operator         = "GreaterThan"
      threshold        = 5
      description      = "App Service is returning server errors."
    }
    app_service_response_time = {
      scope            = var.alert_resource_ids["app_service"]
      metric_namespace = "Microsoft.Web/sites"
      metric_name      = "AverageResponseTime"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 5
      description      = "App Service average response time is above the SOW target."
    }
    function_http_5xx = {
      scope            = var.alert_resource_ids["function_app"]
      metric_namespace = "Microsoft.Web/sites"
      metric_name      = "Http5xx"
      aggregation      = "Total"
      operator         = "GreaterThan"
      threshold        = 3
      description      = "Function App is returning server errors."
    }
    storage_availability = {
      scope            = var.alert_resource_ids["storage"]
      metric_namespace = "Microsoft.Storage/storageAccounts"
      metric_name      = "Availability"
      aggregation      = "Average"
      operator         = "LessThan"
      threshold        = 99
      description      = "Document Storage availability dropped below 99 percent."
    }
    cosmos_throttled_requests = {
      scope            = var.alert_resource_ids["cosmos"]
      metric_namespace = "Microsoft.DocumentDB/databaseAccounts"
      metric_name      = "TotalRequests"
      aggregation      = "Count"
      operator         = "GreaterThan"
      threshold        = 100
      description      = "Cosmos DB request volume is high; review throttling and RU consumption."
    }
    search_throttled_queries = {
      scope            = var.alert_resource_ids["search"]
      metric_namespace = "Microsoft.Search/searchServices"
      metric_name      = "ThrottledSearchQueriesPercentage"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 5
      description      = "Azure AI Search is throttling queries."
    }
  }
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = local.metric_alerts

  name                = "alert-aichatbot-prod-${replace(each.key, "_", "-")}-001"
  resource_group_name = var.resource_group_name
  scopes              = [each.value.scope]
  description         = each.value.description
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  enabled             = true
  tags                = var.tags

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.this.id
  }
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

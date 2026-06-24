output "log_analytics_workspace_id" { value = azurerm_log_analytics_workspace.this.id }
output "application_insights_id" { value = azurerm_application_insights.this.id }
output "application_insights_connection_string" {
  value     = azurerm_application_insights.this.connection_string
  sensitive = true
}
output "action_group_id" { value = azurerm_monitor_action_group.this.id }
output "chat_alert_rule_ids" {
  value = {
    for key, alert in azurerm_monitor_scheduled_query_rules_alert_v2.chat : key => alert.id
  }
}

variable "subscription_id" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "alert_email_address" { type = string }
variable "monthly_budget_inr" { type = number }
variable "tags" { type = map(string) }

resource "azurerm_user_assigned_identity" "app" {
  name                = "id-aichatbot-prod-cin-app-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_user_assigned_identity" "function" {
  name                = "id-aichatbot-prod-cin-function-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "random_password" "bootstrap_admin" {
  count   = var.create_bootstrap_users ? 1 : 0
  length  = 24
  special = true
}

resource "random_password" "bootstrap_test" {
  count   = var.create_bootstrap_users ? 1 : 0
  length  = 24
  special = true
}

resource "azuread_user" "bootstrap_admin" {
  count = var.create_bootstrap_users ? 1 : 0

  user_principal_name   = var.bootstrap_admin_upn
  display_name          = "AIChatbot Production Administrator"
  mail_nickname         = "aichatbot-admin"
  password              = random_password.bootstrap_admin[0].result
  force_password_change = true
  account_enabled       = true

  lifecycle {
    ignore_changes = [
      password,
      force_password_change,
    ]
  }
}

resource "azuread_user" "bootstrap_test" {
  count = var.create_bootstrap_users ? 1 : 0

  user_principal_name   = var.bootstrap_test_upn
  display_name          = "AIChatbot Production Test User"
  mail_nickname         = "aichatbot-test"
  password              = random_password.bootstrap_test[0].result
  force_password_change = true
  account_enabled       = true

  lifecycle {
    ignore_changes = [
      password,
      force_password_change,
    ]
  }
}

resource "azuread_group" "admins" {
  display_name     = "grp-aichatbot-prod-admins"
  mail_nickname    = "aichatbot-prod-admins"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_group" "contributors" {
  display_name     = "grp-aichatbot-prod-contributors"
  mail_nickname    = "aichatbot-prod-contributors"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_group" "reviewers" {
  display_name     = "grp-aichatbot-prod-reviewers"
  mail_nickname    = "aichatbot-prod-reviewers"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_group" "readonly" {
  display_name     = "grp-aichatbot-prod-readonly"
  mail_nickname    = "aichatbot-prod-readonly"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_group" "it_ops" {
  display_name     = "grp-aichatbot-prod-it-ops"
  mail_nickname    = "aichatbot-prod-it-ops"
  mail_enabled     = false
  security_enabled = true
}

resource "azuread_group_member" "bootstrap_admin" {
  count            = var.create_bootstrap_users ? 1 : 0
  group_object_id  = azuread_group.admins.object_id
  member_object_id = azuread_user.bootstrap_admin[0].object_id
}

resource "azuread_group_member" "bootstrap_test" {
  count            = var.create_bootstrap_users ? 1 : 0
  group_object_id  = azuread_group.readonly.object_id
  member_object_id = azuread_user.bootstrap_test[0].object_id
}

resource "azuread_group_member" "existing_admins" {
  for_each         = var.admin_object_ids
  group_object_id  = azuread_group.admins.object_id
  member_object_id = each.value
}

resource "azuread_group_member" "existing_contributors" {
  for_each         = var.contributor_object_ids
  group_object_id  = azuread_group.contributors.object_id
  member_object_id = each.value
}

resource "azuread_group_member" "existing_readers" {
  for_each         = var.reader_object_ids
  group_object_id  = azuread_group.readonly.object_id
  member_object_id = each.value
}

locals {
  groups = {
    admins       = { role = "Owner", principal = azuread_group.admins.object_id }
    contributors = { role = "Contributor", principal = azuread_group.contributors.object_id }
    reviewers    = { role = "Reader", principal = azuread_group.reviewers.object_id }
    readonly     = { role = "Reader", principal = azuread_group.readonly.object_id }
    it_ops       = { role = "User Access Administrator", principal = azuread_group.it_ops.object_id }
  }

  role_assignments = {
    for item in setproduct(keys(var.resource_group_ids), keys(local.groups)) :
    "${item[1]}-${item[0]}" => {
      scope     = var.resource_group_ids[item[0]]
      role      = local.groups[item[1]].role
      principal = local.groups[item[1]].principal
    }
  }
}

resource "azurerm_role_assignment" "this" {
  for_each             = local.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role
  principal_id         = each.value.principal
}

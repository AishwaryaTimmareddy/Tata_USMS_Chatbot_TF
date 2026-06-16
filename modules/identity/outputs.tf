output "app_identity_id" { value = azurerm_user_assigned_identity.app.id }
output "app_identity_client_id" { value = azurerm_user_assigned_identity.app.client_id }
output "app_identity_principal_id" { value = azurerm_user_assigned_identity.app.principal_id }
output "function_identity_id" { value = azurerm_user_assigned_identity.function.id }
output "function_identity_client_id" { value = azurerm_user_assigned_identity.function.client_id }
output "function_identity_principal_id" { value = azurerm_user_assigned_identity.function.principal_id }
output "admin_group_object_id" { value = azuread_group.admins.object_id }
output "contributor_group_object_id" { value = azuread_group.contributors.object_id }
output "reviewer_group_object_id" { value = azuread_group.reviewers.object_id }
output "readonly_group_object_id" { value = azuread_group.readonly.object_id }
output "it_ops_group_object_id" { value = azuread_group.it_ops.object_id }
output "bootstrap_admin_upn" {
  value = try(azuread_user.bootstrap_admin[0].user_principal_name, null)
}
output "bootstrap_admin_initial_password" {
  value     = try(random_password.bootstrap_admin[0].result, null)
  sensitive = true
}
output "bootstrap_test_upn" {
  value = try(azuread_user.bootstrap_test[0].user_principal_name, null)
}
output "bootstrap_test_initial_password" {
  value     = try(random_password.bootstrap_test[0].result, null)
  sensitive = true
}

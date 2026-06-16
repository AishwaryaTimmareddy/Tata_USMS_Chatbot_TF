output "policy_assignment_ids" {
  value = {
    for key, assignment in azurerm_resource_group_policy_assignment.this : key => assignment.id
  }
}

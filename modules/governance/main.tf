resource "azurerm_policy_definition" "required_tag" {
  name         = "aichatbot-require-resource-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "AIChatbot require mandatory resource tag"
  parameters = jsonencode({
    tagName = { type = "String" }
  })
  policy_rule = jsonencode({
    if = {
      field  = "[concat('tags[', parameters('tagName'), ']')]"
      exists = "false"
    }
    then = { effect = "deny" }
  })
}

resource "azurerm_policy_set_definition" "this" {
  name         = "aichatbot-prod-baseline"
  policy_type  = "Custom"
  display_name = "AIChatbot Production Baseline"

  dynamic "policy_definition_reference" {
    for_each = var.required_tags
    content {
      policy_definition_id = azurerm_policy_definition.required_tag.id
      reference_id         = "Require${replace(policy_definition_reference.key, " ", "")}"
      parameter_values = jsonencode({
        tagName = { value = policy_definition_reference.key }
      })
    }
  }
}

resource "azurerm_resource_group_policy_assignment" "this" {
  for_each             = var.resource_group_ids
  name                 = "aichatbot-prod-baseline"
  resource_group_id    = each.value
  policy_definition_id = azurerm_policy_set_definition.this.id
  display_name         = "AIChatbot Production Baseline - ${each.key}"
  location             = var.location
  identity { type = "SystemAssigned" }
}

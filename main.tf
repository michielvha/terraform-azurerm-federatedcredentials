resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  count               = var.type_is_user_assigned_identity ? 1 : 0
  location            = var.resource_group.location
  name                = local.user_assigned_identity_name
  resource_group_name = var.resource_group.name
  tags = merge(var.resource_group.tags, var.custom_tags, {
    managed-by = "terraform"
  })
}

resource "azurerm_federated_identity_credential" "federated_identity_credentials" {
  for_each            = toset(local.all_subjects)
  parent_id           = azurerm_user_assigned_identity.user_assigned_identity[0].id
  audience            = [var.audience]
  name                = replace(each.value, ":", "_")
  resource_group_name = var.resource_group.name
  issuer              = var.oidc_issuer_url
  subject             = each.value
}
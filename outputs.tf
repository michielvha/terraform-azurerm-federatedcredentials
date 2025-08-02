output "object_id" {
  value = azurerm_user_assigned_identity.user_assigned_identity[0].principal_id
}
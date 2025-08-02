locals {
  user_assigned_identity_name = "${var.base_resource_name}-${var.purpose}-umi"
  service_account_subjects    = [for sa in var.service_accounts : "system:serviceaccount:${sa.namespace}:${sa.name}"]
  all_subjects               = concat(local.service_account_subjects, var.custom_subjects)
}

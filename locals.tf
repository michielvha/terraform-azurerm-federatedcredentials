locals {
  user_assigned_identity_name = "${var.base_resource_name}-${var.purpose}-umi"
  subject                     = var.subject != "" ? var.subject : "system:serviceaccount:${var.service_account.namespace}:${var.service_account.name}"
  extra_service_accounts      = [for sa in var.extra_service_accounts : "system:serviceaccount:${sa.namespace}:${sa.name}"]
  extra_subjects = [for subject in concat(var.extra_subjects, local.extra_service_accounts) : subject]
}


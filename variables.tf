variable "base_resource_name" {
  type = string
  description = "The base name for resources, e.g. 'myapp'"
}

variable "purpose" {
  type = string
    description = "The purpose of the resources, e.g. 'keyvault-access'"
}

variable "service_accounts" {
  type = list(object({
    name      = string
    namespace = string
  }))
  description = "List of Kubernetes service accounts to create federated credentials for"
  default     = []
}

variable "custom_subjects" {
  type        = list(string)
  default     = []
  description = "Custom subject strings (use this for advanced scenarios or non-standard subjects)"
}

variable "audience" {
  type    = string
  default = "api://AzureADTokenExchange"
  description = "The audience for the federated identity credential"
}

variable "type_is_user_assigned_identity" {
  type    = bool
  default = true
  description = "If true, create a user-assigned managed identity; if false, use an existing identity (not implemented yet)"
}

variable "oidc_issuer_url" {
  type = string
  description = "The OIDC issuer URL from the AKS cluster"
}

variable "resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
    tags     = map(string)
  })
    description = "The resource group where resources will be created"
}

variable "custom_tags" {
  type        = map(string)
  default     = null
  description = "Additional tags for resources"
}
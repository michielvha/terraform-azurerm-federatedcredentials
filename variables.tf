variable "base_resource_name" {
  type = string
}

variable "purpose" {
  type = string
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
}

variable "type_is_user_assigned_identity" {
  type    = bool
  default = true
}

variable "oidc_issuer_url" {
  type = string
}

variable "resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
    tags     = map(string)
  })
}

variable "custom_tags" {
  type        = map(string)
  default     = null
  description = "Additional tags for resources"
}
variable "base_resource_name" {
  type = string
}

variable "purpose" {
  type = string
}

variable "subject" {
  type    = string
  default = ""
}

variable "service_account" {
  type = object({
    name      = string
    namespace = string
  })
  default = null
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
  description = "Additional tags for Engie"
}

variable "extra_subjects" {
  type    = list(string)
  default = []
}

variable "extra_service_accounts" {
  type = list(object({
    name      = string
    namespace = string
  }))
  default = []
}
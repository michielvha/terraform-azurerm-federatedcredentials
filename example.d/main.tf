data "azurerm_resource_group" "resourcegroup" {
  name = "rg-name"
}

module "federated_credentials" {
  source = "../"

  base_resource_name = "myapp"
  purpose            = "workload-identity"
  oidc_issuer_url    = "https://your-aks-cluster-oidc-issuer-url"
  resource_group     = data.azurerm_resource_group.resourcegroup

  service_accounts = [
    {
      name      = "app-service-account"
      namespace = "production"
    }
  ]

  custom_subjects = [
    "system:serviceaccount:custom-namespace:special-service-account"
  ]
}


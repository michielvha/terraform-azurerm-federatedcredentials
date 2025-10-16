module "resource_group" {
  source = "https://github.com/michielvha/terraform-azurerm-resourcegroup.git?ref=main"

  location    = "westeurope"
  project     = "app"
}

module "federated_credentials" {
  source = "../"

  base_resource_name = "myapp"
  purpose            = "workload-identity"
  oidc_issuer_url    = "https://your-aks-cluster-oidc-issuer-url"
  resource_group     = module.resource_group.resource_group

  service_accounts = [
    {
      name      = "app-service-account"
      namespace = "production"
    },
    {
      name      = "app-service-account-2"
      namespace = "production"
    }
  ]

  // only used in advanced scenarios
  custom_subjects = [
    "system:serviceaccount:custom-namespace:special-service-account"
  ]
}


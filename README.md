# Azure Federated Credentials Terraform Module

This Terraform module creates an Azure User Assigned Identity with Federated Identity Credentials, enabling secure authentication between Kubernetes service accounts and Azure resources using OpenID Connect (OIDC).

## Overview

The module simplifies the setup of workload identity federation between Azure and Kubernetes clusters. It creates:

- An Azure User Assigned Identity
- Federated Identity Credentials that trust Kubernetes service accounts
- Support for multiple service accounts through additional subjects

This enables Kubernetes pods to authenticate to Azure services without storing long-lived secrets, following Azure's recommended security practices for workload identity.

## Usage

### Basic Usage

```hcl
data "azurerm_resource_group" "resourcegroup" {
  name = "rg-name"
}

module "federated_credentials" {
  source = "./path-to-this-module"

  base_resource_name = "myapp"
  purpose           = "workload-identity"
  oidc_issuer_url   = "https://your-aks-cluster-oidc-issuer-url"
  resource_group    = data.azurerm_resource_group.resourcegroup
  
  service_accounts = [
    {
      name      = "my-service-account"
      namespace = "default"
    }
  ]
}
```

### Advanced Usage with Custom Subjects

```hcl
data "azurerm_resource_group" "resourcegroup" {
  name = "rg-name"
}

module "federated_credentials" {
  source = "./path-to-this-module"

  base_resource_name = "myapp"
  purpose           = "custom-identity"
  oidc_issuer_url   = "https://your-aks-cluster-oidc-issuer-url"
  resource_group    = data.azurerm_resource_group.resourcegroup
  
  service_accounts = [
    {
      name      = "app-service-account"
      namespace = "production"
    }
  ]
  
  custom_subjects = [
    "system:serviceaccount:custom-namespace:special-service-account",
    "custom:identity:some-other-pattern"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| base_resource_name | Base name for the resources | `string` | n/a | yes |
| purpose | Purpose identifier for the identity | `string` | n/a | yes |
| resource_group | Resource group object containing id, name, location, and tags | `object` | n/a | yes |
| oidc_issuer_url | OIDC issuer URL from your Kubernetes cluster | `string` | n/a | yes |
| service_accounts | List of Kubernetes service accounts to create federated credentials for | `list(object({ name = string, namespace = string }))` | `[]` | no |
| custom_subjects | Custom subject strings (use this for advanced scenarios or non-standard subjects) | `list(string)` | `[]` | no |
| audience | Token audience for federated credentials | `string` | `"api://AzureADTokenExchange"` | no |
| type_is_user_assigned_identity | Whether to create a user assigned identity | `bool` | `true` | no |
| custom_tags | Additional tags to apply to resources | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| object_id | The principal ID of the created User Assigned Identity |

## Prerequisites

- Azure Kubernetes Service (AKS) cluster with OIDC issuer enabled
- Terraform >= 0.13
- Azure provider configured

## Getting the OIDC Issuer URL

For AKS clusters, you can get the OIDC issuer URL using:

```bash
az aks show --resource-group <resource-group> --name <cluster-name> --query "oidcIssuerProfile.issuerUrl" -o tsv
```

## Kubernetes Configuration

After creating the federated credentials, configure your Kubernetes service account:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
  namespace: default
  annotations:
    azure.workload.identity/client-id: <user-assigned-identity-client-id>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    metadata:
      labels:
        azure.workload.identity/use: "true"
    spec:
      serviceAccountName: my-service-account
      # ...
```

<!-- BEGIN_TF_DOCS -->
# Azure Federated Credentials Terraform Module

This Terraform module creates an Azure User Assigned Identity with Federated Identity Credentials, enabling secure authentication between Kubernetes service accounts and Azure resources using OpenID Connect (OIDC).

## Overview

The module simplifies the setup of workload identity federation between Azure and Kubernetes clusters. It creates:

- An Azure User Assigned Identity
- Federated Identity Credentials that trust Kubernetes service accounts
- Support for multiple service accounts through additional subjects

This enables Kubernetes pods to authenticate to Azure services without storing long-lived secrets, following Azure's recommended security practices for workload identity.

## Usage

See the [example.d](./example.d/main.tf) directory for complete usage examples.

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
    azure.workload.identity/tenant-id: <user-assigned-identity-tenant-id>
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

## Prerequisites

- Azure Kubernetes Service (AKS) cluster with OIDC issuer enabled
- Terraform >= 0.13
- Azure provider configured

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0.0,<5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=4.0.0,<5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.federated_identity_credentials](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_user_assigned_identity.user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audience"></a> [audience](#input\_audience) | The audience for the federated identity credential | `string` | `"api://AzureADTokenExchange"` | no |
| <a name="input_base_resource_name"></a> [base\_resource\_name](#input\_base\_resource\_name) | The base name for resources, e.g. 'myapp' | `string` | n/a | yes |
| <a name="input_custom_subjects"></a> [custom\_subjects](#input\_custom\_subjects) | Custom subject strings (use this for advanced scenarios or non-standard subjects) | `list(string)` | `[]` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Additional tags for resources | `map(string)` | `null` | no |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The OIDC issuer URL from the AKS cluster | `string` | n/a | yes |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | The purpose of the resources, e.g. 'keyvault-access' | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The resource group where resources will be created | <pre>object({<br/>    id       = string<br/>    name     = string<br/>    location = string<br/>    tags     = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | List of Kubernetes service accounts to create federated credentials for | <pre>list(object({<br/>    name      = string<br/>    namespace = string<br/>  }))</pre> | `[]` | no |
| <a name="input_type_is_user_assigned_identity"></a> [type\_is\_user\_assigned\_identity](#input\_type\_is\_user\_assigned\_identity) | If true, create a user-assigned managed identity; if false, use an existing identity (not implemented yet) | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_object_id"></a> [object\_id](#output\_object\_id) | The Object ID of the User Assigned Identity. |
<!-- END_TF_DOCS -->


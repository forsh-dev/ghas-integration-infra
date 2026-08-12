# ghas-integration-infra

Infrastructure-as-code for deploying Azure resources to test [GitHub Advanced Security (GHAS) integration with Microsoft Defender for Cloud](https://learn.microsoft.com/en-us/azure/defender-for-cloud/github-advanced-security-deploy-sandbox).

## Resources

### Azure Container Registry (ACR)

Provisions an Azure Container Registry used as the sandbox environment for GHAS container image scanning.

**Template location:** `infra/acr/`

#### Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated (`az login`)
- An existing Azure Resource Group, or permission to create one

#### Deploy

1. Create a resource group (if needed):

   ```bash
   az group create --name rg-ghas-sandbox --location eastus
   ```

2. Deploy the ACR using the provided parameters file (edit `infra/acr/main.bicepparam` to set your ACR name and preferred region first):

   ```bash
   az deployment group create \
     --resource-group rg-ghas-sandbox \
     --template-file infra/acr/main.bicep \
     --parameters infra/acr/main.bicepparam
   ```

   Or deploy with inline parameter overrides:

   ```bash
   az deployment group create \
     --resource-group rg-ghas-sandbox \
     --template-file infra/acr/main.bicep \
     --parameters acrName=<your-unique-acr-name> location=eastus sku=Basic
   ```

3. After deployment, retrieve the login server:

   ```bash
   az acr show --name <your-unique-acr-name> --query loginServer --output tsv
   ```

#### Parameters

| Parameter        | Type   | Default          | Description                                              |
|------------------|--------|------------------|----------------------------------------------------------|
| `acrName`        | string | *(required)*     | Globally unique name for the ACR (5–50 alphanumeric)    |
| `location`       | string | resource group   | Azure region for the deployment                          |
| `sku`            | string | `Basic`          | ACR SKU: `Basic`, `Standard`, or `Premium`              |
| `adminUserEnabled` | bool | `false`          | Enables the admin user account on the registry. Disabled by default; use RBAC instead. |
| `tags`           | object | sandbox tags     | Tags applied to the ACR resource                         |
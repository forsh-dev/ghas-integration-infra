@description('Name of the Azure Container Registry. Must be globally unique.')
@minLength(5)
@maxLength(50)
param acrName string

@description('Azure region for the ACR deployment.')
param location string = resourceGroup().location

@description('SKU for the Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Enable admin user for the ACR. Disabled by default; prefer RBAC with Azure AD (service principals or managed identities) for CI/CD access instead.')
param adminUserEnabled bool = false

@description('Tags to apply to all resources.')
param tags object = {
  environment: 'sandbox'
  purpose: 'ghas-integration'
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
  tags: tags
}

@description('The login server URL for the ACR.')
output loginServer string = acr.properties.loginServer

@description('The resource ID of the ACR.')
output acrResourceId string = acr.id

@description('The name of the ACR.')
output acrName string = acr.name

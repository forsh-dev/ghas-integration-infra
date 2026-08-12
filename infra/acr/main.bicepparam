using './main.bicep'

param acrName = 'acrghassandbox'
param location = 'eastus'
param sku = 'Basic'
param adminUserEnabled = false
param tags = {
  environment: 'sandbox'
  purpose: 'ghas-integration'
}

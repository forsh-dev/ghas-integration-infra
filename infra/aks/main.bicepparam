using './main.bicep'

param clusterName = 'aks-ghas-sandbox'
param location = 'swedencentral'
param acrName = 'acrghassandbox'
param kubernetesVersion = '1.35'
param nodeVmSize = 'Standard_D2s_v3'
param nodeCount = 2
param tags = {
  environment: 'sandbox'
  purpose: 'ghas-integration'
}

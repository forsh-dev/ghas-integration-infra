@description('Name of the AKS cluster.')
param clusterName string

@description('Azure region for the AKS deployment.')
param location string = resourceGroup().location

@description('Name of the existing ACR in this resource group to grant pull access.')
param acrName string

@description('Kubernetes version.')
param kubernetesVersion string

@description('VM size for the system node pool.')
param nodeVmSize string = 'Standard_D2s_v3'

@description('Number of nodes in the system node pool.')
@minValue(1)
@maxValue(10)
param nodeCount int = 2

@description('Tags to apply to all resources.')
param tags object = {
  environment: 'sandbox'
  purpose: 'ghas-integration'
}

// AcrPull built-in role definition ID
var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'system'
        count: nodeCount
        vmSize: nodeVmSize
        mode: 'System'
        osType: 'Linux'
      }
    ]
  }
  tags: tags
}

// Allow the AKS kubelet identity to pull images from the ACR
resource acrPullAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, aks.id, acrPullRoleId)
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    principalId: aks.properties.identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the AKS cluster.')
output clusterName string = aks.name

@description('The FQDN of the AKS API server.')
output apiServerFqdn string = aks.properties.fqdn

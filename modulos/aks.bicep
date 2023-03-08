param appName string

@allowed([
  'dev'
  'hml'
  'qa'
  'prd'
  'preprd'
])
param environment string
param clusterNUm string

var clusterName = 'aks-${appName}-${environment}-${clusterNUm}'


@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 30

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'standard_d2s_v3'

@description('User name for the Linux Virtual Machines.')
param adminUsername string

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string

param subnetid string

param appgatewayid string

resource aks 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: '${clusterName}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        vnetSubnetID: subnetid
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
          enabled: false
      }
      azurepolicy: {
          enabled: false
      }
      httpApplicationRouting: {
          enabled: false
      }
      ingressApplicationGateway: {
          enabled: true
          config: {
              applicationGatewayId: appgatewayid
              effectiveApplicationGatewayId: appgatewayid
          }
      }
    }    
  }
}

output controlPlaneFQDN string = aks.properties.fqdn

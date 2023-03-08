@description('Specifies the name of the key vault.')
param appName string

@allowed([
  'dev'
  'hml'
  'qa'
  'prd'
  'preprd'
])
param environment string

param location string = resourceGroup().location

param enabledForDeployment bool = false
param enabledForDiskEncryption bool = false
param enabledForTemplateDeployment bool = false
param tenantId string = subscription().tenantId
param objectId string
param keysPermissions array = [
  'list'
]

param secretsPermissions array = [
  'list'
]

@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

param subnetID string 



var keyVaultName = 'akv-${appName}-${environment}'

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: [
        {
          id: subnetID
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }    
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
  }
}

output akvid string = kv.id

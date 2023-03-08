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
param resourcetype string
var ipName = 'ip-${resourcetype}-${appName}-${environment}-${clusterNUm}'

param location string = resourceGroup().location



resource publicip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: ipName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

output publicIpName string = publicip.name
output publicIpID string = publicip.id

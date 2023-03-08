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

var vnetName = 'vnet-${appName}-${environment}-${clusterNUm}'
param location string = resourceGroup().location
param addressprefix string = '10.224.0.0/12'

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressprefix
      ]
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

output vnetid string = vnet.id
output vnetname string = vnet.name

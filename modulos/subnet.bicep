param vnetname string
param addessprefix string 
param subnetname string

// resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
//   name: vnetname
// }

resource vnet_subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  // parent: vnet
  name: '${vnetname}/${subnetname}'
  properties: {
    addressPrefix: addessprefix
    serviceEndpoints: [
      {
          service: 'Microsoft.KeyVault'
          locations: [
              '*'
          ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output subnetid string = vnet_subnet.id

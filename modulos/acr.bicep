param appName string

@allowed([
  'dev'
  'hml'
  'qa'
  'prd'
  'preprd'
  'demo'
])
param environment string
param clusterNUm string

var acrName = 'acr${appName}${environment}${clusterNUm}'


@description('Provide a location for the registry.')
param location string = resourceGroup().location

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Standard'

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: false
  }
}


output loginServer string = acrResource.properties.loginServer

output acrid string = acrResource.id

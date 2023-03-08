param appName string

@allowed([
  'dev'
  'hml'
  'qa'
  'prd'
  'preprd'
])
param environment string
param appNUm string

var webSiteName = 'wapp-${appName}-${environment}-${appNUm}'
var appServicePlanName = 'svcplan-${appName}-${environment}-${appNUm}'


@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@allowed([
    'B1'
    'F1'
])
param sku string = 'B1' 
param linuxFxVersion string = 'DOTNETCORE|7.0'


resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}


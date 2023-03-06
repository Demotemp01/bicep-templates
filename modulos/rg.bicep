targetScope = 'subscription'
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
param kindRG string

@allowed([
  'brazilsouth'
])
param region string

var rgname = 'rg-${kindRG}-${appName}-${environment}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgname
  location: region
}

output rgid string = rg.id
output rgname string = rg.name

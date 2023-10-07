targetScope = 'subscription' // tenant', 'managementGroup', 'subscription', 'resourceGroup'

param namePrefix string
param resourceGroupName string

@secure()
param password string

var username = 'RootAdmin'
var vmName = '${namePrefix}-vm'

//create the vnet
module vnet_generic '../modules/vnet.bicep' = {
  name: '${vmName}-vnet'
  scope: resourceGroup(resourceGroupName)
  params: {
    namePrefix: '${namePrefix}'
  }
}

// Bring in the nic
module nic '../modules/vm-nic.bicep' = {
  name: '${vmName}-nic'
  scope: resourceGroup(resourceGroupName)
  params: {
    namePrefix: '${vmName}'
    subnetId: vnet_generic.outputs.subnetId
  }
}

module vm '../modules/vm.bicep' = {
  name: '${vmName}'
  scope: resourceGroup(resourceGroupName)
  params: {
    namePrefix: '${vmName}'
    subnetId: vnet_generic.outputs.subnetId
    username: username
    password: password
    nicId: nic.outputs.nicId
  }
}

output vmName string = vm.name

param namePrefix string
param subnetId string
param username string
param password string
param location string = resourceGroup().location
param ubuntuOsVersion string = '18.04-LTS'
param osDiskType string = 'Standard_LRS'
param vmSize string = 'Standard_B1s'
param nicId string

var vmName = '${namePrefix}'

// Create the vm
resource vm_small 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: vmName
  location: location
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: ubuntuOsVersion
        version: 'latest'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: username
      adminPassword: password
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
  }
}

output id string = vm_small.id

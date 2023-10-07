@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

param CustomerID string

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'Trial'
  'Small'
  'Medium'
  'Large'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(14)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

var StorageAccountName = 'sa${CustomerID}${resourceNameSuffix}'
var containerName = 'cont${CustomerID}'

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  Dev: {
    StorageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
  }
  QA: {
    StorageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
  }
  Staging: {
    StorageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
    }
  }
  Prod: {
    StorageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
    }
  }
}

resource StorageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: StorageAccountName
  location: location
  kind: 'StorageV2'
  sku: environmentConfigurationMap[environmentType].StorageAccount.sku
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${StorageAccount.name}/default/${containerName}'
}

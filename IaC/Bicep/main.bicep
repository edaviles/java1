@description('Which Pricing tier our App Service Plan to')
param skuName string = 'S1'

@description('How many instances of our app service will be scaled out to')
param skuCapacity int = 1

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name that will be used to build associated artifacts')
param appName string = uniqueString(resourceGroup().id)

@description('The runtime stack of web app')
param linuxFxVersion string = 'TOMCAT|9.0-jre8'

resource serverfarms_ASP_pocjavazone_8c82_name_resource 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'oasp-${appName}'
  location: location
  sku: {
    name: skuName
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: skuCapacity
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_oa921309128_name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: 'oa-${appName}'
  location: location
  kind: 'app,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${appName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${appName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_pocjavazone_8c82_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: linuxFxVersion
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_oa921309128_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_oa921309128_name_resource
  name: 'ftp'
  location: location
  properties: {
    allow: true
  }
}

resource sites_oa921309128_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_oa921309128_name_resource
  name: 'scm'
  location: location
  properties: {
    allow: true
  }
}

resource sites_oa921309128_name_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: sites_oa921309128_name_resource
  name: 'web'
  location: location
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'TOMCAT|9.0-jre8'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$oa921309128'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_oa921309128_name_sites_oa921309128_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: sites_oa921309128_name_resource
  name: 'oa-${appName}.azurewebsites.net'
  location: location
  properties: {
    siteName: 'oa-${appName}'
    hostNameType: 'Verified'
  }
}

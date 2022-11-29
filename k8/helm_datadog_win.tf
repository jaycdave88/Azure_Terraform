resource "helm_release" "datadog_agent_win" {
  name       = "datadog-agent-win"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  #leave blank for latest
  version    = ""

  # targetSystem -- Target OS for this deployment (possible values: linux, windows)
  set {
    name          = "targetSystem"
    value         = "windows"
  }

  # datadog.apiKey -- Your Datadog API key
  ## ref: https://app.datadoghq.com/account/settings#agent/kubernetes
  set_sensitive {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  # datadog.kubelet.tlsVerify -- Toggle kubelet TLS verification
  # @default -- true
  set {
      name  = "datadog.kubelet.tlsVerify"
      value = false
  }

  # datadog.dogstatsd.useHostPort -- Sets the hostPort to the same value of the container port
  ## Needs to be used for sending custom metrics.
  ## The ports need to be available on all hosts.
  ##
  ## WARNING: Make sure that hosts using this are properly firewalled otherwise
  ## metrics and traces are accepted from any host able to connect to this host.
  ## @default -- false
  set {
    name  = "datadog.dogstatsd.useHostPort"
    value = var.statsd_host_port
  }

  # datadog.dogstatsd.nonLocalTraffic -- Enable this to make each node accept non-local statsd traffic (from outside of the pod)
  ## ref: https://github.com/DataDog/docker-dd-agent#environment-variables
  set {
    name  = "datadog.dogstatsd.nonLocalTraffic"
    value = true
  }

  # datadog.logs.enabled -- Enables this to activate Datadog Agent log collection
  ## ref: https://docs.datadoghq.com/agent/basic_agent_usage/kubernetes/#log-collection-setup
  set {
    name  = "datadog.logs.enabled"
    value = true
  }

  # datadog.logs.containerCollectAll -- Enable this to allow log collection
  # for all containers
  ## ref: https://docs.datadoghq.com/agent/basic_agent_usage/kubernetes/#log-collection-setup
  set {
    name  = "datadog.logs.containerCollectAll"
    value = true
  }

  ## ref: https://docs.datadoghq.com/agent/logs/advanced_log_collection/?tab=configurationfile#automatic-multi-line-aggregation
  set {
      name  = "datadog.logs.autoMultiLineDetection"
      value = true
  }

  # datadog.apm.portEnabled -- Enable APM over TCP communication
  # (port 8126 by default)
  ## ref: https://docs.datadoghq.com/agent/kubernetes/apm/
  set {
      name  = "datadog.apm.portEnabled"
      value = true
  }

  # datadog.processAgent.processCollection -- Set this to true to enable
  # process collection in process monitoring agent
  ## Requires processAgent.enabled to be set to true to have any effect
  set {
      name  = "datadog.processAgent.processCollection"
      value = true
  }

  # datadog.networkMonitoring.enabled -- Enable network performance monitoring
  set {
    name  = "datadog.networkMonitoring.enabled"
    value = true
  }

  # datadog.leaderElection -- Enables leader election mechanism for event collection
  set {
    name  = "datadog.leaderElection"
    value = false
  }

  ## This is the Datadog Cluster Agent implementation that handles cluster-wide
  ## metrics more cleanly, separates concerns for better rbac, and implements
  ## the external metrics API so you can autoscale HPAs based on datadog metrics
  ## ref: https://docs.datadoghq.com/agent/kubernetes/cluster/
  set {
    name    = "clusterAgent.enabled"
    value   = false
  }

  # Enable the metricsProvider to be able to scale based on metrics in Datadog
  set {
    name  = "datadog.metricsProvider.enabled"
    value = true
  }

  # existingClusterAgent.join -- set this to true if you want the agents deployed by this chart to
  # connect to a Cluster Agent deployed independently
  set {
    name  = "existingClusterAgent.join"
    value = true
  }

  # existingClusterAgent.serviceName -- Existing service name to use for reaching the external Cluster Agent
  set {
    name   = "existingClusterAgent.serviceName"
    value  = "datadog-agent-cluster-agent"
  }

  # existingClusterAgent.tokenSecretName -- Existing secret name to use for external Cluster Agent token
  set {
    name  = "existingClusterAgent.tokenSecretName"
    value = "datadog-agent-cluster-agent"
  }

  # agents.image.tagSuffix -- Suffix to append to Agent tag
  ## Ex:
  ##  jmx        to enable jmx fetch collection
  ##  servercore to get Windows images based on servercore
  set {
    name  = "agents.image.tagSuffix"
    value = var.jmx_datadog_agent
  }
}

resource "helm_release" "datadog_agent" {
  name       = "datadog-agent"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  #leave blank for latest
  version    = ""
  namespace  = "default"

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

  # datadog.systemProbe.enableTCPQueueLength -- Enable the TCP queue length eBPF-based check
  set {
    name  = "datadog.systemProbe.enableTCPQueueLength"
    value = true
  }

  # datadog.systemProbe.enableOOMKill -- Enable the OOM kill eBPF-based check
  set {
    name  = "datadog.systemProbe.enableOOMKill"
    value = true
  }

  # datadog.networkMonitoring.enabled -- Enable network performance monitoring
  set {
    name  = "datadog.networkMonitoring.enabled"
    value = true
  }

  # datadog.securityAgent.compliance.enabled -- Set to true to enable Cloud Security Posture Management (CSPM)
  set {
    name  = "datadog.securityAgent.compliance.enabled"
    value = true
  }

  # datadog.securityAgent.runtime.enabled -- Set to true to enable Cloud Workload Security (CWS)
  set {
    name  = "datadog.securityAgent.runtime.enabled"
    value = true
  }

  # datadog.securityAgent.runtime.fimEnabled -- Set to true to enable Cloud Workload Security (CWS) File Integrity Monitoring
  set {
    name  = "datadog.securityAgent.fimEnabled.enabled"
    value = true
  }

  # datadog.securityAgent.runtime.network.enabled -- Set to true to enable the collection of CWS network events
  set {
    name  = "datadog.securityAgent.network.enabled"
    value = true
  }

  # Enable the metricsProvider to be able to scale based on metrics in Datadog
  set {
    name  = "datadog.clusterAgent.metricsProvider.enabled"
    value = true
  }

  # agents.image.tagSuffix -- Suffix to append to Agent tag
  ## Ex:
  ##  jmx        to enable jmx fetch collection
  ##  servercore to get Windows images based on servercore
  set {
    name  = "agents.image.tagSuffix"
    value = var.jmx_datadog_agent
  }

  depends_on = [azurerm_kubernetes_cluster.control_plane]
}

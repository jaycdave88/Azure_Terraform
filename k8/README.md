Create AKS Cluster with Datadog Daemonset Deployed
--

Files
-

1) helm_datadog.tf - Datadog agent configuration (via helm values) for
values that are different from the default.  Some notes:  

* version - leave empty to get the latest chart  
* var.statsd_host_port - set in variables.tf (stdin) or in a tfvars file. True
  will allow for JVM metrics in K8  
* Logs are turned on with autoMultiLineDetection  
* APM on  
* Process collection on  
* System Probe checks on  
* NPM on  
* Security features (compliance, runtime, fim, network) on  
* Metrics provider for scaling on  
* Ability to set jmx for agent tag for Java tracing etc.  

2) main.tf - cluster config  

3) variables.tf - variables (optional) if you don't want to enter all the
variables manually usind stdin, you can set them in a terraform.tfvars file in
the same directory.  The possible keys are:  

subscription_id = ""  
client_id       = ""  
client_secret   = ""  
tenant_id       = ""  
location        = ""  
cluster_name   = ""  
dns_prefix     = ""  
datadog_api_key = ""  
statsd_host_port = ""  
jmx_datadog_agent = ""  

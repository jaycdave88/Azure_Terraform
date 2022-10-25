terraform { 
  required_providers {
     azurerm = "=3.11.0"
  }
  required_version = "=1.1.9"
}

data "azurerm_kubernetes_cluster" "credentials" {
    name                = azurerm_kubernetes_cluster.aks_cluster.name
    resource_group_name = azurerm_resource_group.rg.name 
}

provider "azurerm" {
    features {} 
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }
}

variable location {}
variable cluster_name {}
variable dns_prefix {}
variable datadog_api_key {}
variable statsd_host_port {}
variable jmx_datadog_agent {}

variable subscription_id {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable client_id {
  description = "Enter Client ID for Applicaiton creation in Azure AD"
}

variable client_secret {
  description = "Enter Client secret for Applicaiton in Azure AD"
}

variable tenant_id {
  description = "Enter Tenant ID / Directory ID of your Azure AD"
}


provider "azurerm" {
    features {} 
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

provider "datadog"{
    api_key = "${var.datadog_api_key}"
    app_key = "${var.datadog_app_key}"
}

variable location {}
variable admin_username {}
variable admin_password {}

variable datadog_api_key {
  type        = string
  description = "Datadog API key. This can also be set via the DD_API_KEY environment variable"
}

variable datadog_app_key {
  type        = string
  description = "Datadog APP key. This can also be set via the DD_APP_KEY environment variable"
}

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
provider "azurerm" {
    features {} 
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

variable location {}
variable admin_username {}
variable admin_password {}
variable scfile {}
variable pemfile {}

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
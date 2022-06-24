# Azure_Terraform
The purpose of this repo is to provide configuration options for quickly standing up Azure compute resources. 

## Getting Started
* Create a `linux_vm/terraform.tfvars` within the same level as the `linux/main.tf`

* Provide the following keys & corresponding values: 
   * `subscription_id` = <AZURE_SUBSCRIPTION_ID>
   * `client_id`       = <AZURE_SERVICE_PRINCIPAL_APP_ID>
   * `client_secret`   = <AZURE_SERVICE_PRINCIPAL_PASSWORD>
   * `tenant_id`       = <AZURE_SERVICE_PRINCIPAL_TENANT_ID>
   * `datadog_api_key` = <DD_API_KEY>
   * `datadog_app_key` = <DD_APP_KEY>
   * `location`        = <AVAILABILITY_ZONE>
   * `admin_username` = <ADMIN_USERNAME>
   * `admin_password` = <ADMIN_PASSWORD>
   
* Create a SSH key pair for access to the Linux VM. 
   * Run the following in on your local shell `ssh-keygen -m PEM -t rsa -b 4096` & update the value within the `terraform.tfvars` to point the created pub file. 
* Run `terraform init`, `terraform plan`, and `terraform apply`

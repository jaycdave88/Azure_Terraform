# Azure_Terraform
The purpose of this repo is to provide an automated solution for setting up the Datadog agent in various Azure resources. 

## Getting Started
* Create a `<DIR_NAME>/terraform.tfvars` within the same level as the `<DIR_NAME>/main.tf`

(Note: replace `<DIR_NAME>` with k8 for example).

This repo assumes you have already created an Azure service principal. More information on how to create a Azure service principal can be found [here](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli#1-create-a-service-principal).

* Provide the following keys & corresponding values: 
   * `subscription_id` = <AZURE_SUBSCRIPTION_ID>
   * `client_id`       = <AZURE_SERVICE_PRINCIPAL_APP_ID>
   * `client_secret`   = <AZURE_SERVICE_PRINCIPAL_PASSWORD>
   * `tenant_id`       = <AZURE_SERVICE_PRINCIPAL_TENANT_ID>
   * `datadog_api_key` = <DD_API_KEY>
   * `location`        = <AVAILABILITY_ZONE>

(Note: there are additional values that can be passed in, which depend on the Azure resources being created). 

### Linux VM: 
* Naivigate to `linux_vm` directory. 
* Create a SSH key pair for access to the Linux VM. 
   * Run the following in on your local shell `ssh-keygen -m PEM -t rsa -b 4096` & update the value within the `terraform.tfvars` to point the created pub file. 
* Apply the Terraform scripts:
   * `terraform init`
   * `terraform plan`
   * `terraform apply`
   * `terraform apply -destroy` can be used to remove the instance. 

### Windows VM:

* Navigate to `windows_vm` directory.
* In the `install-datadog.ps1` file replace `_API_KEY_HERE` with your organizatioin's Datadog API key.
* Apply the Terraform scripts: 
   * `terraform init`
   * `terraform plan`
   * `terraform apply`
   * `terraform apply -destroy` can be used to remove the instance. 

# Deploy Customer Workloads

This workflow deploys the following resources required for the customers BPC environment and Citrix Cloud environment:

* Configures DNS servers for customer vNet
* BPC App and Hana database server pairs for Dev, QAS, and Prod BPC environments as required
* Dev and Prod Citrix hosts to act as templates for Citrix MCS

## Technology Used

* GitHub as code repository and pipeline runner
* Terraform as Infrastructure as Code to provision Azure resources
* Packer to create golden images

## Steps

1. Create a new branch called feat/<customer_name> and copy template.yml and template folder in terraform and rename to customer name
2. Copy azuredeploy.tf, infrastructure.tf and locals.tf from the customers folder in Azure-Customer-Infrastructure and replace files here
3. Uncomment and fill in the BPC, Hana and VDA sections of locals.tf
4. Make sure all needed data sources are available in data.tf
5. Push completed code to repo and create a pull request to run checks and terraform plan, checking everything is correct
6. Merge to main to run terraform apply

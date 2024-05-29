# GitHub self-hosted runner automation

This repo contains all the resources needed to implement on-demend self-hosted GitHub runners in Azure.

* GitHub actions workflow to create a runner golden image needed for the automation
* Packer build template used with the workflow to create the image
* Bash shell script to configure the OS and install all required packages for the runner host image
* Service file for running the GibHub runner software
* Bash shell script used with the service to automate registering the runner with GitHub
* Bash shell script used with the service to automate the removal of the runner after use
* Azure Python runbook used to create runner VM's from golden packer image

## Usage

The following resources are required to implement this solution:

* Azure service principle for Packer to use in creation of resources in Azure for image building
* 


* use workflow to create a golden image for the runner
* Create an Azure Python workbook using the azure_runbook.py script
* Create an Azure logic app with a webhook and add the webhook to Github actions on the repos you wish to use the runner with
*  

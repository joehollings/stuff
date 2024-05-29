# Azure Citrix Automation

## Updating Machine Catalog Master Images after patching

Azure Workbook to update Machine Catalogs using Citrix REST API. The workbook is designed to run on a schedule after the template VM's have been patched. It uses the Citrix Customer ID and API Client ID to create a bearer token, then retrive the site ID needed to retrive the machine catalogs and master image information.

### Usage

* Create Citrix tenant, making note of the Citrix Customer ID
* Create a Client ID [See info here](https://developer-docs.citrix.com/en-us/citrix-cloud/citrix-cloud-api-overview/get-started-with-citrix-cloud-apis.html#:~:text=Create%20an%20API%20client%201%20In%20the%20Citrix,have%20been%20created%20successfully%20.%20...%20More%20items)
* Add a schedule to the Azure Runbook MC_Update in automation account owscs-aa-hub

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| ccId | Citrix Customer ID | `string` | `""` | yes |
| client_Id | Client ID | `string` | `""` | yes |

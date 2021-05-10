#!/bin/sh

# 
# This file deploys the Azure resources and assets needed to support
# the Connectivity monitor sample. Requires the Azure CLI to be in scope
# and logged in with appropriate permissions.
#

# Setup config vars
resource_group_name="PowerMonitorRG_1"
location="eastus"
storage_account_name="powermonitor050920211"
data_container_name="status"

# Create resource group
echo "Creating resource group.."
az group create -n $resource_group_name \
  -l $location \
  --only-show-errors

# Create storage account, enabled for static access
echo "Creating storage account.."
az storage account create -n $storage_account_name \
  -g $resource_group_name \
  -l $location \
  --sku Standard_LRS \
  --only-show-errors

# Enable static site hosting
echo "Configuring web container access.."
az storage blob service-properties update \
  --account-name $storage_account_name \
  --static-website \
  --index-document "default.html" \
  --only-show-errors

# Create the data upload container
echo "Creating data container.."
az storage container create \
  -n $data_container_name \
  --account-name $storage_account_name \
  -g $resource_group_name \
  --public-access container \
  --only-show-errors

# Enable CORS access (read-ony) to the data container
echo "Enabling read access to data container.."
az storage cors clear \
  --account-name $storage_account_name \
  --services b \
  --only-show-errors

az storage cors add \
  --methods GET OPTIONS \
  --origins "*" \
  --services b \
  --account-name $storage_account_name \
  --only-show-errors 

# Upload satic assets to $web container
echo "Uploading web app assets.."
az storage blob upload-batch \
  -d \$web \
  -s webapp \
  --account-name $storage_account_name \
  --only-show-errors \
  --no-progress

# Finished - get summary info
webendpoint=$(az storage account show -n $storage_account_name -g $resource_group_name | jq '.primaryEndpoints.web')
echo "Deployment complete - access site at: $webendpoint"
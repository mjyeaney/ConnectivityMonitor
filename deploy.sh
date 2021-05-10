#!/bin/sh

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
  --only-show-errors

# Upload satic assets to $web container
echo "Uploading web app assets.."
az storage blob upload \
  -n default.html \
  -c \$web \
  -f default.html \
  --account-name powermonitor050920211 \
  --only-show-errors \
  --no-progress

az storage blob upload \
  -n styles.css \
  -c \$web \
  -f styles.css \
  --account-name powermonitor050920211 \
  --only-show-errors \
  --no-progress

az storage blob upload \
  -n network-down.gif \
  -c \$web \
  -f network-down.gif \
  --account-name powermonitor050920211 \
  --only-show-errors \
  --no-progress

az storage blob upload \
  -n network-up.gif \
  -c \$web \
  -f network-up.gif \
  --account-name powermonitor050920211 \
  --only-show-errors \
  --no-progress

# Finished - get summary info
webendpoint=$(az storage account show -n powermonitor050920211 -g PowerMonitorRG_1 | jq '.primaryEndpoints.web')
echo "Deployment complete - access site at: $webendpoint"
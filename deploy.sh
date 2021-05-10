resource_group_name="PowerMonitorRG_1"
location="eastus"
storage_account_name="powermonitor050920211"
data_container_name="status"

# Create resource group
az group create -n $resource_group_name \
  -l $location \
  --only-show-errors

# Create storage account, enabled for static access
az storage account create -n $storage_account_name \
  -g $resource_group_name \
  -l $location \
  --sku Standard_LRS \
  --only-show-errors

# Enable static site hosting
az storage blob service-properties update \
  --account-name $storage_account_name \
  --static-website \
  --index-document "default.html" \
  --only-show-errors

# Create the data upload container
az storage container create \
  -n $data_container_name \
  --account-name $storage_account_name \
  -g $resource_group_name \
  --only-show-errors
#!/bin/bash

# Function app and storage account names must be unique.
export AZURE_STORAGE_ACCOUNT=dkcrawlstoragepremium
functionAppName=ckzscoringupdate
region=eastus2
pythonVersion=3.8 
shareName=crawlshare
directoryName=/
shareId=crawlshare$RANDOM
mountPath=/data

# Set the storage account key as an environment variable. 
export AZURE_STORAGE_KEY=$(az storage account keys list -g myResourceGroup -n $AZURE_STORAGE_ACCOUNT --query '[0].value' -o tsv)

# Create a serverless function app in the resource group.
az functionapp create \
  --name $functionAppName \
  --storage-account $AZURE_STORAGE_ACCOUNT \
  --consumption-plan-location $region \
  --resource-group myResourceGroup \
  --os-type Linux \
  --runtime python \
  --runtime-version $pythonVersion \
  --functions-version 2

az webapp config storage-account add \
  --resource-group myResourceGroup \
  --name $functionAppName \
  --custom-id $shareId \
  --storage-type AzureFiles \
  --share-name $shareName \
  --account-name $AZURE_STORAGE_ACCOUNT \
  --mount-path $mountPath \
  --access-key $AZURE_STORAGE_KEY

az webapp config storage-account list \
  --resource-group myResourceGroup \
  --name $functionAppName
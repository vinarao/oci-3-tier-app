#!/bin/bash
#
# This script provides a basic example of how to use the Network Security Group feature in the CLI.
# These variables must be defined by the user:
#   * TF_VAR_compartment_ocid: The OCID of the compartment that contains our resources, and is where we'll create the network security group 
#   * VCN_ID: The OCID of a VCN where we'll create the NSG
#   * VNIC_ID: The OCID of a VNIC which will belong to the NSG
#
# This script will demonstrate:
#   * Creating and getting information about a new Network Security Group (NSG)
#   * Adding security rules to the NSG
#   * Listing and adding VNICs that belong to an NSG
#
# This script uses jq (https://stedolan.github.io/jq/) for JSON querying of CLI output. 
# 
# Copyright (c) 2016, 2019, Oracle and/or its affiliates. All rights reserved.

#Populating the the 3 Tier App environment information 
echo "Please Deploy the 3Tier app using the Terraform Template below before executing this script 
echo "========================="
VCN_ID=$(oci network vcn list --compartment-id $TF_VAR_compartment_ocid --display-name 3TierNetwork| jq -r .data[0].id)
web_vm1=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name web_instance1| jq -r .data[0].id)
web_vm2=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name web_instance2| jq -r .data[0].id)
app_vm1=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name app_instance1| jq -r .data[0].id)
app_vm2=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name app_instance2| jq -r .data[0].id)
db_vm1=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name db_instance1| jq -r .data[0].id)
db_vm2=$(oci compute instance list --compartment-id $TF_VAR_compartment_ocid --display-name db_instance2| jq -r .data[0].id)
Web_VM1_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $web_vm1 | jq -r .data[0]'."vnic-id"')
Web_VM2_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $web_vm2 | jq -r .data[0]'."vnic-id"')
App_VM1_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $app_vm1 | jq -r .data[0]'."vnic-id"')
App_VM2_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $app_vm2 | jq -r .data[0]'."vnic-id"')
DB_VM1_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $db_vm1 | jq -r .data[0]'."vnic-id"')
DB_VM2_VNIC_ID=$(oci compute vnic-attachment list --compartment-id $TF_VAR_compartment_ocid --instance-id $db_vm2 | jq -r .data[0]'."vnic-id"')

# Create a new network security group
echo "Creating web network security group"
echo "========================="
oci network nsg create --compartment-id $TF_VAR_compartment_ocid --vcn-id $VCN_ID --display-name "web-nsg"

# List all network security groups (you may optionally filter by VCN OCID or exact display name); store id of the first returned NSG. 
echo "Listing network security groups"
echo "========================="
oci network nsg list --compartment-id $TF_VAR_compartment_ocid | jq -r .data[0].id
WEB_NSG=$(oci network nsg list --compartment-id $TF_VAR_compartment_ocid --display-name "web-nsg" |jq -r .data[0].id)


# Create a app network security for use in later configs
echo "Creating a app network security group"
echo "========================="
oci network nsg create --compartment-id $TF_VAR_compartment_ocid --vcn-id $VCN_ID --display-name "app-nsg"
APP_NSG=$(oci network nsg list --compartment-id $TF_VAR_compartment_ocid --display-name "app-nsg" | jq -r .data[0].id)

# Create a app network security for use in later configs
echo "Creating DB network security group"
echo "========================="
oci network nsg create --compartment-id $TF_VAR_compartment_ocid --vcn-id $VCN_ID --display-name "db-nsg"
oci network nsg list --compartment-id $TF_VAR_compartment_ocid 
DB_NSG=$(oci network nsg list --compartment-id $TF_VAR_compartment_ocid --display-name "db-nsg" | jq -r .data[0].id)

# Add a VNIC to the NSG
echo "Adding $Web_VM1_VNIC_ID to the network security group"
echo "========================="
cat /dev/null > web_nsg.json
echo ["$WEB_NSG"] > web_nsg.json
oci network vnic update --vnic-id $Web_VM1_VNIC_ID --nsg-ids file://web_nsg.json

# Add a VNIC to the NSG
echo "Adding $Web_VM2_VNIC_ID to the network security group"
echo "========================="
oci network vnic update --vnic-id $Web_VM2_VNIC_ID --nsg-ids file://web_nsg.json

# Add a VNIC to the NSG
echo "Adding $App_VM1_VNIC_ID to the network security group"
echo "========================="
cat /dev/null > app_nsg.json
echo ["$APP_NSG"] > app_nsg.json
oci network vnic update --vnic-id $App_VM1_VNIC_ID --nsg-ids file://app_nsg.json


# Add a VNIC to the NSG
echo "Adding $App_VM2_VNIC_ID to the network security group"
echo "========================="
oci network vnic update --vnic-id $App_VM2_VNIC_ID --nsg-ids file://app_nsg.json

# Add a VNIC to the NSG
echo "Adding $DB_VM1_VNIC_ID to the network security group"
echo "========================="
cat /dev/null > db_nsg.json
echo ["$DB_NSG"] > db_nsg.json
oci network vnic update --vnic-id $DB_VM1_VNIC_ID --nsg-ids file://db_nsg.json

#Update the Rule 
echo "Updating the NSG ID to the security rules 
tmp=$(mktemp)
jq '.[].destination="'"$APP_NSG"'"' app.json > "$tmp" && mv -f "$tmp" app.json
jq '.[].destination="'"$APP_NSG"'"' web.json > "$tmp" && mv "$tmp" web.json

# Add a VNIC to the NSG
echo "Adding $DB_VM2_VNIC_ID to the network security group"
echo "========================="
oci network vnic update --vnic-id $DB_VM2_VNIC_ID --nsg-ids file://db_nsg.json

# Add JSON to the NSG 

echo "Adding Web Security Rule to the network security group"
echo "========================="
oci network nsg rules add --nsg-id $WEB_NSG --security-rules file://web.json 

# Add JSON to the NSG
echo "Adding App Security Rule to the network security group"
echo "========================="
oci network nsg rules add --nsg-id $APP_NSG --security-rules file://app.json 

# Add JSON to the NSG
echo "Adding DB Security Rule to the network security group"
echo "========================="
oci network nsg rules add --nsg-id $DB_NSG --security-rules file://db.json 

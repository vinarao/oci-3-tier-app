#!/bin/bash
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
cat /dev/null > web_nsg.json
cat /dev/null > db_nsg.json
cat /dev/null > app_nsg.json
echo "Disassociate the NSG from the VNIC" 
oci network vnic update --vnic-id $App_VM1_VNIC_ID --nsg-ids file://empty.json 
oci network vnic update --vnic-id $App_VM2_VNIC_ID --nsg-ids file://empty.json 
oci network vnic update --vnic-id $Web_VM1_VNIC_ID --nsg-ids file://empty.json 
oci network vnic update --vnic-id $Web_VM2_VNIC_ID --nsg-ids file://empty.json 
oci network vnic update --vnic-id $DB_VM1_VNIC_ID --nsg-ids file://empty.json 
oci network vnic update --vnic-id $DB_VM2_VNIC_ID --nsg-ids file://empty.json 
echo "Delete the Web/App/DB NSG's from the VCN"
for vm in $(oci network nsg list --all --compartment-id $TF_VAR_compartment_ocid | jq -r .data[].id)
do
oci network nsg delete --nsg-id $vm
done


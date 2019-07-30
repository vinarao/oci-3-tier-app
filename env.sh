#!/usr/bin/env bash
#Enter Your Tenancy OCID
export TF_VAR_tenancy_ocid="Enter your tenancy OCID here"
#Enter Your User OCID
export TF_VAR_user_ocid="Enter your user OCID here"
#Enter Your Fingerprint
export TF_VAR_fingerprint="Enter your fingerprint here"

####Region
#Enter Your Region (Example: us-ashburn-1)
export TF_VAR_region="us-ashburn-1"

####Compute
#Enter the Image OCID
#export TF_VAR_image_ocid="ocid of the image(region specific)"
#Enter Shape for Instance (Example: VM.Standard2.1)
export TF_VAR_instance_shape="VM.Standard2.1"

###Key
#Enter Path to Your Private API Key
export TF_VAR_private_key_path="/Enter /the /path /to /private /PEM /key"
#Enter Path to Your Public SSH Key
export TF_VAR_ssh_public_key=$(cat /Enter /the /path /to /instance /ssh /public /key)
#Enter Path to Your Private SSH Key
export TF_VAR_ssh_authorized_private_key=$(cat /Enter /the /path /to /instance /ssh /private /key)


### Compartment
export TF_VAR_compartment_ocid="Enter your compartment OCID here"
export TF_VAR_public_key_path=/Enter /the /path /API /Public_PEM /key
export TF_VAR_private_key_path=/Enter /the /path /API /Private_PEM /key

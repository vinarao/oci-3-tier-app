<p align="center"> ### Deploying 3-Tier Application on OCI</p>

This is a terraform template to deploy a Higly available 3Tier Application on OCI. 
Front-end Tier is a OCI public loadbalancer 
App-Tier is a Python Flask Application 
Back-end Tier is based on Oracle DBaaS service

##### 3 Tier Architecture #######

![Alt text](https://bitbucket.aka.lgl.grungy.us/users/vinayrao/repos/terraform-script/browse/3_tier_web_app_oracle/.idea/3TierDB.png?raw=true "3 Tier Architecture")



### Prerequisites

* Please install Terraform and all the required Plugins to deploy the application 

### Updating the environment variable 

 Update env.sh with the environment variables applicable to your deployment tenancy.
 
 ** Follow this link to setup the API signing keys and gather all required information 
 ** https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm

```bash
#Enter Your Tenancy OCID
export TF_VAR_tenancy_ocid="Enter your tenancy OCID here"
#Enter Your User OCID
export TF_VAR_user_ocid="Enter your user OCID here"
#Enter Your Fingerprint
export TF_VAR_fingerprint="Enter your fingerprint here"
#Enter Your Region (Example: us-ashburn-1)
export TF_VAR_region="us-ashburn-1"
#Enter the Image OCID
export TF_VAR_image_ocid="ocid1.image.oc1.iad.aaaaaaaawufnve5jxze4xf7orejupw5iq3pms6cuadzjc7klojix6vmk42va"
#Enter Shape for Instance (Example: VM.Standard2.1)
export TF_VAR_instance_shape="VM.Standard2.1"
#Enter Path to Your Private API Key
export TF_VAR_private_key_path="/Enter /the /path /to /private /PEM /key"
#Enter Path to Your Public SSH Key
export TF_VAR_ssh_public_key=$(cat /Enter /the /path /to /instance /ssh /public /key)
#Enter Path to Your Private SSH Key
export TF_VAR_ssh_authorized_private_key=$(cat /Enter /the /path /to /instance /ssh /private /key)
```
Once you have update the environment variables. Please source the file 

```bash
. env.sh
``` 

### Deploying the Application 

Step 1: Change the directory to 3_tier_web_app_oracle

```bash
cd 3_tier_web_app_oracle
```
Step2: Initialize and apply the Terraform templates

```bash
Initialize terraform using below command

terraform init

Plan the terraform using below command

terraform plan

Apply Terraform using below command

terraform apply
```

If prompted to ‘Enter a value’. Type ‘yes’

This will start creating the resources on OCI and might take long (approx. 2 hours) to complete as DB resources take time get provisioned and configured. 

### Verifying the Application 

Open your browser and type 
http://<public_ip>/api/test


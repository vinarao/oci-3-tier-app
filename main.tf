/*
*  calling the different modules from this main file
*/

# call module for creating the user
#module "user" {
#  source       = "./modules/identity/user"
#  tenancy_ocid = "${var.tenancy_ocid}"
#}

#module "group" {
#  source       = "./modules/identity/group"
#  tenancy_ocid = "${var.tenancy_ocid}"
#  user_id      = "${module.user.user_id}"
#}

#module "compartment" {
#  source       = "./modules/identity/compartment"
#  tenancy_ocid = "${var.tenancy_ocid}"
#  group_name   = "${module.group.group_name}"
#}

module "vcn" {
  source              = "./modules/vcn"
  tenancy_ocid        = "${var.tenancy_ocid}"
  compartment_ocid    = "${var.compartment_ocid}"
  availability_domain = "${var.availability_domain}"
}

module "compute" {
  source              = "./modules/compute"
  tenancy_ocid        = "${var.tenancy_ocid}"
  compartment_ocid    = "${var.compartment_ocid}"
  availability_domain = "${var.availability_domain}"
  image_ocid          = "${var.image_ocid}"
  ubuntu_image_ocid    = "${var.ubuntu_image_ocid}"
  instance_shape      = "${var.instance_shape}"
  ssh_public_key      = "${var.ssh_public_key}"
  subnet1_ocid        = "${module.vcn.subnet1_ocid}"
  subnet2_ocid        = "${module.vcn.subnet2_ocid}"
  nsg_db_ocid         = "${module.vcn.nsg_db_ocid}"
  nsg_app_ocid        = "${module.vcn.nsg_app_ocid}"
  nsg_web_ocid        = "${module.vcn.nsg_web_ocid}"
}
module "database"{
    source = "./modules/db"
    tenancy_ocid = "${var.tenancy_ocid}"
    compartment_ocid = "${var.compartment_ocid}"
    availability_domain = "${var.availability_domain}"
    ssh_public_key = "${var.ssh_public_key}"
    ssh_private_key   = "${var.ssh_authorized_private_key}"
    subnet_ad1 = "${module.vcn.subnet1_ocid}"
    subnet_ad2 = "${module.vcn.subnet2_ocid}"
    nsg_db_ocid = "${module.vcn.nsg_db_ocid}"
}

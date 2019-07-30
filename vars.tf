# Variables Exported from env.sh
variable "tenancy_ocid" {}

variable "user_ocid" {}
variable "compartment_ocid"{}
variable "fingerprint" {}
variable "image_ocid" {}
variable "private_key_path" {}
variable "region" {}
variable "ssh_public_key" {}
variable "instance_shape" {}
variable "ssh_authorized_private_key" {}

# Uses Default Value

variable "instance_count" {
  default = "6"
}

variable "availability_domain" {
  default = "3"
}

variable "instance_user" {
  default = "opc"
}

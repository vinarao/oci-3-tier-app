# Variables Exported from env.sh
variable "tenancy_ocid" {}

variable "user_ocid" {}
variable "compartment_ocid"{}
variable "fingerprint" {}
variable "image_ocid" {}
variable "ubuntu_image_ocid" {}
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
  default = "1"
}

variable "instance_user" {
  default = "opc"
}
variable "autonomous_database_db_workload" {
  default = "OLTP"
}

variable "autonomous_data_warehouse_db_workload" {
  default = "DW"
}

variable "autonomous_database_defined_tags_value" {
  default = "value"
}

variable "autonomous_database_freeform_tags" {
  default = {
    "Department" = "Finance"
  }
}

variable "autonomous_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "autonomous_database_is_dedicated" {
  default = false
}

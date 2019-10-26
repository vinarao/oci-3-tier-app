variable "compartment_ocid" {}
variable "ssh_private_key" {}
variable "ssh_public_key" {}
variable "availability_domain" {}
variable "tenancy_ocid" {}
variable "nsg_db_ocid"{}

variable "subnet_ad1" {}
variable "subnet_ad2" {}


# DBSystem specific 
variable "db_system_shape" {
  default = "VM.Standard2.1"
}

variable "cpu_core_count" {
  default = "2"
}

variable "db_edition" {
  default = "ENTERPRISE_EDITION"
}

variable "db_admin_password" {
  default = "BEstrO0ng_#12"
}

variable "db_name" {
  default = "aTFdb"
}

variable "db_version" {
  default = "12.1.0.2"
}

variable "db_home_display_name" {
  default = "MyTFDBHome"
}

variable "db_disk_redundancy" {
  default = "HIGH"
}

variable "db_system_display_name" {
  default = "MyTFDBSystem"
}

variable "hostname" {
  default = "myoracledb"
}

variable "host_user_name" {
  default = "opc"
}

variable "n_character_set" {
  default = "AL16UTF16"
}

variable "character_set" {
  default = "AL32UTF8"
}

variable "db_workload" {
  default = "OLTP"
}

variable "pdb_name" {
  default = "pdbName"
}

variable "data_storage_size_in_gb" {
  default = "256"
}

variable "license_model" {
  default = "LICENSE_INCLUDED"
}

variable "node_count" {
  default = "1"
}

variable "data_storage_percentage" {
  default = "40"
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

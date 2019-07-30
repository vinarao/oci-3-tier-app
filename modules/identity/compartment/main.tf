/*
 * This example file shows how to create a compartment and
 * define policies for thr compartment
 */

resource "oci_identity_compartment" "web-compartment" {
  name           = "3Tier"
  description    = "compartment created by terraform"
  compartment_id = "${var.tenancy_ocid}"
}

data "oci_identity_compartments" "compartments1" {
  compartment_id = "${oci_identity_compartment.web-compartment.compartment_id}"

  filter {
    name   = "name"
    values = ["3Tier"]
  }
}

resource "oci_identity_policy" "policy" {
  name           = "policy-3Tier"
  description    = "policy created for 3Tier compartment resources"
  compartment_id = "${oci_identity_compartment.web-compartment.id}"

  statements = ["Allow group ${var.group_name} to manage all-resources in compartment ${oci_identity_compartment.web-compartment.name}"]
}

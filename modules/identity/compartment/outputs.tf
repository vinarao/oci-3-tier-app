# Output variables from created compartment

output "compartments" {
  value = "${data.oci_identity_compartments.compartments1.compartments}"
}

output "compartment_id" {
  value = "${oci_identity_compartment.web-compartment.id}"
}

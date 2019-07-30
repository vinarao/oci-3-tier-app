# Output variables from created vcn

output "subnet1_ocid" {
  value = "${oci_core_subnet.public-subnet.id}"
}

output "subnet2_ocid" {
  value = "${oci_core_subnet.private-subnet.id}"
}

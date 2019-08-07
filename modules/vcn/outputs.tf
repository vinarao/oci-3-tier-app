# Output variables from created vcn

output "subnet1_ocid" {
  value = "${oci_core_subnet.public-subnet.id}"
}

output "subnet2_ocid" {
  value = "${oci_core_subnet.private-subnet.id}"
}
output "nsg_web_ocid" {
   value = "${oci_core_network_security_group.Web.id}"
}
output "nsg_app_ocid" {
   value = "${oci_core_network_security_group.App.id}"
}
output "nsg_db_ocid" {
   value = "${oci_core_network_security_group.DB.id}"
}

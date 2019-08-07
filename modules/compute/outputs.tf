# Output variables from created compute instance

output "public_ip1" {
  value = "${oci_core_instance.compute_instance1.public_ip}"
}

output "public_ip2" {
  value = "${oci_core_instance.compute_instance2.public_ip}"
}

output "private_ip1" {
  value = "${oci_core_instance.compute_instance1.private_ip}"
}

output "private_ip2" {
  value = "${oci_core_instance.compute_instance2.private_ip}"
}

output "private_ip3" {
  value = "${oci_core_instance.compute_instance3.private_ip}"
}

output "private_ip4" {
  value = "${oci_core_instance.compute_instance4.private_ip}"
}

output "private_ip5" {
  value = "${oci_core_instance.compute_instance5.private_ip}"
}

output "private_ip6" {
  value = "${oci_core_instance.compute_instance6.private_ip}"
}

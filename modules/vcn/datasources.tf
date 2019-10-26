# Get list of availability domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

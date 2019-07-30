# Get list of availability domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}
data "template_file" "init" {
  template = "${file("userdata.tpl")}"
}

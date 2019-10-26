# This Terraform script provisions a compute instance

# Create bastion node
resource "oci_core_instance" "bastion" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain -1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "web"
  shape               = "${var.instance_shape}"
  hostname_label      = "bastion"
  subnet_id        = "${var.subnet1_ocid}"
  source_details {
    source_type = "image"
    source_id   = "${var.image_ocid}"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.init.rendered)}"
  }
}
resource "oci_core_instance" "ubuntu_instance" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "ubuntu_instance1"
  shape               = "${var.instance_shape}"
  subnet_id           = "${var.subnet2_ocid}"
  source_details {
    source_type = "image"
    source_id   = "${var.ubuntu_image_ocid}"
  }
  create_vnic_details {
    subnet_id        = "${var.subnet2_ocid}"
    assign_public_ip = "false"
    display_name     = "app"
    nsg_ids          = ["${var.nsg_app_ocid}"]
  }
  metadata = {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(data.template_file.init.rendered)}"
  }
  timeouts = {
    create = "60m"
  }
}

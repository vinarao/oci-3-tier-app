# Create VCN

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "3TierNetwork"
  dns_label      = "tiernetwork"
}

# Create internet gateway to allow public internet traffic

resource "oci_core_internet_gateway" "ig" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "ig-gateway"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
}

# Create route table to connect vcn to internet gateway

resource "oci_core_route_table" "rt" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "rt"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.ig.id}"
  }
}


resource "oci_core_nat_gateway" "ngw" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.vcn.id}"
    display_name = "ngw"

}
#create a RT for private subnet to reach the internet using NATGW

resource "oci_core_route_table" "private_rt1" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "private_rt1"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_nat_gateway.ngw.id}"
  }
}

# Create security list to allow internet access from compute and ssh access

resource "oci_core_security_list" "sl" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "sl"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
egress_security_rules = [{
    destination = "0.0.0.0/0"
    protocol = "all"
  }]
  ingress_security_rules = [{
    tcp_options {
      "max" = 22
      "min" = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }]
}

# Create subnet in vcn

resource "oci_core_subnet" "public-subnet" {
  cidr_block        = "10.0.0.0/24"
  display_name      = "subnet_ad1"
  compartment_id    = "${var.compartment_ocid}"
  vcn_id            = "${oci_core_virtual_network.vcn.id}"
  dhcp_options_id   = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  route_table_id    = "${oci_core_route_table.rt.id}"
  security_list_ids = ["${oci_core_security_list.sl.id}"]
  dns_label         = "publicsubnet"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_core_subnet" "private-subnet" {
  cidr_block                 = "10.0.1.0/24"
  display_name               = "private-subnet"
  prohibit_public_ip_on_vnic = "true"
  compartment_id             = "${var.compartment_ocid}"
  vcn_id                     = "${oci_core_virtual_network.vcn.id}"
  dhcp_options_id            = "${oci_core_virtual_network.vcn.default_dhcp_options_id}"
  route_table_id             = "${oci_core_route_table.private_rt1.id}"
  security_list_ids          = ["${oci_core_security_list.sl.id}"]
  dns_label                  = "privatesubnet"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

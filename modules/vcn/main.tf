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
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.ig.id}"
  }
}


resource "oci_core_nat_gateway" "ngw" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_virtual_network.vcn.id}"
    display_name = "ngw"

}
resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = "${var.compartment_ocid}"

  services {
    service_id = "${lookup(data.oci_core_services.test_services.services[0], "id")}"
  }

  vcn_id = "${oci_core_virtual_network.vcn.id}"
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
  route_rules {
    destination       = "${lookup(data.oci_core_services.test_services.services[0], "cidr_block")}"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = "${oci_core_service_gateway.service_gateway.id}"
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
    protocol = "all"
    source   = "0.0.0.0/0"
  }]
}

# Create Network Security Groups
resource "oci_core_network_security_group" "Web" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "Web NSG"
}
resource "oci_core_network_security_group" "App" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "App NSG"
}
resource "oci_core_network_security_group" "DB" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn.id}"
  display_name   = "DB NSG"
}

resource "oci_core_network_security_group_security_rule" "https" {
  network_security_group_id = "${oci_core_network_security_group.Web.id}"
  description = "HTTPS"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "CIDR_BLOCK"
  source      = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}
resource "oci_core_network_security_group_security_rule" "web2app" {
  network_security_group_id = "${oci_core_network_security_group.Web.id}"
  description = "Allow Egress to App NSG"
  direction   = "EGRESS"
  protocol    = 6
  destination_type = "NETWORK_SECURITY_GROUP"
  destination      = "${oci_core_network_security_group.App.id}"
  tcp_options {
    destination_port_range {
      min = 3000
      max = 3000
    }
  }
}
resource "oci_core_network_security_group_security_rule" "web2app1" {
  network_security_group_id = "${oci_core_network_security_group.App.id}"
  description = "Allow Ingress to App NSG"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "NETWORK_SECURITY_GROUP"
  source      = "${oci_core_network_security_group.Web.id}"
  tcp_options {
    destination_port_range {
      min = 3000
      max = 3000
    }
  }
}
resource "oci_core_network_security_group_security_rule" "App2db" {
  network_security_group_id = "${oci_core_network_security_group.App.id}"
  description = "Allow Egress to DB NSG"
  direction   = "EGRESS"
  protocol    = 6
  destination_type = "NETWORK_SECURITY_GROUP"
  destination      = "${oci_core_network_security_group.DB.id}"
  tcp_options {
    destination_port_range {
      min = 3306
      max = 3306
    }
  }
}
resource "oci_core_network_security_group_security_rule" "App2db1" {
  network_security_group_id = "${oci_core_network_security_group.DB.id}"
  description = "Allow Ingress from App NSG"
  direction   = "INGRESS"
  protocol    = 6
  source_type = "NETWORK_SECURITY_GROUP"
  source      = "${oci_core_network_security_group.App.id}"
  tcp_options {
    destination_port_range {
      min = 3306
      max = 3306
    }
  }
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


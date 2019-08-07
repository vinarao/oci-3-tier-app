resource "oci_load_balancer" "lb1" {
  shape          = "100Mbps"
  compartment_id = "${var.compartment_ocid}"
  network_security_group_ids = ["${var.nsg_web_ocid}"]
  subnet_ids = [
    "${var.subnet_ad1}",
  ]

  display_name = "web-lb1"
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "lb-bes1"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "5000"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
    interval_ms         = "1790000"
    return_code         = "200"
    timeout_in_millis   = "590000"
    retries             = "2147483646"
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  port                     = 80
  protocol                 = "HTTP"
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${var.private_ip1}"
  port             = 9090
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be2" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = "${var.private_ip2}"
  port             = 9090
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer" "lb2" {
  shape          = "100Mbps"
  network_security_group_ids = ["${var.nsg_app_ocid}"]
  compartment_id = "${var.compartment_ocid}"

  subnet_ids = [
    "${var.subnet_ad2}",
  ]

  display_name = "app-lb1"
  is_private   = true
}

resource "oci_load_balancer_backend_set" "lb-bes2" {
  name             = "lb-bes2"
  load_balancer_id = "${oci_load_balancer.lb2.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "3000"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
    interval_ms         = "1790000"
    return_code         = "200"
    timeout_in_millis   = "590000"
    retries             = "2147483646"
  }
}

resource "oci_load_balancer_listener" "lb-listener2" {
  load_balancer_id         = "${oci_load_balancer.lb2.id}"
  name                     = "tcp"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes2.name}"
  port                     = 3000
  protocol                 = "TCP"
}


resource "oci_load_balancer_backend" "lb-be3" {
  load_balancer_id = "${oci_load_balancer.lb2.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes2.name}"
  ip_address       = "${var.private_ip3}"
  port             = 3000
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb-be4" {
  load_balancer_id = "${oci_load_balancer.lb2.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes2.name}"
  ip_address       = "${var.private_ip4}"
  port             = 3000
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

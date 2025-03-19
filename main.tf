# VPC
resource "google_compute_network" "googlevpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

# backend subnet
resource "google_compute_subnetwork" "googlesubnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  region        = var.region
  network       = google_compute_network.googlevpc.id
}

# reserved IP address
resource "google_compute_global_address" "reservedip" {
  name = var.reserved_ip_name
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "gcpforward" {
  name                  = var.forwarding_rule_name
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range
  target                = google_compute_target_http_proxy.googleproxy.id
  ip_address            = google_compute_global_address.reservedip.id
}

# http proxy
resource "google_compute_target_http_proxy" "googleproxy" {
  name    = var.http_proxy_name
  url_map = google_compute_url_map.gcpurlmap.id
}

# url map
resource "google_compute_url_map" "gcpurlmap" {
  name            = var.url_map_name
  default_service = google_compute_backend_service.gcpbackend.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "gcpbackend" {
  name                    = var.backend_service_name
  protocol                = var.backend_protocol
  port_name               = var.backend_port_name
  load_balancing_scheme   = var.backend_load_balancing_scheme
  timeout_sec             = var.backend_timeout_sec
  enable_cdn              = var.backend_enable_cdn
  custom_request_headers  = var.backend_custom_request_headers
  custom_response_headers = var.backend_custom_response_headers
  health_checks           = [google_compute_health_check.gcphealth.id]
  backend {
    group           = google_compute_instance_group_manager.googlegm.instance_group
    balancing_mode  = var.backend_balancing_mode
    capacity_scaler = var.backend_capacity_scaler
  }
}

# instance template
resource "google_compute_instance_template" "instancetemplate" {
  name         = var.instance_template_name
  machine_type = var.instance_machine_type
  tags         = var.instance_tags

  network_interface {
    network    = google_compute_network.googlevpc.id
    subnetwork = google_compute_subnetwork.googlesubnet.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = var.instance_source_image
    auto_delete  = var.instance_auto_delete
    boot         = var.instance_boot
  }

  metadata = {
    startup-script = var.instance_startup_script
  }
  lifecycle {
    create_before_destroy = var.instance_create_before_destroy
  }
}

# health check
resource "google_compute_health_check" "gcphealth" {
  name = var.health_check_name
  http_health_check {
    port_specification = var.health_check_port_specification
  }
}

# MIG
resource "google_compute_instance_group_manager" "googlegm" {
  name     = var.instance_group_manager_name
  zone     = var.instance_group_manager_zone
  named_port {
    name = var.instance_group_manager_named_port_name
    port = var.instance_group_manager_named_port
  }
  version {
    instance_template = google_compute_instance_template.instancetemplate.id
    name              = var.instance_group_manager_version_name
  }
  base_instance_name = var.instance_group_manager_base_instance_name
  target_size        = var.instance_group_manager_target_size
}

# allow access from health check ranges
resource "google_compute_firewall" "gcpfirewall" {
  name          = var.firewall_name
  direction     = var.firewall_direction
  network       = google_compute_network.googlevpc.id
  source_ranges = var.firewall_source_ranges
  allow {
    protocol = var.firewall_protocol
  }
  target_tags = var.firewall_target_tags
}

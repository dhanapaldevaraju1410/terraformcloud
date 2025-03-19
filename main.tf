resource "google_project_service" "compute" {
  project = var.project
  service = "compute.googleapis.com"
}

resource "google_project_service" "serviceusage" {
  project = var.project
  service = "serviceusage.googleapis.com"
}

resource "google_compute_network" "myvpc" {
  name                    = var.network_name
  provider                = google
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mysubnet" {
  name          = var.subnet_name
  provider      = google
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.myvpc.id
}

resource "google_compute_global_address" "myip" {
  provider = google
  name     = var.global_address_name
}

resource "google_compute_global_forwarding_rule" "myforwardingrule" {
  name                  = var.forwarding_rule_name
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range
  target                = google_compute_target_http_proxy.myproxy.id
  ip_address            = google_compute_global_address.myip.id
}

resource "google_compute_target_http_proxy" "myproxy" {
  name     = var.proxy_name
  provider = google
  url_map  = google_compute_url_map.myurlmap.id
}

resource "google_compute_url_map" "myurlmap" {
  name            = var.url_map_name
  provider        = google
  default_service = google_compute_backend_service.mybackend.id
}

resource "google_compute_backend_service" "mybackend" {
  name                    = var.backend_service_name
  provider                = google
  protocol                = var.protocol
  port_name               = var.port_name
  load_balancing_scheme   = var.load_balancing_scheme
  timeout_sec             = var.timeout_sec
  enable_cdn              = true
  custom_request_headers  = var.custom_request_headers
  custom_response_headers = var.custom_response_headers
  health_checks           = [google_compute_health_check.mycheck.id]
  backend {
    group           = google_compute_instance_group_manager.mymanager.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_instance_template" "mytemplate" {
  name         = var.instance_template_name
  provider     = google
  machine_type = var.machine_type
  tags         = var.target_tags

  network_interface {
    network    = google_compute_network.myvpc.id
    subnetwork = google_compute_subnetwork.mysubnet.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  # install nginx and serve a simple web page
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      set -euo pipefail

      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y nginx-light jq

      NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
      IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")
      METADATA=$(curl -f -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/?recursive=True" | jq 'del(.["startup-script"])')

      cat <<EOF > /var/www/html/index.html
      <pre>
      Name: $NAME
      IP: $IP
      Metadata: $METADATA
      </pre>
      EOF
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "mycheck" {
  name     = var.health_check_name
  provider = google
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_instance_group_manager" "mymanager" {
  name     = var.instance_group_manager_name
  provider = google
  zone     = var.zone
  named_port {
    name = "http"
    port = 8080
  }
  version {
    instance_template = google_compute_instance_template.mytemplate

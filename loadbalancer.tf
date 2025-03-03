resource "google_compute_instance" "default" {
  count        = 2
  name         = "instance-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
  EOF
}

resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "default" {
  name = "lb-ip"
}

resource "google_compute_http_health_check" "default" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2
}

resource "google_compute_target_pool" "default" {
  name        = "target-pool"
  health_checks = [google_compute_http_health_check.default.self_link]
  instances   = google_compute_instance.default.*.self_link
}

resource "google_compute_forwarding_rule" "default" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_pool.default.self_link
  port_range = "80"
  ip_address = google_compute_address.default.address
}

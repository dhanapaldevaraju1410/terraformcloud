resource "google_compute_instance" "nginx_server" {
  name         = var.instance_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup-script.sh")

  tags = var.instance_tags

  metadata = {
    ssh-keys = "${var.ssh_username}:${var.ssh_public_key}"
  }
}

resource "google_compute_firewall" "default" {
  name    = var.firewall_name
  network = var.network

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = var.source_ranges

  target_tags = var.instance_tags
}

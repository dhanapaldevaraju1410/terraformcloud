resource "google_compute_instance_template" "GCIT" {
  name         = "instance-template"
  machine_type = var.machine_type

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.network
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance_group_manager" "MIG" {
  name               = "managed-instance-group"
  base_instance_name = "instance"
  zone               = var.zone
  target_size        = var.instance_count

  version {
    instance_template = google_compute_instance_template.GCIT.self_link
  }
}

resource "google_compute_firewall" "default-allow-http" {
  name    = "default-allow-http"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default-allow-https" {
  name    = "default-allow-https"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_disk" "foobar" {
  name = "my-disk"
  type = "pd-standard"
  zone = var.zone
  size = 50
}

resource "google_compute_instance_template" "default" {
  name         = "appserver-template"
  description  = "This template is used to create app server instances."
  machine_type = var.machine_type

  network_interface {
    network = var.network
  }

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  disk {
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  }
}

resource "google_compute_snapshot" "snapshot" {
  name              = "my-snapshot"
  source_disk       = google_compute_disk.foobar.id
  zone              = var.zone
  storage_locations = ["us-central1"]
}

resource "google_compute_instance_from_template" "tpl" {
  name = "instance-from-template"
  zone = var.zone

  source_instance_template = google_compute_instance_template.default.self_link_unique

  network_interface {
    network = var.network
    access_config {
      // This assigns an external IP address
    }
  }

  depends_on = [google_compute_snapshot.snapshot]
}

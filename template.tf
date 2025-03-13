resource "google_compute_disk" "foobar" {
  name = var.disk_name
  type = var.disk_type
  zone = var.zone
  size = var.disk_size
}

resource "google_compute_instance_template" "default" {
  name         = var.instance_template_name
  description  = var.instance_template_description
  machine_type = var.machine_type

  network_interface {
    network = var.network
  }

  disk {
    source_image = var.source_image
    auto_delete  = var.auto_delete
    boot         = var.boot
  }

  disk {
    source      = google_compute_disk.foobar.name
    auto_delete = var.auto_delete_secondary
    boot        = var.boot_secondary
  }
}

resource "google_compute_snapshot" "snapshot" {
  name              = var.snapshot_name
  source_disk       = google_compute_disk.foobar.id
  zone              = var.zone
  storage_locations = var.storage_locations
}

resource "google_compute_instance_from_template" "tpl" {
  name                   = var.instance_name
  zone                   = var.zone
  source_instance_template = google_compute_instance_template.default.self_link_unique

  network_interface {
    network = var.network
    access_config {
      // This assigns an external IP address
    }
  }

  depends_on = [google_compute_snapshot.snapshot]
}

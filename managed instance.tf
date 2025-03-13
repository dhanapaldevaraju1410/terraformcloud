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

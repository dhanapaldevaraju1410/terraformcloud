resource "google_compute_disk" "foobar" {
  name = "my-disk"
  type = "pd-standard"
  zone = "us-central1-a"
  size = 50
}

resource "google_compute_instance_template" "default" {
  name         = "appserver-template"
  description  = "This template is used to create app server instances."
  machine_type = "n4-standard-2"

  network_interface {
    network = "default"
  }

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  disk {
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  }
}

resource "google_compute_instance_from_template" "tpl" {
  name = "instance-from-template"
  zone = "us-central1-a"

  source_instance_template = google_compute_instance_template.default.self_link_unique
}


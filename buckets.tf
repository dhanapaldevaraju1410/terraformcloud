resource "google_storage_bucket" "my-first-tf-bucket" {
  name     = "my-first-tf-bucket"
  location = "US-CENTRAL1"
  force_destroy = true
  storage_class = "STANDARD"

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

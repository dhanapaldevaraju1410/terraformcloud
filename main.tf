provider "google" {
  project     = "natural-region-452705-m6"
  region      = "us-central1"
}

provider "aws" {
  region = "us-east-1"
}

resource "google_pubsub_topic" "transfer_notifications" {
  name    = "pubsub14"
  project = "natural-region-452705-m6"
}

resource "google_pubsub_topic_iam_member" "publisher" {
  project = "natural-region-452705-m6"
  topic   = google_pubsub_topic.transfer_notifications.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
}

resource "google_project_service" "storage_transfer" {
  project = "natural-region-452705-m6"
  service = "storagetransfer.googleapis.com"
}

data "google_storage_transfer_project_service_account" "default" {
  project    = "natural-region-452705-m6"
  depends_on = [google_project_service.storage_transfer]
}

resource "google_storage_bucket" "gcs_bucket" {
  name          = "dhanapal1410"
  location      = "US"
  storage_class = "STANDARD"
}

resource "google_storage_bucket_iam_member" "gcs_bucket" {
  bucket = google_storage_bucket.gcs_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
}

resource "google_storage_bucket_iam_member" "storage_transfer_service_account" {
  bucket = google_storage_bucket.gcs_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
}

resource "google_storage_transfer_job" "s3_to_gcs" {
  description = "Transfer data from S3 to GCS"
  project     = "natural-region-452705-m6"

  transfer_spec {
    aws_s3_data_source {
      bucket_name = "stsbucket14"
      aws_access_key {
        access_key_id     = "AKIAZI2LIKSNM67H7DG6"
        secret_access_key = "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"
      }
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.gcs_bucket.name
    }
  }

  schedule {
    schedule_start_date {
      year  = 2025
      month = 3
      day   = 6
    }

    start_time_of_day {
      hours   = 9
      minutes = 18
      seconds = 0
      nanos   = 0
    }
  }

  notification_config {
    pubsub_topic   = google_pubsub_topic.transfer_notifications.id
    event_types    = ["TRANSFER_OPERATION_SUCCESS", "TRANSFER_OPERATION_FAILED"]
    payload_format = "JSON"
  }
}

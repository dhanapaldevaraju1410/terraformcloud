provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAZI2LIKSNM67H7DG6"
  secret_key = "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"
}

resource "google_project_service" "storage_transfer" {
  project = "natural-region-452705-m6"
  service = "storagetransfer.googleapis.com"
}

resource "google_pubsub_topic" "transfer_notifications" {
  name    = "pubsub1412"
  project = "natural-region-452705-m6"
}

resource "google_pubsub_topic_iam_member" "publisher" {
  project = "natural-region-452705-m6"
  topic   = google_pubsub_topic.transfer_notifications.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
}

data "google_storage_transfer_project_service_account" "default" {
  project    = "natural-region-452705-m6"
  depends_on = [google_project_service.storage_transfer]
}

resource "google_storage_bucket" "gcs_bucket" {
  count         = 2
  name          = "dhanapal141${count.index}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "google_storage_bucket_iam_member" "gcs_bucket" {
  for_each = { for idx, bucket in google_storage_bucket.gcs_bucket : bucket.name => bucket.name }
  bucket   = each.key
  role     = "roles/storage.admin"
  member   = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
}

resource "google_storage_bucket_iam_member" "storage_transfer_service_account" {
  for_each = { for idx, bucket in google_storage_bucket.gcs_bucket : bucket.name => bucket.name }
  bucket   = each.key
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
}

resource "aws_s3_bucket" "s3_bucket" {
  count  = 2
  bucket = "my-bucket-${count.index + 1}"
}

resource "google_storage_transfer_job" "s3_to_gcs" {
  count       = 2
  description = "Transfer data from S3 to GCS"
  project     = "natural-region-452705-m6"

  transfer_spec {
    aws_s3_data_source {
      bucket_name = aws_s3_bucket.s3_bucket[count.index].bucket
      aws_access_key {
        access_key_id     = "AKIAZI2LIKSNE3LGSIIE"
        secret_access_key = "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"
      }
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.gcs_bucket[count.index].name
    }
  }

  schedule {
    schedule_start_date {
      year  = 2025
      month = 3
      day   = 7
    }

    start_time_of_day {
      hours   = 10
      minutes = 20
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


provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials)
}

resource "google_project_service" "storage_transfer" {
  project = var.project
  service = "storagetransfer.googleapis.com"
}

resource "google_pubsub_topic" "transfer_notifications" {
  name    = var.pubsub_topic_name
  project = var.project
}

resource "google_pubsub_topic_iam_member" "publisher" {
  project = var.project
  topic   = google_pubsub_topic.transfer_notifications.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${var.storage_transfer_service_account}"
  depends_on = [google_pubsub_topic.transfer_notifications]
}

data "google_storage_transfer_project_service_account" "default" {
  project    = var.project
  depends_on = [google_project_service.storage_transfer]
}

resource "google_storage_bucket" "gcs_bucket" {
  count         = 2
  name          = "gdhanap${count.index}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "aws_s3_bucket" "s3_bucket" {
  count  = 2
  bucket = "s3dha-${count.index}"
}

resource "google_storage_bucket_iam_member" "gcs_bucket" {
  for_each = { for idx, bucket in google_storage_bucket.gcs_bucket : bucket.name => bucket.name }
  bucket   = each.key
  role     = "roles/storage.admin"
  member   = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
  depends_on = [google_storage_bucket.gcs_bucket, data.google_storage_transfer_project_service_account.default]
}

resource "google_storage_bucket_iam_member" "storage_transfer_service_account" {
  for_each = { for idx, bucket in google_storage_bucket.gcs_bucket : bucket.name => bucket.name }
  bucket   = each.key
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${var.storage_transfer_service_account}"
  depends_on = [google_storage_bucket.gcs_bucket]
}

resource "google_storage_transfer_job" "s3_to_gcs" {
  count       = 2
  description = "Transfer data from S3 to GCS"
  project     = var.project

  transfer_spec {
    aws_s3_data_source {
      bucket_name = aws_s3_bucket.s3_bucket[count.index].bucket
      aws_access_key {
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.gcs_bucket[count.index].name
    }
  }

  schedule {
    schedule_start_date {
      year  = var.schedule_start_year
      month = var.schedule_start_month
      day   = var.schedule_start_day
    }

    start_time_of_day {
      hours   = var.schedule_start_hour
      minutes = var.schedule_start_minute
      seconds = var.schedule_start_second
      nanos   = 0
    }
  }

  notification_config {
    pubsub_topic   = google_pubsub_topic.transfer_notifications.id
    event_types    = ["TRANSFER_OPERATION_SUCCESS", "TRANSFER_OPERATION_FAILED"]
    payload_format = "JSON"
  }

  depends_on = [
    aws_s3_bucket.s3_bucket,
    google_storage_bucket.gcs_bucket,
    google_pubsub_topic.transfer_notifications
  ]
}

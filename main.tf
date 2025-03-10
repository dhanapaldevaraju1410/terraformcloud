provider "aws" {
  region = "us-west-1"
  }

provider "google" {
  project     = "natural-region-452705-m6"
  region      = "us-west-2"
}

resource "google_project_service" "storage_transfer" {
  project = "natural-region-452705-m6"
  service = "storagetransfer.googleapis.com"
}

resource "google_pubsub_topic" "transfer_notifications" {
  name    = "pubsub1419"
  project = "natural-region-452705-m6"
}

resource "google_pubsub_topic_iam_member" "publisher" {
  project = "natural-region-452705-m6"
  topic   = google_pubsub_topic.transfer_notifications.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
  depends_on = [google_pubsub_topic.transfer_notifications]
}

data "google_storage_transfer_project_service_account" "default" {
  project    = "natural-region-452705-m6"
  depends_on = [google_project_service.storage_transfer]
}

resource "google_storage_bucket" "gcs_bucket" {
  count         = 2
  name          = "gdhanapp${count.index}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "aws_s3_bucket" "s3_bucket" {
  count  = 2
  bucket = "s3dhal-${count.index}"
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
  member   = "serviceAccount:project-494690071564@storage-transfer-service.iam.gserviceaccount.com"
  depends_on = [google_storage_bucket.gcs_bucket]
}

resource "google_storage_transfer_job" "s3_to_gcs" {
  count       = 2
  description = "Transfer data from S3 to GCS"
  project     = "natural-region-452705-m6"

  transfer_spec {
    aws_s3_data_source {
      bucket_name = aws_s3_bucket.s3_bucket[count.index].bucket

      aws_access_key {
        access_key_id     = var.aws_access_key
        secret_access_key = var.aws_secret_key
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
      day   = 10
    }

    start_time_of_day {
      hours   = 9
      minutes = 10
      seconds = 0
      nanos   = 0
    }
  }

  depends_on = [
    aws_s3_bucket.s3_bucket,
    google_storage_bucket.gcs_bucket,
    google_pubsub_topic.transfer_notifications
  ]
}

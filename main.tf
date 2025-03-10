terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "s3_bucket_lock" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    default_retention {
      mode = "GOVERNANCE"
      days = 30
    }
  }
}

provider "google" {
  project = "natural-region-452705-m6"
  region  = "us-central1"
}

resource "google_project_service" "storage_transfer" {
  project = "natural-region-452705-m6"
  service = "storagetransfer.googleapis.com"
}

resource "google_pubsub_topic" "transfer_notifications" {
  name    = "pubsub1414"
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
  name          = "gdhanap${count.index}"
  location      = "US"
  storage_class = "STANDARD"
}

resource "aws_s3_bucket" "s3_bucket" {
  count  = 2
  bucket = "s3dha-${count.index}"

  versioning {
    enabled = true
  }

  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
        mode  = "GOVERNANCE"
        days  = 1
      }
    }
  }
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
        access_key_id     = "your_aws_access_key"
        secret_access_key = "your_aws_secret_key"
      }
    }

    gcs_data_sink {
      bucket_name = google_storage_bucket.gcs_bucket[count.index].name
    }
  }

  depends_on = [
    aws_s3_bucket.s3_bucket,
    google_storage_bucket.gcs_bucket,
    google_pubsub_topic.transfer_notifications
  ]
}

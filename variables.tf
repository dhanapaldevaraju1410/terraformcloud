variable "project" {
  description = "The project ID"
  type        = string
}

variable "region" {
  description = "The region"
  type        = string
}

variable "credentials" {
  description = "Path to the credentials file"
  type        = string
}

variable "pubsub_topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
}

variable "storage_transfer_service_account" {
  description = "The Storage Transfer Service account"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "schedule_start_year" {
  description = "Schedule start year"
  type        = number
}

variable "schedule_start_month" {
  description = "Schedule start month"
  type        = number
}

variable "schedule_start_day" {
  description = "Schedule start day"
  type        = number
}

variable "schedule_start_hour" {
  description = "Schedule start hour"
  type        = number
}

variable "schedule_start_minute" {
  description = "Schedule start minute"
  type        = number
}

variable "schedule_start_second" {
  description = "Schedule start second"
  type        = number
}

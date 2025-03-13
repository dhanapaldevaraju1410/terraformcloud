variable "project_id" {
  description = "The ID of the project in which to create resources."
  type        = string
}

variable "region" {
  description = "The region in which to create resources."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone in which to create resources."
  type        = string
  default     = "us-central1-a"
}

variable "instance_count" {
  description = "Number of instances to create in the managed instance group."
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "The machine type to use for instances."
  type        = string
  default     = "n1-standard-1"
}

variable "source_image" {
  description = "The source image to use for boot disk."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "network" {
  description = "The network to attach instances to."
  type        = string
  default     = "default"
}

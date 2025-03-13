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

variable "disk_name" {
  description = "Name of the disk"
  type        = string
  default     = "my-disk"
}

variable "disk_type" {
  description = "Type of the disk"
  type        = string
  default     = "pd-standard"
}

variable "disk_size" {
  description = "Size of the disk"
  type        = number
  default     = 50
}

variable "instance_template_name" {
  description = "Name of the instance template"
  type        = string
  default     = "appserver-template"
}

variable "instance_template_description" {
  description = "Description of the instance template"
  type        = string
  default     = "This template is used to create app server instances."
}

variable "auto_delete" {
  description = "Whether the boot disk should be auto-deleted"
  type        = bool
  default     = true
}

variable "boot" {
  description = "Whether the disk is a boot disk"
  type        = bool
  default     = true
}

variable "auto_delete_secondary" {
  description = "Whether the secondary disk should be auto-deleted"
  type        = bool
  default     = false
}

variable "boot_secondary" {
  description = "Whether the secondary disk is a boot disk"
  type        = bool
  default     = false
}

variable "snapshot_name" {
  description = "Name of the snapshot"
  type        = string
  default     = "my-snapshot"
}

variable "storage_locations" {
  description = "Storage locations for the snapshot"
  type        = list(string)
  default     = ["us-central1"]
}

variable "instance_name" {
  description = "Name of the instance created from the template"
  type        = string
  default     = "instance-from-template"
}

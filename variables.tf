variable "project" {
  description = "project name"
  type = string
}


variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VM instance"
  type        = string
}

variable "image" {
  description = "The image to use for the VM instance"
  type        = string
}

variable "network" {
  description = "The network to attach the VM instance to"
  type        = string
}

variable "instance_tags" {
  description = "Tags to apply to the VM instance"
  type        = list(string)
}

variable "ssh_username" {
  description = "The SSH username"
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key"
  type        = string
}

variable "firewall_name" {
  description = "The name of the firewall rule"
  type        = string
}

variable "allowed_ports" {
  description = "The ports to allow in the firewall rule"
  type        = list(number)
}

variable "source_ranges" {
  description = "The source ranges to allow in the firewall rule"
  type        = list(string)
}

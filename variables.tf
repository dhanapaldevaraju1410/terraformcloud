variable "instance_group_name" {
  description = "Name of the instance group"
  type        = string
}

variable "base_instance_name" {
  description = "The base instance name for the instance group manager"
  type        = string
}

variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "ip_cidr_range" {
  description = "The IP CIDR range for the subnet"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the instance template"
  type        = string
}

variable "source_image" {
  description = "The source image for the instance template"
  type        = string
}

variable "zone" {
  description = "The GCP zone for the instance group manager"
  type        = string
}

variable "target_size" {
  description = "The target size for the instance group manager"
  type        = number
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "global_address_name" {
  description = "The name of the global address"
  type        = string
}

variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}

variable "proxy_name" {
  description = "The name of the HTTP proxy"
  type        = string
}

variable "url_map_name" {
  description = "The name of the URL map"
  type        = string
}

variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "instance_template_name" {
  description = "The name of the instance template"
  type        = string
}

variable "health_check_name" {
  description = "The name of the health check"
  type        = string
}

variable "instance_group_manager_name" {
  description = "The name of the instance group manager"
  type        = string
}

variable "firewall_name" {
  description = "The name of the firewall"
  type        = string
}

variable "port_name" {
  description = "The port name for the backend service"
  type        = string
}

variable "port_range" {
  description = "The port range for the forwarding rule"
  type        = string
}

variable "protocol" {
  description = "The protocol for the backend service"
  type        = string
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme for the backend service"
  type        = string
}

variable "timeout_sec" {
  description = "The timeout in seconds for the backend service"
  type        = number
}

variable "custom_request_headers" {
  description = "Custom request headers for the backend service"
  type        = list(string)
}

variable "custom_response_headers" {
  description = "Custom response headers for the backend service"
  type        = list(string)
}

variable "source_ranges" {
  description = "Source ranges for the firewall"
  type        = list(string)
}

variable "target_tags" {
  description = "Target tags for the firewall"
  type        = list(string)
}





variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "auto_create_subnetworks" {
  description = "Auto create subnetworks"
  type        = bool
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "IP CIDR range of the subnet"
  type        = string
}

variable "region" {
  description = "Region for the resources"
  type        = string
}

variable "reserved_ip_name" {
  description = "Name of the reserved IP address"
  type        = string
}

variable "forwarding_rule_name" {
  description = "Name of the forwarding rule"
  type        = string
}

variable "ip_protocol" {
  description = "IP protocol for the forwarding rule"
  type        = string
}

variable "load_balancing_scheme" {
  description = "Load balancing scheme"
  type        = string
}

variable "port_range" {
  description = "Port range for the forwarding rule"
  type        = string
}

variable "http_proxy_name" {
  description = "Name of the HTTP proxy"
  type        = string
}

variable "url_map_name" {
  description = "Name of the URL map"
  type        = string
}

variable "backend_service_name" {
  description = "Name of the backend service"
  type        = string
}

variable "backend_protocol" {
  description = "Protocol for the backend service"
  type        = string
}

variable "backend_port_name" {
  description = "Port name for the backend service"
  type        = string
}

variable "backend_load_balancing_scheme" {
  description = "Load balancing scheme for the backend service"
  type        = string
}

variable "backend_timeout_sec" {
  description = "Timeout in seconds for the backend service"
  type        = number
}

variable "backend_enable_cdn" {
  description = "Enable CDN for the backend service"
  type        = bool
}

variable "backend_custom_request_headers" {
  description = "Custom request headers for the backend service"
  type        = list(string)
}

variable "backend_custom_response_headers" {
  description = "Custom response headers for the backend service"
  type        = list(string)
}

variable "backend_balancing_mode" {
  description = "Balancing mode for the backend service"
  type        = string
}

variable "backend_capacity_scaler" {
  description = "Capacity scaler for the backend service"
  type        = number
}

variable "instance_template_name" {
  description = "Name of the instance template"
  type        = string
}

variable "instance_machine_type" {
  description = "Machine type for the instance template"
  type        = string
}

variable "instance_tags" {
  description = "Tags for the instance template"
  type        = list(string)
}

variable "instance_source_image" {
  description = "Source image for the instance template"
  type        = string
}

variable "instance_auto_delete" {
  description = "Auto delete for the instance template"
  type        = bool
}

variable "instance_boot" {
  description = "Boot disk for the instance template"
  type        = bool
}

variable "instance_startup_script" {
  description = "Startup script for the instance template"
  type        = string
}

variable "instance_create_before_destroy" {
  description = "Create before destroy lifecycle for the instance template"
  type        = bool
}

variable "health_check_name" {
  description = "Name of the health check"
  type        = string
}

variable "health_check_port_specification" {
  description = "Port specification for the health check"
  type        = string
}

variable "instance_group_manager_name" {
  description = "Name of the instance group manager"
  type        = string
}

variable "instance_group_manager_zone" {
  description = "Zone for the instance group manager"
  type        = string
}

variable "instance_group_manager_named_port_name" {
  description = "Named port name for the instance group manager"
  type        = string
}

variable "instance_group_manager_named_port" {
  description = "Named port for the instance group manager"
  type        = number
}

variable "instance_group_manager_version_name" {
  description = "Version name for the instance group manager"
  type        = string
}

variable "instance_group_manager_base_instance_name" {
  description = "Base instance name for the instance group manager"
  type        = string
}

variable "instance_group_manager_target_size" {
  description = "Target size for the instance group manager"
  type        = number
}

variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "firewall_direction" {
  description = "Direction for the firewall"
  type        = string
}

variable "firewall_source_ranges" {
  description = "Source ranges for the firewall"
  type        = list(string)
}

variable "firewall_protocol" {
  description = "Protocol for the firewall"
  type        = string
}

variable "firewall_target_tags" {
  description = "Target tags for the firewall"
  type        = list(string)
}



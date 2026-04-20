variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "management_subnet_cidr" {
  description = "CIDR for management subnet"
  type        = string
}

variable "workload_subnet_cidr" {
  description = "CIDR for workload subnet"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary CIDR for GKE pods"
  type        = string
}

variable "services_cidr" {
  description = "Secondary CIDR for GKE services"
  type        = string
}

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

variable "network" {
  description = "The VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork name"
  type        = string
}

variable "pods_range_name" {
  description = "The name of the secondary range for pods"
  type        = string
}

variable "services_range_name" {
  description = "The name of the secondary range for services"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "prod-cluster"
}

variable "standard_machine_type" {
  description = "Machine type for standard node pool"
  type        = string
  default     = "e2-micro"
}

variable "spot_machine_type" {
  description = "Machine type for spot node pool"
  type        = string
  default     = "e2-medium"
}

variable "spot_min_nodes" {
  description = "Minimum nodes in spot pool"
  type        = number
  default     = 0
}

variable "spot_max_nodes" {
  description = "Maximum nodes in spot pool"
  type        = number
  default     = 3
}

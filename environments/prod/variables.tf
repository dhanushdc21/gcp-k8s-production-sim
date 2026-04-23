variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for all resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for zonal resources"
  type        = string
  default     = "us-central1-a"
}

variable "management_subnet_cidr" {
  description = "CIDR range for the management VPC subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "workload_subnet_cidr" {
  description = "CIDR range for the workload VPC subnet"
  type        = string
  default     = "10.1.0.0/24"
}

variable "pods_cidr" {
  description = "Secondary CIDR range for GKE pods"
  type        = string
  default     = "10.2.0.0/16"
}

variable "services_cidr" {
  description = "Secondary CIDR range for GKE services"
  type        = string
  default     = "10.3.0.0/16"
}

variable "github_org" {
  description = "GitHub username or organization"
  type        = string
  default     = "dhanushdc21"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "gcp-k8s-production-sim"
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = "prod-cluster"
}

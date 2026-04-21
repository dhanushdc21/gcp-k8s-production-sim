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
  description = "The VPC network name to attach NAT to"
  type        = string
}

variable "subnet" {
  description = "The subnet name to attach NAT to"
  type        = string
}

variable "nat_machine_type" {
  description = "Machine type for NAT instance"
  type        = string
  default     = "e2-micro"
}

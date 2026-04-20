terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "k8s-prod-sim-tfstate"
    prefix = "prod/terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "vpc" {
  source = "../../modules/vpc"

  project_id             = var.project_id
  region                 = var.region
  management_subnet_cidr = var.management_subnet_cidr
  workload_subnet_cidr   = var.workload_subnet_cidr
  pods_cidr              = var.pods_cidr
  services_cidr          = var.services_cidr
}

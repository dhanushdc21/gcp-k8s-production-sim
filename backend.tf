terraform {
  backend "gcs" {
    bucket = "k8s-prod-sim-tfstate"
    prefix = "prod/terraform/state"
  }
}

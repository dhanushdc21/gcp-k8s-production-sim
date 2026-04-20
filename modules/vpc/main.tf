resource "google_compute_network" "management_vpc" {
  name                    = "management-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_network" "workload_vpc" {
  name                    = "workload-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "management_subnet" {
  name                     = "management-subnet"
  ip_cidr_range            = var.management_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.management_vpc.id
  project                  = var.project_id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "workload_subnet" {
  name                     = "workload-subnet"
  ip_cidr_range            = var.workload_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.workload_vpc.id
  project                  = var.project_id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_compute_firewall" "management_allow_internal" {
  name    = "management-allow-internal"
  network = google_compute_network.management_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.management_subnet_cidr]
}

resource "google_compute_firewall" "workload_allow_internal" {
  name    = "workload-allow-internal"
  network = google_compute_network.workload_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.workload_subnet_cidr,
    var.pods_cidr,
    var.services_cidr
  ]
}

resource "google_compute_firewall" "workload_allow_health_checks" {
  name    = "workload-allow-health-checks"
  network = google_compute_network.workload_vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

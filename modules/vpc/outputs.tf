output "management_vpc_id" {
  description = "The ID of the management VPC"
  value       = google_compute_network.management_vpc.id
}

output "workload_vpc_id" {
  description = "The ID of the workload VPC"
  value       = google_compute_network.workload_vpc.id
}

output "workload_subnet_id" {
  description = "The ID of the workload subnet"
  value       = google_compute_subnetwork.workload_subnet.id
}

output "workload_subnet_name" {
  description = "The name of the workload subnet"
  value       = google_compute_subnetwork.workload_subnet.name
}

output "pods_range_name" {
  description = "The name of the pods secondary range"
  value       = "pods"
}

output "services_range_name" {
  description = "The name of the services secondary range"
  value       = "services"
}

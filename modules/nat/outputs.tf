output "nat_gateway_ip" {
  description = "The public IP of the NAT gateway"
  value       = google_compute_address.nat_external_ip.address
}

output "nat_gateway_instance_name" {
  description = "The name of the NAT gateway instance"
  value       = google_compute_instance.nat_gateway.name
}

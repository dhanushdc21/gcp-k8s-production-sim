output "management_vpc_id" {
  description = "The ID of the management VPC"
  value       = module.vpc.management_vpc_id
}

output "workload_vpc_id" {
  description = "The ID of the workload VPC"
  value       = module.vpc.workload_vpc_id
}

output "workload_subnet_id" {
  description = "The ID of the workload subnet"
  value       = module.vpc.workload_subnet_id
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT gateway"
  value       = module.nat.nat_gateway_ip
}

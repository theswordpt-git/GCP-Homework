output "vpc_name" {
  description = "Name of the GCP VPC"
  value       = module.vpc.network_name
}
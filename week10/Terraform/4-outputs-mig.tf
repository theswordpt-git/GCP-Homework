#Chewbacca: MIG reference info (Terraform-friendly)
output "mig_name" {
  value = google_compute_instance_group_manager.chewbacca_mig.name
}

output "mig_zone" {
  value = google_compute_instance_group_manager.chewbacca_mig.zone
}

output "mig_target_size" {
  value = google_compute_instance_group_manager.chewbacca_mig.target_size
}

output "mig_self_link" {
  value = google_compute_instance_group_manager.chewbacca_mig.self_link
}

output "mig_instance_template" {
  value = google_compute_instance_group_manager.chewbacca_mig.version[0].instance_template
}

#Chewbacca: Instance group for backend services / LB
output "mig_instance_group" {
  value = google_compute_instance_group_manager.chewbacca_mig.instance_group
}

#Chewbacca: Named port to access HTTP service
output "mig_named_ports" {
  value = google_compute_instance_group_manager.chewbacca_mig.named_port
}


output "chewbacca_lb_ip" {
  value = google_compute_global_forwarding_rule.chewbacca_forward.ip_address
}

output "chewbacca_lb_url" {
  value = "http://${google_compute_global_forwarding_rule.chewbacca_forward.ip_address}"
}

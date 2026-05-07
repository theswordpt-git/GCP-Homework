#Chewbacca: Outputs are how automation speaks to other automation.
output "vm_external_ip" {
  value = google_compute_instance.chewbacca_vm.network_interface[0].access_config[0].nat_ip
}

#as requested for this assignement
output "vm_internal_ip" {
  value = google_compute_instance.chewbacca_vm.network_interface[0].network_ip
}



output "vm_url" {
  value = "http://${google_compute_instance.chewbacca_vm.network_interface[0].access_config[0].nat_ip}"
}



#also wanted by this assignment
output "vm_name" {
  value = google_compute_instance.chewbacca_vm.name
}

output "vm_id" {
  value = google_compute_instance.chewbacca_vm.id
}

output "vm_self_link" {
  value = google_compute_instance.chewbacca_vm.self_link
}

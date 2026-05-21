resource "google_compute_global_address" "chewbacca_ip" {
  name = "chewbacca-ip"
}

resource "google_compute_global_forwarding_rule" "chewbacca_forward" {
  name        = "chewbacca-forward"
  target      = google_compute_target_http_proxy.chewbacca_proxy.id
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = google_compute_global_address.chewbacca_ip.address
}

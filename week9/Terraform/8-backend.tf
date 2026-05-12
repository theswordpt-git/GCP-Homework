resource "google_compute_backend_service" "chewbacca_backend" {
  name                  = "chewbacca-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.chewbacca_http.id]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group_manager.chewbacca_mig.instance_group
  }
}


resource "google_compute_url_map" "chewbacca_map" {
  name            = "chewbacca-map"
  default_service = google_compute_backend_service.chewbacca_backend.id
}


resource "google_compute_target_http_proxy" "chewbacca_proxy" {
  name    = "chewbacca-proxy"
  url_map = google_compute_url_map.chewbacca_map.id
}

resource "google_compute_global_forwarding_rule" "chewbacca_forward" {
  name       = "chewbacca-forward"
  target     = google_compute_target_http_proxy.chewbacca_proxy.id
  port_range = "80"
  ip_protocol = "TCP"
}

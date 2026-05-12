resource "google_compute_health_check" "chewbacca_http" {
  name               = "chewbacca-http-hc"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 1
  unhealthy_threshold = 3

  http_health_check {
    #request_path = "/healthz"
    request_path = "/"
    port         = 80
  }
}

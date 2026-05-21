#Chewbacca: HTTP access for tagged instances
resource "google_compute_firewall" "chewbacca_allow_http" {
  name    = "chewbacca-allow-http"
  network = google_compute_network.chewbacca_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["chewbacca-web"]
}

#Chewbacca: SSH access for tagged instances (optional)
resource "google_compute_firewall" "chewbacca_allow_ssh" {
  name    = "chewbacca-allow-ssh"
  network = google_compute_network.chewbacca_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["chewbacca-web"]
}

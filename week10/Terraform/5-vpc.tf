#Chewbacca: The custom hyperspace lane—your very own VPC.
resource "google_compute_network" "chewbacca_vpc" {
  name                    = "chewbacca-vpc"
  auto_create_subnetworks = false
}

#Chewbacca: A subnet in our hyperspace lane.
resource "google_compute_subnetwork" "chewbacca_subnet" {
  name          = "chewbacca-subnet"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.chewbacca_vpc.id
}

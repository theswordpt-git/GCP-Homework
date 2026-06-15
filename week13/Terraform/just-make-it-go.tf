# ---------------------------------------------------------------------------
# VARIABLES & PROVIDER
# ---------------------------------------------------------------------------
provider "google" {
  project = "linear-trees-490622-d3" # Replace with your actual project ID
  region  = "us-central1"         # Replace with your desired region
}

variable "region" {
  default = "us-central1"
}

# ---------------------------------------------------------------------------
# VPC & SUBNET CREATION
# ---------------------------------------------------------------------------

# --- VPC 1 ---
resource "google_compute_network" "vpc1" {
  name                    = "screenshot2-vpc1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_vpc1" {
  name          = "subnet-vpc1"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc1.id
}

# --- VPC 2 ---
resource "google_compute_network" "vpc2" {
  name                    = "screenshot2-vpc2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_vpc2" {
  name          = "subnet-vpc2"
  ip_cidr_range = "10.2.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc2.id
}

# ---------------------------------------------------------------------------
# FIREWALL RULES
# ---------------------------------------------------------------------------

# Allow VPC2 subnet to talk to VPC1
resource "google_compute_firewall" "allow_vpc2_to_vpc1" {
  name    = "allow-vpn-from-vpc2"
  network = google_compute_network.vpc1.name

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.2.0.0/24"]
}

# Allow VPC1 subnet to talk to VPC2
resource "google_compute_firewall" "allow_vpc1_to_vpc2" {
  name    = "allow-vpn-from-vpc1"
  network = google_compute_network.vpc2.name

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.1.0.0/24"]
}

# ---------------------------------------------------------------------------
# CLOUD ROUTERS (With custom subnet advertisement)
# ---------------------------------------------------------------------------
resource "google_compute_router" "router_vpc1" {
  name    = "router-vpc1"
  network = google_compute_network.vpc1.name
  region  = var.region
  
  bgp {
    asn            = 65001
    advertise_mode = "CUSTOM"
    
    advertised_ip_ranges {
      range       = "10.1.0.0/24"
      description = "VPC1 Subnet Range"
    }
  }
}

resource "google_compute_router" "router_vpc2" {
  name    = "router-vpc2"
  network = google_compute_network.vpc2.name
  region  = var.region
  
  bgp {
    asn            = 65002
    advertise_mode = "CUSTOM"
    
    advertised_ip_ranges {
      range       = "10.2.0.0/24"
      description = "VPC2 Subnet Range"
    }
  }
}

# ---------------------------------------------------------------------------
# HA VPN GATEWAYS
# ---------------------------------------------------------------------------
resource "google_compute_ha_vpn_gateway" "ha_gateway_vpc1" {
  name    = "ha-vpn-gateway-vpc1"
  network = google_compute_network.vpc1.id
  region  = var.region
}

resource "google_compute_ha_vpn_gateway" "ha_gateway_vpc2" {
  name    = "ha-vpn-gateway-vpc2"
  network = google_compute_network.vpc2.id
  region  = var.region
}

# ---------------------------------------------------------------------------
# VPN TUNNELS (Fixed arguments for GCP-to-GCP HA VPN)
# ---------------------------------------------------------------------------

# --- Tunnel 0: VPC1 to VPC2 ---
resource "google_compute_vpn_tunnel" "tunnel_vpc1_to_vpc2_0" {
  name                  = "tunnel-vpc1-to-vpc2-0"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_vpc1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_vpc2.id
  shared_secret         = "super-secret-shared-key-1"
  router                = google_compute_router.router_vpc1.id
  vpn_gateway_interface = 0
}

# --- Tunnel 1: VPC1 to VPC2 ---
resource "google_compute_vpn_tunnel" "tunnel_vpc1_to_vpc2_1" {
  name                  = "tunnel-vpc1-to-vpc2-1"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_vpc1.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_vpc2.id
  shared_secret         = "super-secret-shared-key-2"
  router                = google_compute_router.router_vpc1.id
  vpn_gateway_interface = 1
}

# --- Tunnel 0: VPC2 to VPC1 ---
resource "google_compute_vpn_tunnel" "tunnel_vpc2_to_vpc1_0" {
  name                  = "tunnel-vpc2-to-vpc1-0"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_vpc2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_vpc1.id
  shared_secret         = "super-secret-shared-key-1" # Must match tunnel_vpc1_to_vpc2_0
  router                = google_compute_router.router_vpc2.id
  vpn_gateway_interface = 0
}

# --- Tunnel 1: VPC2 to VPC1 ---
resource "google_compute_vpn_tunnel" "tunnel_vpc2_to_vpc1_1" {
  name                  = "tunnel-vpn-to-vpc1-1"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway_vpc2.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway_vpc1.id
  shared_secret         = "super-secret-shared-key-2" # Must match tunnel_vpc1_to_vpc2_1
  router                = google_compute_router.router_vpc2.id
  vpn_gateway_interface = 1
}

# ---------------------------------------------------------------------------
# BGP INTERFACES & PEERS (Tunnel 0)
# ---------------------------------------------------------------------------
resource "google_compute_router_interface" "router_vpc1_if0" {
  name       = "router-vpc1-if0"
  router     = google_compute_router.router_vpc1.name
  region     = var.region
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_vpc1_to_vpc2_0.name
}

resource "google_compute_router_peer" "router_vpc1_peer0" {
  name            = "router-vpc1-peer0"
  router          = google_compute_router.router_vpc1.name
  region          = var.region
  peer_ip_address = "169.254.1.2"
  peer_asn        = 65002
  interface       = google_compute_router_interface.router_vpc1_if0.name
}

resource "google_compute_router_interface" "router_vpc2_if0" {
  name       = "router-vpc2-if0"
  router     = google_compute_router.router_vpc2.name
  region     = var.region
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_vpc2_to_vpc1_0.name
}

resource "google_compute_router_peer" "router_vpc2_peer0" {
  name            = "router-vpc2-peer0"
  router          = google_compute_router.router_vpc2.name
  region          = var.region
  peer_ip_address = "169.254.1.1"
  peer_asn        = 65001
  interface       = google_compute_router_interface.router_vpc2_if0.name
}

# ---------------------------------------------------------------------------
# BGP INTERFACES & PEERS (Tunnel 1)
# ---------------------------------------------------------------------------
resource "google_compute_router_interface" "router_vpc1_if1" {
  name       = "router-vpc1-if1"
  router     = google_compute_router.router_vpc1.name
  region     = var.region
  ip_range   = "169.254.2.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_vpc1_to_vpc2_1.name
}

resource "google_compute_router_peer" "router_vpc1_peer1" {
  name            = "router-vpc1-peer1"
  router          = google_compute_router.router_vpc1.name
  region          = var.region
  peer_ip_address = "169.254.2.2"
  peer_asn        = 65002
  interface       = google_compute_router_interface.router_vpc1_if1.name
}

resource "google_compute_router_interface" "router_vpc2_if1" {
  name       = "router-vpc2-if1"
  router     = google_compute_router.router_vpc2.name
  region     = var.region
  ip_range   = "169.254.2.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_vpc2_to_vpc1_1.name
}

resource "google_compute_router_peer" "router_vpc2_peer1" {
  name            = "router-vpc2-peer1"
  router          = google_compute_router.router_vpc2.name
  region          = var.region
  peer_ip_address = "169.254.2.1"
  peer_asn        = 65001
  interface       = google_compute_router_interface.router_vpc2_if1.name
}

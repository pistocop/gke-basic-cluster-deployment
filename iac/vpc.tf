# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.gcp_project_id}-gkedeploy-vpc"
  auto_create_subnetworks = "false"
}

# GKE Subnet
resource "google_compute_subnetwork" "subnet" {
  name                     = "${var.gcp_project_id}-gkedeploy-subnet"
  region                   = var.gcp_default_region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.10.0.0/24"
  private_ip_google_access = true

  depends_on = [
    google_compute_network.vpc
  ]
}

# Proxy-only subnet for LB: https://cloud.google.com/load-balancing/docs/proxy-only-subnets
resource "google_compute_subnetwork" "lb-proxy-only-subnet" {
  name          = "${var.gcp_project_id}-gkedeploy-lb-proxy-only-subnet"
  region        = var.gcp_default_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.14.0.0/23" # The recommended subnet size is /23 (512 proxy-only addresses).


  purpose = "REGIONAL_MANAGED_PROXY"
  role    = "ACTIVE"

  depends_on = [
    google_compute_network.vpc
  ]
}
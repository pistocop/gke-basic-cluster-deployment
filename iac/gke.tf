# Official doc: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster

resource "google_service_account" "gkedeploy_sa" {
  account_id   = "gkedeploy-sa"
  display_name = "Service Account"
}

resource "google_container_cluster" "gkedeploy_zonal_cluster" {
  count = var.deploy_cluster ? 1 : 0

  name     = "gkedeploy-cluster"
  location = var.gcp_default_zone

  # create the smallest possible default node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.13.0.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }

  depends_on = [
    google_compute_subnetwork.subnet,
    google_service_account.gkedeploy_sa
  ]
}

resource "google_container_node_pool" "gkedeploy_cheappool" {
  count      = var.deploy_cluster ? 1 : 0
  name       = "gkedeploy-cheappool"
  location   = var.gcp_default_zone
  cluster    = google_container_cluster.gkedeploy_zonal_cluster[0].id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
    disk_size_gb = 30

    # The service account to be used by the Node VMs, grant permission through IAM
    service_account = google_service_account.gkedeploy_sa.email
  }

  depends_on = [
    google_container_cluster.gkedeploy_zonal_cluster[0],
    google_compute_subnetwork.subnet,
    google_service_account.gkedeploy_sa
  ]
}

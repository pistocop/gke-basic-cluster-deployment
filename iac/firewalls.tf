resource "google_compute_firewall" "fw-iap" {
  name      = "gkdeploy-fw-iap"
  network   = google_compute_network.vpc.name
  priority  = 1000
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}
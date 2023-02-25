terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.47.0"
    }
  }

  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }

  required_version = "~> 1.3.6"
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_default_region
}

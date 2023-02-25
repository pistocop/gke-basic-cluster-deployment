# https://developer.hashicorp.com/terraform/language/values/variables

variable "gcp_project_id" {
  type        = string
  description = "The GCP project id"
}

variable "gcp_default_region" {
  type        = string
  description = "The GCP region where create the resources"
  default     = "us-central1"
}

variable "gcp_default_zone" {
  type        = string
  description = "The GCP zone where create the resources"
  default     = "us-central1-a"
}

variable "deploy_cluster" {
  type        = bool
  default     = true
  description = "set to `false` to remove the GKE"
}

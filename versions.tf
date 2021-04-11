terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }

  required_version = "~> 0.14"
}

provider "google" {
  credentials = file("Projecto-demo-dea218aad50c.json")
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  credentials = file("Projecto-demo-dea218aad50c.json")
  project = var.project_id
  region  = var.region
}

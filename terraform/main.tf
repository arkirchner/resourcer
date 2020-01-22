variable "location" {
  default = "asia"
}

provider "google" {
  project = "resourcer"
  region  = var.location
  version = "3.4.0"
}

provider "random" {
  version = "2.2.1"
}

resource "google_project" "resourcer" {
  name       = "resourcer"
  project_id = "resourcer"
}

resource "random_id" "buckets_id" {
  byte_length = 8
}

resource "google_project_service" "cloud_storage" {
  project = google_project.resourcer.project_id
  service = "storage-component.googleapis.com"

  disable_dependent_services = true
}

resource "google_storage_bucket" "assets" {
  name          = "resourcer-assets-${random_id.buckets_id.hex}"
  project       = google_project.resourcer.project_id
  storage_class = "MULTI_REGIONAL"
  location      = var.location

  cors {
    origin = ["*"]
    method = ["GET", "OPTIONS"]
  }

  depends_on = [google_project_service.cloud_storage]
}

resource "google_storage_bucket" "storage" {
  name          = "resourcer-storage-${random_id.buckets_id.hex}"
  project       = google_project.resourcer.project_id
  storage_class = "MULTI_REGIONAL"
  location      = var.location

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.cloud_storage]
}

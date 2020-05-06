variable "location" {
  default = "us"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-f"
}

variable "zones" {
  type    = list(string)
  default = ["us-central1-f"]
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-ca5b66a4762b648f"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "resourcer"
  region  = var.location
  version = "3.30.0"
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

resource "google_project_service" "iam" {
  project = google_project.resourcer.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloud_sql" {
  project = google_project.resourcer.project_id
  service = "sqladmin.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "kms" {
  project = google_project.resourcer.project_id
  service = "cloudkms.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "servicenetworking" {
  project = google_project.resourcer.project_id
  service = "servicenetworking.googleapis.com"

  disable_dependent_services = true
}

resource "google_storage_bucket" "tf_state" {
  name          = "tf-state-${random_id.buckets_id.hex}"
  project       = google_project.resourcer.project_id
  location      = var.location

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.cloud_storage]
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

resource "google_service_account" "active_storage_users" {
  project      = google_project.resourcer.project_id
  account_id   = "active-storage-resourcer"
  display_name = "Active Storage user for Resourcer"

  depends_on = [google_project_service.iam]
}

resource "google_storage_bucket_iam_member" "active_storage_admin" {
  bucket = google_storage_bucket.storage.name
  role = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.active_storage_users.email}"
}

resource "google_storage_bucket_acl" "storage_acl" {
  bucket = google_storage_bucket.storage.name
  role_entity = [
    "OWNER:project-editors-${google_project.resourcer.number}",
    "OWNER:project-owners-${google_project.resourcer.number}",
    "READER:project-viewers-${google_project.resourcer.number}",
    "READER:user-${google_service_account.active_storage_users.email}",
  ]

  depends_on = [google_storage_bucket_iam_member.active_storage_admin]
}

resource "google_service_account_key" "active_storage_key" {
  service_account_id = google_service_account.active_storage_users.name
}

resource "random_id" "db_name_suffix" {
  byte_length = 5
}

data "google_compute_network" "default" {
  name    = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.id

  depends_on = [google_project_service.servicenetworking]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "master" {
  name = "instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_11"
  region = var.region
  project = google_project.resourcer.project_id

  settings {
    tier = "db-f1-micro"

    location_preference {
      zone = var.zone
    }

    ip_configuration {
      ipv4_enabled    = "true"
      private_network = data.google_compute_network.default.id
    }
  }

  depends_on = [
    google_project_service.cloud_sql,
    google_service_networking_connection.private_vpc_connection
  ]
}

output "db_private_ip" {
  value = google_sql_database_instance.master.private_ip_address
}

resource "random_string" "secret_key_base" {
  length = 128
  special = false
}

resource "random_string" "db_password" {
  length = 128
  special = false
}

data "google_container_registry_image" "resourcer" {
  project = google_project.resourcer.project_id
  tag = "latest"
  name = "resourcer"
}

resource "google_kms_key_ring" "resourcer" {
  project = google_project.resourcer.project_id
  name     = "resourcer-key-ring"
  location = var.location

  depends_on = [google_project_service.kms]
}

resource "google_kms_crypto_key" "resourcer" {
  name     = "resourcer-crypto-key"
  key_ring = google_kms_key_ring.resourcer.self_link
}

data "google_kms_secret" "github_secret_key" {
  crypto_key = google_kms_crypto_key.resourcer.self_link
  ciphertext = "CiQAS5YnWgrboIo8JTCBzDTiJxf4GiiiSYFRZ0pVfgja94NrXkASUQAwGg5LYTWvTRGVyLha9emUVGW1gE2Jh8VcOMlq3CU67BP36WpXe2kiwO2a64EY5KJfM4rEr4Vj9mCd4oiLSJg/RLHHGl8pogjiUQY8emERIw=="
}

data "google_kms_secret" "google_secret_key" {
  crypto_key = google_kms_crypto_key.resourcer.self_link
  ciphertext = "CiQAS5YnWk0Ozt4vUwFG5F4rB6hmSprxi0halL1/GFfC8Weprh8SQQAwGg5LVSm1p9jP6S8EPF4kkIq71tgGmuttzZ89hzQ2SMjIPVwOTRCzlq/li2WzTyzm6Pcs8mLQDFil5iWiqnPD"
}

data "google_kms_secret" "sentry_dns" {
  crypto_key = google_kms_crypto_key.resourcer.self_link
  ciphertext = "CiQAS5YnWsCnoIrPG6A2NY1UzSZMFv9sLqFr/RalS4yghKNb5TcSkwEAMBoOS5QS+MLlmPX+tzqM+O42UvCCrqQE6yE0nglHEbkOCulaJ8cykPn2BJXKBR/tH97uOxwiAAbZ5oBRsFulO5swPCy35LpFcx+h/fCPiY7tg6SLmyjiAFNTNDrhSkbN/s6h4mowdC24JlW8CfWt+PzphE7DTLvLtiALlVQWCKBuy6V6OhHJ+8od9U+4YngZuqI="
}

data "google_kms_secret" "appsignal_api_key" {
  crypto_key = google_kms_crypto_key.resourcer.self_link
  ciphertext = "CiQAS5YnWgOOrNTmfGIV4LttmQTxhhaj8rRXGtYfS4PXIE+DTMsSTQAwGg5Lwebx5Yj1BPTf2sq2DHSkNR+peI7m4657nV7UCsq5ltbR0C77FKORnMZjfklPcPkIPzAp2fHJJXh4Ux2GrbZlFu5w0Dq8QZbz"
}

resource "google_service_account" "resourcer" {
  account_id   = "resourcer-app"
  display_name = "Resourcer App Runner"
}

resource "google_project_iam_member" "resourcer" {
  project = google_project.resourcer.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.resourcer.email}"
}

data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.region
}

data "google_iam_policy" "public_invoke" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_sql_user" "resourcer" {
  project = google_project.resourcer.project_id
  name = "resourcer_production"
  instance = google_sql_database_instance.master.name
  password = random_string.db_password.result
}

resource "google_sql_database" "database" {
  project = google_project.resourcer.project_id
  name = "resourcer_production"
  instance = google_sql_database_instance.master.name
}

resource "google_service_account" "deployer" {
  project = google_project.resourcer.project_id
  account_id   = "resourcer-deployer"
  display_name = "Application Deployer for Resourcer"

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "deployer" {
  project = google_project.resourcer.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_service_account_key" "deployer" {
  service_account_id = google_service_account.deployer.name
}

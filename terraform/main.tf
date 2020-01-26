variable "location" {
  default = "us"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-f"
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

resource "google_project_service" "iam" {
  project = google_project.resourcer.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloud_run" {
  project = google_project.resourcer.project_id
  service = "run.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "cloud_sql" {
  project = google_project.resourcer.project_id
  service = "sqladmin.googleapis.com"

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
  }

  depends_on = [google_project_service.cloud_sql]
}

resource "random_string" "secret_key_base" {
  length = 128
  special = false
}

resource "random_string" "db_password" {
  length = 128
  special = false
}

resource "google_cloud_run_service" "resourcer" {
  name = "resourcer"
  project = google_project.resourcer.project_id
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "1000"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.master.connection_name
      }
    }

    spec {
      container_concurrency = 80

      containers {
        image = "gcr.io/cloudrun/hello"

        env {
          name = "SECRET_KEY_BASE"
          value = random_string.secret_key_base.result
        }
        env {
          name = "DB_PASSWORD"
          value = random_string.db_password.result
        }
        env {
          name = "BUCKET_CREDENTIALS"
          value = google_service_account_key.active_storage_key.private_key
        }
        env {
          name = "BUCKET"
          value = google_storage_bucket.storage.name
        }
        env {
          name = "PROJECT_ID"
          value = google_project.resourcer.project_id
        }

        resources {
          limits   = {
            "cpu"    = "1000m"
            "memory" = "256M"
          }
          requests = {}
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.cloud_run]
}

data "google_iam_policy" "public_invoke" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "public_invoke" {
  location = var.region
  project = google_project.resourcer.project_id
  service = google_cloud_run_service.resourcer.name
  policy_data = data.google_iam_policy.public_invoke.policy_data
}

resource "google_sql_user" "resourcer" {
  project = google_project.resourcer.project_id
  name     = "resourcer_production"
  instance = google_sql_database_instance.master.name
  password = random_string.db_password.result
}

resource "google_sql_database" "database" {
  project = google_project.resourcer.project_id
  name     = "resourcer_production"
  instance = google_sql_database_instance.master.name
}

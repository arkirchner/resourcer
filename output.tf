output "project_id" {
  value = google_project.resourcer.project_id
}

output "location" {
  value = var.location
}

output "key_ring_name" {
  value = google_kms_key_ring.resourcer.name
}

output "crypto_key_name" {
  value = google_kms_crypto_key.resourcer.name
}

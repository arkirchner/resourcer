# provider "kuberne#tes" {
#   load_config_file = "false"
# 
#   host = google_container_cluster.primary.endpoint
#   token = data.google_client_config.current.access_token
#   client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
#   client_key = base64decode(google_container_cluster.primary.master_auth.0.client_key)
#   cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
# }
# 
# provider "helm" {
#   version = "1.2.0"
# 
#   kubernetes {
#     load_config_file = "false"
# 
#     host = google_container_cluster.primary.endpoint
#     token = data.google_client_config.current.access_token
#     client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
#     client_key = base64decode(google_container_cluster.primary.master_auth.0.client_key)
#     cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
#   }
# }
# 
# data "google_kms_secret" "cloudflare_token" {
#   crypto_key = google_kms_crypto_key.resourcer.self_link
#   ciphertext = "CiQAS5YnWutyL0o6nSUs9lmd0FHKdIPN0P4WKcvSnEjlVQ4ioRASUQAwGg5LJ3wSVIJYtJZHHAUKSDkwy0bT1nCAU7cXQsIu2wAFXI1WZuI/L60LnNw0sQNVbHhUuOC36NRq71hvBBdhjEecxatd5hjoAvgrs+Bo9w=="
# }
# 
# resource "kubernetes_namespace" "cert_manager" {
#   metadata {
#     name = "cert-manager"
#   }
# }

# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   namespace  = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "v0.15.1"
# 
#   set {
#     name = "installCRDs"
#     value = "true"
#   }
# 
#   depends_on = [kubernetes_namespace.cert_manager]
# }

# resource "kubernetes_namespace" "external_dns" {
#   metadata {
#     name = "external-dns"
#   }
# }

# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   namespace  = "external-dns"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "external-dns"
#   version    = "3.1.2"
# 
#   set {
#     name = "provider"
#     value = "cloudflare"
#   }
# 
#   set {
#     name  = "cloudflare.apiToken"
#     value = data.google_kms_secret.cloudflare_token.plaintext
#   }
# 
#   depends_on = [kubernetes_namespace.external_dns]
# }

# data "google_client_config" "current" {
# }
# 
# resource "helm_release" "akrobateo" {
#   name = "akrobateo"
#   chart = "./akrobateo"
# }
# 
# resource "kubernetes_namespace" "ingress_nginx" {
#   metadata {
#     name = "ingress-nginx"
#   }
# }

# resource "helm_release" "ingress_nginx" {
#   name       = "ingress-nginx"
#   namespace  = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "2.3.0"
# 
#   depends_on = [kubernetes_namespace.ingress_nginx]
# }

# resource "google_container_cluster" "primary" {
#   name     = "primary-gke-cluster"
#   location = var.zone
#   project = google_project.resourcer.project_id
# 
#   ip_allocation_policy {}
#   # We can't create a cluster with no node pool defined, but we want to only use
#   # separately managed node pools. So we create the smallest possible default
#   # node pool and immediately delete it.
#   remove_default_node_pool = true
#   initial_node_count = 1
# }

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name = "primary-preemptible-node-pool"
#   location = var.zone
#   cluster = google_container_cluster.primary.name
#   node_count = 1
# 
#   node_config {
#     preemptible  = true
#     machine_type = "e2-medium"
# 
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/service.management.readonly",
#       "https://www.googleapis.com/auth/servicecontrol",
#       # "https://www.googleapis.com/auth/trace.append",
#     ]
#   }
# }

# resource "google_compute_firewall" "default" {
#   name = "http-https"
#   network = google_container_cluster.primary.network
# 
#   allow {
#     protocol = "tcp"
#     ports    = ["80", "443"]
#   }
# 
#   source_ranges = ["0.0.0.0/0"]
# }

resource "kubernetes_namespace" "resourcer" {
  metadata {
    name = "resourcer"
  }
}

resource "kubernetes_secret" "resourcer" {
  metadata {
    name      = "resourcer"
    namespace = "resourcer"
  }

  data = {
    secret_key_base = random_string.secret_key_base.result
    db_password = random_string.db_password.result
    active_storage_key = google_service_account_key.active_storage_key.private_key
    sentry_dns = data.google_kms_secret.sentry_dns.plaintext
    appsignal_push_api_key = data.google_kms_secret.appsignal_api_key.plaintext
    github_secret = data.google_kms_secret.github_secret_key.plaintext
    google_client_secret = data.google_kms_secret.google_secret_key.plaintext
    redis_password = random_string.redis_password.result
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.resourcer]
}

resource "random_string" "redis_password" {
  length = 30
  special = false
}

resource "helm_release" "redis" {
  name       = "redis"
  namespace = "resourcer"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  # version    = "v0.15.1"

  set {
    name = "cluster.enabled"
    value = "false"
  }

  set {
    name = "master.persistence.size"
    value = "300Mi"
  }

  set {
    name = "password"
    value = random_string.redis_password.result
  }

  depends_on = [kubernetes_namespace.resourcer]
}

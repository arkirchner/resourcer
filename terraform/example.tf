# resource "kubernetes_deployment" "example" {
#   metadata {
#     name = "my-deployment-50000"
#   }
# 
#   spec {
#     replicas = 1
# 
#     selector {
#       match_labels = {
#         app = "metrics"
#         department = "engineering"
#       }
#     }
# 
#     template {
#       metadata {
#         labels = {
#           app = "metrics"
#           department = "engineering"
#         }
#       }
# 
#       spec {
#         container {
#           name = "hello"
#           image = "gcr.io/google-samples/hello-app:2.0"
# 
#           env {
#             name = "PORT"
#             value = "50000"
#           }
#         }
#       }
#     }
#   }
# }
# 
# resource "kubernetes_service" "example" {
#   metadata {
#     name = "my-np-service"
#   }
#   spec {
#     selector = {
#       app = "metrics"
#       department = "engineering"
#     }
# 
#     port {
#       name = "http"
#       protocol = "TCP"
#       port        = 80
#       target_port = 50000
#     }
#   }
# }
# 
# resource "kubernetes_ingress" "example" {
#   metadata {
#     name = "example"
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#       "cert-manager.io/issuer" = "letsencrypt-prod"
#     }
#   }
# 
#   spec {
#     tls {
#       hosts = ["example.resourcer.work"]
#       secret_name = "example-resourcer-tsl"
#     }
# 
#     rule {
#       host = "example.resourcer.work"
#       http {
#         path {
#           path = "/"
#           backend {
#             service_name = "my-np-service"
#             service_port = "http"
#           }
#         }
#       }
#     }
#   }
# }
# 

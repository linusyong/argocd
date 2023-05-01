resource "kubernetes_namespace" "metrics_server" {
  metadata {
    name = "metrics-server"
  }
}
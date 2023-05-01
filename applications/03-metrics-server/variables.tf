variable "metrics_server_helm_version" {
  description = "The Metrics Server Helm Chart version to be installed"
  type        = string
  default     = "6.2.17"
  # https://artifacthub.io/packages/helm/bitnami/metrics-server
}
variable "helm_repo_version" {
  description = "The helm repository version"
  type        = string
  default     = "v0.0.2"
  # https://github.com/linusyong/helm-charts/tags
}

variable "metrics_server_helm_version" {
  description = "The helm chart version of metrics-server"
  type        = string
  default     = "6.2.17"
  # https://artifacthub.io/packages/helm/bitnami/metrics-server
}
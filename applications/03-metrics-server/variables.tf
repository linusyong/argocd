variable "helm_repo_version" {
  description = "The helm repository version"
  type        = string
  default     = "v0.0.9"
  # https://github.com/linusyong/helm-charts/tags
}

variable "metrics_server_helm_version" {
  description = "The helm chart version of metrics-server"
  type        = string
  default     = "3.10.0"
  # https://github.com/kubernetes-sigs/metrics-server/tags
}
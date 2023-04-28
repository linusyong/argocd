variable "argo_cd__helm_version" {
  description = "The ArgoCD Helm Chart version to be installed"
  type        = string
  default     = "5.29.1"
  # https://artifacthub.io/packages/helm/argo/argo-cd
}
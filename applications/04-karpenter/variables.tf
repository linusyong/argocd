variable "profile" {
  description = "AWS Profile Name"
  type        = string
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "ap-southeast-1"
}

variable "helm_repo_version" {
  description = "The helm repository version"
  type        = string
  default     = "v0.0.9"
  # https://github.com/linusyong/helm-charts/tags
}

variable "karpenter_helm_version" {
  description = "The helm chart version of metrics-server"
  type        = string
  default     = "v0.27.3"
  # https://github.com/aws/karpenter/releases
}
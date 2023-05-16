resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = "karpenter"
  }
}
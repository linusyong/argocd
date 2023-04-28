resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_cd__helm_version
  namespace  = kubernetes_namespace.argo_cd.metadata[0].name

  depends_on = [
    kubernetes_namespace.argo_cd
  ]
}

resource "kubernetes_namespace" "argo_cd" {
  metadata {
    name = "argo-cd"
  }
}
resource "kubernetes_manifest" "metrics_server_application" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "metrics-server"
      "namespace" = "argo-cd"
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/linusyong/helm-charts"
        "targetRevision" = var.helm_repo_version
        "path"           = "metrics-server/${var.metrics_server_helm_version}"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"      = "true"
          "allowEmpty" = "true"
        }
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "metrics-server"
      }
    }
  }

  depends_on = [
    kubernetes_manifest.metrics_server_helm_repo,
  ]
}

resource "kubernetes_manifest" "metrics_server_helm_repo" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "metrics-server-helm-repo"
      "namespace" = "argo-cd"
      "labels" = {
        "argocd.argoproj.io/secret-type" = "repository"
      }
    }
    "data" = {
      "type" = base64encode("git")
      "url"  = base64encode("https://github.com/linusyong/helm-charts")
    }
  }
}
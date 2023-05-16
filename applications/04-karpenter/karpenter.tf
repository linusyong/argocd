resource "kubernetes_manifest" "karpenter_application" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "karpenter"
      "namespace" = "argo-cd"
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/linusyong/helm-charts"
        "targetRevision" = var.helm_repo_version
        "path"           = "karpenter/${var.karpenter_helm_version}"
        "helm" = {
          "valueFiles" = [
            "values.yaml",
            "values-dev.yaml",
          ]
          "parameters" = [
            {
              "name"  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
              "value" = aws_iam_role.karpenter_iam_role.arn
            },
            {
              "name"  = "settings.aws.defaultInstanceProfile"
              "value" = one(data.aws_iam_instance_profiles.instance_profile.names)
            },
            {
              "name"  = "settings.aws.clusterName"
              "value" = data.terraform_remote_state.eks.outputs.cluster.name
            },
            {
              "name"  = "controller.clusterEndpoint"
              "value" = data.terraform_remote_state.eks.outputs.cluster.endpoint
            },
          ]
        }
      }
      "syncPolicy" = {
        "syncOptions" = [
          "RespectIgnoreDifferences=true",
        ]
        "automated" = {
          "prune"      = "true"
          "allowEmpty" = "true"
        }
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "karpenter"
      }
      "ignoreDifferences" = [
        {
          "kind" = "Secret",
          "jsonPointers" = [
            "/data",
          ]
        }
      ]
    }
  }

  depends_on = [
    kubernetes_manifest.kerpenter_helm_repo,
  ]
}

resource "kubernetes_manifest" "kerpenter_helm_repo" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Secret"
    "metadata" = {
      "name"      = "kerpenter-helm-repo"
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
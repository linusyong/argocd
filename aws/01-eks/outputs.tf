output "oidc_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role" {
  value = resource.aws_iam_role.node
}

output "cluster" {
  value = resource.aws_eks_cluster.this
}
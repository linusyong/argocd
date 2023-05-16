output "oidc_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role_arn" {
  value = resource.aws_iam_role.node.arn
}

output "cluster" {
  value = resource.aws_eks_cluster.this
}
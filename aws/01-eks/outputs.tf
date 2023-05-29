output "oidc_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "node_role" {
  value = aws_iam_role.node
}

output "cluster" {
  value = aws_eks_cluster.this
}

output "karpenter_iam_role" {
  value = aws_iam_role.karpenter_iam_role
}
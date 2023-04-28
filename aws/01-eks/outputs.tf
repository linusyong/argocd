output "oidc_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
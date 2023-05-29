# aws eks describe-addon-versions --kubernetes-version 1.26 \
#   --query 'addons[].{MarketplaceProductUrl: marketplaceInformation.productUrl, Name: addonName, Owner: owner Publisher: publisher, Type: type}' \
#   --output table --profile sandbox-dns | cat
#
# aws eks describe-addon-versions --kubernetes-version 1.26 \ 
#   --addon-name aws-ebs-csi-driver \
#   --query 'addons[].addonVersions[].{Version: addonVersion, Defaultversion: compatibilities[0].defaultVersion}' \
#   --output table --profile sandbox-dns | cat
#

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "aws-ebs-csi-driver"
  addon_version     = "v1.19.0-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "vpc-cni"
  addon_version     = "v1.12.6-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "coredns"
  addon_version     = "v1.10.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.this.name
  addon_name        = "kube-proxy"
  addon_version     = "v1.27.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
}
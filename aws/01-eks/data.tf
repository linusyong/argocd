data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ebs_csi_iam_policy" {
  name = "AmazonEBSCSIDriverPolicy"
}

data "aws_ssm_parameter" "bottlerocket_image_id" {
  name = "/aws/service/bottlerocket/aws-k8s-${var.eks_version}/x86_64/latest/image_id"
}

data "aws_ami" "bottlerocket_image" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.bottlerocket_image_id.value]
  }
}
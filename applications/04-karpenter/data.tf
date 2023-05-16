locals {
  eks_remote_state = abspath(path.cwd)
}

data "aws_caller_identity" "current" {}

data "aws_iam_instance_profiles" "instance_profile" {
  role_name = data.terraform_remote_state.eks.outputs.node_role.name
}

data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "${local.eks_remote_state}/../01-eks/terraform.tfstate"
  }
}
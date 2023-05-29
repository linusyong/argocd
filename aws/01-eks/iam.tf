## karpenter IRSA
data "aws_iam_policy_document" "karpenter_policy_document" {
  statement {
    sid = "Karpenter"
    actions = [
      "ssm:GetParameter",
      "iam:PassRole",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateTags",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid     = "ConditionalEC2Termination"
    actions = ["ec2:TerminateInstances"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/Name"
      values   = ["*karpenter*"]
    }
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid       = "PassNodeIAMRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = [aws_iam_role.node.arn]
  }

  statement {
    sid       = "EKSClusterEndpointLookup"
    actions   = ["eks:DescribeCluster"]
    effect    = "Allow"
    resources = [aws_eks_cluster.this.arn]
  }
}

resource "aws_iam_policy" "karpenter_policy" {
  description = "Grant permissions for 'Karpenter'"
  name        = "karpenter-policy"
  policy      = data.aws_iam_policy_document.karpenter_policy_document.json
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "karpenter_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        format("arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}")
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }
  }
}

resource "aws_iam_role" "karpenter_iam_role" {
  description        = "Role that can be assumed by 'karpenter"
  name               = "karpenter-iam-role"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role_policy_doc.json
  # assume_role_policy = data.terraform_remote_state.eks.outputs.irsa_assume_role_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "karpenter_iam_role_attachment" {
  role       = aws_iam_role.karpenter_iam_role.name
  policy_arn = aws_iam_policy.karpenter_policy.arn
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [join("", data.tls_certificate.this.*.certificates.0.sha1_fingerprint)]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

## EBS CSI IRSA
data "aws_iam_policy_document" "ebs_csi_assume_role_policy_doc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [
        format("arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}")
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "ebs_csi_iam_role" {
  description        = "Role that can be assumed by ebs csi driver"
  name               = "ebs-csi-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_attachment" {
  role       = aws_iam_role.ebs_csi_iam_role.name
  policy_arn = data.aws_iam_policy.ebs_csi_iam_policy.arn
}
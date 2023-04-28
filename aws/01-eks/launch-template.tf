# resource "aws_launch_template" "eks_lt" {
#   name_prefix            = "${var.project}-"
#   description            = "Launch-Template for ${aws_eks_cluster.this.name}"
#   update_default_version = true

#   block_device_mappings {
#     device_name = "/dev/xvda"

#     ebs {
#       volume_size           = 100
#       volume_type           = "gp3"
#       delete_on_termination = true
#       # encrypted             = true
#       # kms_key_id            = var.kms_key_arn
#     }
#   }

#   monitoring {
#     enabled = true
#   }

#   # vpc_security_group_ids = [aws_security_group.eks_nodes.id]

#   network_interfaces {
#     associate_public_ip_address = false
#     delete_on_termination       = true
#     security_groups             = [aws_security_group.eks_nodes.id]
#   }

#   # if you want to use a custom AMI
#   image_id      = data.aws_ami.bottlerocket_image.id
#   instance_type = "t3.medium"

#   # If you use a custom AMI, you need to supply via user-data, the bootstrap script as EKS DOESNT merge its managed user-data then
#   # you can add more than the minimum code you see in the template, e.g. install SSM agent, see https://github.com/aws/containers-roadmap/issues/593#issuecomment-577181345
#   #
#   # (optionally you can use https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config to render the script, example: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/997#issuecomment-705286151)

#   # user_data = base64encode(
#   #   data.template_file.launch_template_userdata.rendered,
#   # )

#   # Supplying custom tags to EKS instances is another use-case for LaunchTemplates
#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "${aws_eks_cluster.this.name}-worker-node"
#     }
#   }

#   # Supplying custom tags to EKS instances root volumes is another use-case for LaunchTemplates. (doesnt add tags to dynamically provisioned volumes via PVC)
#   tag_specifications {
#     resource_type = "volume"

#     tags = {
#       Name = "${aws_eks_cluster.this.name}-worker-node"
#     }
#   }

#   # Supplying custom tags to EKS instances ENI's is another use-case for LaunchTemplates

#   # Tag the LT itself
#   tags = {
#     Name = "${aws_eks_cluster.this.name}-worker-node"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   depends_on = [
#     aws_eks_cluster.this
#   ]
# }
data "aws_partition" "current" {}

# Find the user currently in use by AWS
data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:${var.vpc_tag_key}"
    values = [local.tag_val_vpc]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:${var.vpc_tag_key}"
    values = ["${local.tag_val_private_subnet}*"]
  }
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.27.0"

  cluster_name    = "${local.prefix_name}-eks"
  cluster_version = var.cluster_version
  enable_irsa     = true

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.eks_admin_role_name}" # The ARN of the IAM role
      username = "eks-admin-role"                                                                                    # The user name within Kubernetes to map to the IAM role
      groups   = ["system:masters"]                                                                            # A list of groups within Kubernetes to which the role is mapped; Checkout K8s Role and Rolebindings
    },
    #{
    #  rolearn = module.karpenter.role_arn
    #  username = "system:node:{{EC2PrivateDNSName}}"
    #  groups = [
    #    "system:bootstrappers",
    #    "system:nodes",
    #  ]
    #},
  ]

  # EKS Cluster VPC and Subnet mandatory config
  #vpc_id = module.vpc.vpc_id
  #private_subnet_ids = module.vpc.private_subnets
  vpc_id = data.aws_vpc.vpc.id
  private_subnet_ids = data.aws_subnets.private.ids

  managed_node_groups = {
    role = {
      capacity_type   = "SPOT"
      node_group_name = "general"
      instance_types  = ["t3a.small"]
      desired_size    = "1"
      max_size        = "2"
      min_size        = "1"
    }
  }

  /* cluster_timeouts = {
    create = "150m"
    update = "150m"
    delete = "150m"
  } */

  tags = local.common_tags
}
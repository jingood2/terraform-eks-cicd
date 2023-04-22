provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

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

data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.29.0"

  #-------------------------------------------
  # EKS module variables (terraform-aws-modules/eks/aws)
  #-------------------------------------------
  create_eks      = true
  cluster_name    = "${local.prefix_name}-eks"
  cluster_version = var.cluster_version
  cluster_timeouts = {
    create = "150m"
    update = "150m"
    delete = "150m"
  }
  #-------------------------------------------
  # VPC Config for EKS Cluster
  #-------------------------------------------
  vpc_id = data.aws_vpc.vpc.id
  private_subnet_ids  = data.aws_subnets.private.ids
  #public_subnet_ids   = data.aws_subnets.public.ids

  #-------------------------------------------
  # EKS Cluster CloudWatch Logging
  #-------------------------------------------
  create_cloudwatch_log_group = false
  cluster_enabled_log_types = ["api"]
  cloudwatch_log_group_retention_in_days = 7

  #-------------------------------
  # EKS Cluster IAM role
  #-------------------------------
  # Determines whether to create an OpenID Connect Provider for EKS to enable IRSA
  enable_irsa     = true

  #-------------------------------
  # Node Groups
  #-------------------------------
  managed_node_groups = {
    default = {
      capacity_type   = "SPOT"
      node_group_name = "general"
      instance_types  = ["t3a.xlarge"]
      desired_size    = "1"
      max_size        = "2"
      min_size        = "1"
    }
  }

  #self_managed_node_groups = {}
  #enable_windows_support = false

  #-------------------------------
  # Worker Additional Variables
  #-------------------------------
  create_node_security_group = true
  node_security_group_additional_rules = {}
  node_security_group_tags = {}
  worker_additional_security_group_ids = []

  #-------------------------------
  # Fargate
  #-------------------------------
  #fargate_profiles = {}

  #-------------------------------
  # aws-auth Config Map
  #-------------------------------

  map_accounts = [] #Additional AWS account numbers to add to the aws-auth ConfigMap
  map_users = []  #Additional IAM users to add to the aws-auth ConfigMap
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

  #-------------------------------
  # TEAMS (Soft Multi-tenancy)
  #-------------------------------
  #applcation_teams = {
     # First Team
  #  team-blue = {
  #    "labels" = {
  #      "appName"     = "example",
  #      "projectName" = "example",
  #      "environment" = "example",
  #      "domain"      = "example",
  #      "uuid"        = "example",
  #    }
  #    "quota" = {
  #      "requests.cpu"    = "1000m",
  #      "requests.memory" = "4Gi",
  #      "limits.cpu"      = "2000m",
  #      "limits.memory"   = "8Gi",
  #      "pods"            = "10",
  #      "secrets"         = "10",
  #      "services"        = "10"
  #    }
  #    manifests_dir = "./manifests"
  #    # Belows are examples of IAM users and roles
  #    users = [
  #      "arn:aws:iam::123456789012:user/blue-team-user",
  #      "arn:aws:iam::123456789012:role/blue-team-sso-iam-role"
  #    ]
  #  }
  #}
  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn
      ]
    }
  }

  tags = local.common_tags
}
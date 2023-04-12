data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.1.1"

  name           = "${local.prefix_name}-efs"
  creation_token = "${local.prefix_name}-efs"
  encrypted      = true

  // ToDo: Apply choice variable
  performance_mode                = "generalPurpose"
  throughput_mode                 = "bursting"

  # Mount targets / security group
  #mount_targets              = { for k, v in zipmap(["us-east-1a", "us-east-1c"], data.aws_subnets.private.ids) : k => { subnet_id = v, security_groups = [module.eks_blueprints.cluster_primary_security_group_id] } }
  mount_targets = { for id in toset(data.aws_subnets.private.ids): k => { subnet_id = id , security_groups = [module.eks_blueprints.cluster_primary_security_group_id] }}

  security_group_name = "${local.prefix_name}-efs-sg"
  security_group_description = "${local.prefix_name} EFS security group"
  security_group_vpc_id      = data.aws_vpc.vpc.id
  #security_group_rules = {
  #  vpc = {
  #    # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
  #    description = "NFS ingress from VPC private subnets"
  #    cidr_blocks = data.aws_subnets.private.cidr_blocks
  #  },
  #}

  create = var.enable_efs

  tags = local.common_tags
}

resource "kubernetes_storage_class_v1" "efs" {
  count = var.enable_efs ? 1 : 0

  metadata {
    name = "${local.prefix_name}-efs"
  }

  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"

  parameters = {
    type = "efs-ap"
    directoryPerms = "700"
    fileSystemId = module.efs.id
  }
}
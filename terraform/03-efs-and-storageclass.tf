data "aws_subnet" "private_subnet_cidr_blocks" {
  # aws_subnet_ids 데이터 원본에서 가져온 서브넷 ID를 사용합니다.
  for_each = data.aws_subnets.private.ids

  # 각 서브넷의 CIDR 블록 값을 가져오기 위해 aws_subnet 데이터 원본을 참조합니다.
  # 이 때, aws_subnet 데이터 원본은 aws_subnet_ids 데이터 원본에서 가져온 각 서브넷 ID에 대해 실행됩니다.
  id = each.key
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
  mount_targets = { for id in data.aws_subnets.private.ids: id => { subnet_id = id , security_groups = [module.eks_blueprints.cluster_primary_security_group_id] } }

  security_group_name = "${local.prefix_name}-efs-sg"
  security_group_description = "${local.prefix_name} EFS security group"
  security_group_vpc_id      = data.aws_vpc.vpc.id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "EFS ingress from VPC private subnets"
      cidr_blocks = values(data.aws_subnet.private_subnet_cidr_blocks)[*].cidr_block 
    },
  }

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
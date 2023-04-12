module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.1.1"

  name           = "${local.prefix_name}-efs"
  creation_token = "${local.prefix_name}-efs"
  encrypted      = true

  // ToDo: Apply choice variable
  performance_mode                = "maxIO"
  throughput_mode                 = "provisioned"

  # Mount targets / security group
  mount_targets              = { for k, v in zipmap(["us-east-1a", "us-east-1c"], data.aws_subnets.private.ids) : k => { subnet_id = v } }

  security_group_name = "${local.prefix_name}-efs-sg"
  security_group_description = "${local.prefix_name} EFS security group"
  security_group_vpc_id      = data.aws_vpc.vpc.id
  security_group_rules = {
    #vpc = {
    #  # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
    #  description = "NFS ingress from VPC private subnets"
    #  cidr_blocks = module.vpc.private_subnets_cidr_blocks
    #},
    private_subnet = {
      description = "NFS ingress from VPC private subnets"
      security_groups = [module.eks_blueprints.cluster_primary_security_group_id]
    }
  }

  create = false

  tags = local.common_tags


}
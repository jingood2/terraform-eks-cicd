module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix_name}-vpc"
  cidr = var.vpc_cidr_block
  #secondary_cidr_blocks   = var.secondary_cidr_blocks
  azs = var.vpc_availability_zones

  map_public_ip_on_launch = false

  public_subnets   = var.vpc_public_subnets
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets
  #intra_subnets           = var.vpc_intra_subnets

  # public_subnet_names omitted to show default name generation for all three subnets
  public_subnet_names   = var.vpc_public_subnets_names
  private_subnet_names  = var.vpc_private_subnets_names
  database_subnet_names = var.vpc_database_subnets_names

  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.prefix_name}-default-acl" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.prefix_name}-default-rt" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.prefix_name}-default-sg" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  /* customer_gateways = {
    IP1 = {
      bgp_asn     = 65112
      ip_address  = "1.2.3.4"
      device_name = "some_name"
    },
    IP2 = {
      bgp_asn    = 65112
      ip_address = "5.6.7.8"
    }
  } */
  customer_gateways = var.customer_gateways

  enable_vpn_gateway = var.enable_vpn_gateway

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.${local.owners}.${local.environment}"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.0.0.2"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.prefix_name}-eks"  = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.prefix_name}-eks"  = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
  tags = local.common_tags
}

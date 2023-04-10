# Define Local Values in Terraform
locals {
  owners      = var.project
  environment = var.environment
  prefix_name        = "${var.project}-${var.environment}"

  tag_val_vpc            = var.vpc_tag_value == "" ? "${local.prefix_name}-vpc": var.vpc_tag_value
  tag_val_private_subnet = var.vpc_tag_value == "" ? "${var.environment}-pri-" : var.vpc_tag_value

  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

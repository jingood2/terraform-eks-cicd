# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# Project
variable "project" {
  description = "Project in the large organization this Infrastructure belongs"
  type        = string
  default     = "jingood2"
}

#####################################################################################
# 01. eks-blueprints Input Variables
#####################################################################################
# VPC Name
variable "vpc_tag_key" {
  description = "The tag key of the VPC and subnets"
  type        = string
  default     = "Name"
}

variable "vpc_tag_value" {
  # if left blank then {core_stack_name} will be used
  description = "The tag value of the VPC and subnets"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string
  default     = "1.25"
}

variable "eks_admin_role_name" {
  type        = string
  description = "Additional IAM role to be admin in the cluster"
  default     = "eks-admin-role"
}
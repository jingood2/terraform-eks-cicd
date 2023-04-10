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
  default     = "poc"
}

#####################################################################################
# VPC Input Variables
#####################################################################################
# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "vpc"
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones" {
  description = "VPC Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1c"]
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "vpc_public_subnets_names" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["dev-pub-1a", "dev-pub-1c"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "vpc_private_subnets_names" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["dev-pri-1a", "dev-pri-1c"]
}

# VPC Database Subnets
variable "vpc_database_subnets" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "vpc_database_subnets_names" {
  description = "VPC Database Subnets"
  type        = list(string)
  default     = ["dev-db-1a", "dev-db-1c"]
}

# VPC Create Database Subnet Group (True / False)
variable "vpc_create_database_subnet_group" {
  description = "VPC Create Database Subnet Group"
  type        = bool
  default     = false
}

# VPC Create Database Subnet Route Table (True or False)
variable "vpc_create_database_subnet_route_table" {
  description = "VPC Create Database Subnet Route Table"
  type        = bool
  default     = false
}

# VPC Enable NAT Gateway (True or False)
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = true
}

variable "customer_gateways" {
  description = "A map of customer gateway"
  type        = any
  default     = {}
}

variable "enable_vpn_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = false
}

#IP1 = {
#    bgp_asn     = 65112
#    ip_address  = "1.2.3.4"
#    device_name = "some_name"
#},
#IP2 = {
#  bgp_asn    = 65112
#  ip_address = "5.6.7.8"
#}

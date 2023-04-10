<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | `"us-east-1"` | no |
| <a name="input_customer_gateways"></a> [customer\_gateways](#input\_customer\_gateways) | A map of customer gateway | `any` | `{}` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Enable only single NAT Gateway in one Availability Zone to save costs during our demos | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | `"dev"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project in the large organization this Infrastructure belongs | `string` | `"poc"` | no |
| <a name="input_vpc_availability_zones"></a> [vpc\_availability\_zones](#input\_vpc\_availability\_zones) | VPC Availability Zones | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1c"<br>]</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_create_database_subnet_group"></a> [vpc\_create\_database\_subnet\_group](#input\_vpc\_create\_database\_subnet\_group) | VPC Create Database Subnet Group | `bool` | `false` | no |
| <a name="input_vpc_create_database_subnet_route_table"></a> [vpc\_create\_database\_subnet\_route\_table](#input\_vpc\_create\_database\_subnet\_route\_table) | VPC Create Database Subnet Route Table | `bool` | `false` | no |
| <a name="input_vpc_database_subnets"></a> [vpc\_database\_subnets](#input\_vpc\_database\_subnets) | VPC Database Subnets | `list(string)` | <pre>[<br>  "10.0.20.0/24",<br>  "10.0.21.0/24"<br>]</pre> | no |
| <a name="input_vpc_database_subnets_names"></a> [vpc\_database\_subnets\_names](#input\_vpc\_database\_subnets\_names) | VPC Database Subnets | `list(string)` | <pre>[<br>  "dev-db-1a",<br>  "dev-db-1c"<br>]</pre> | no |
| <a name="input_vpc_enable_nat_gateway"></a> [vpc\_enable\_nat\_gateway](#input\_vpc\_enable\_nat\_gateway) | Enable NAT Gateways for Private Subnets Outbound Communication | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC Name | `string` | `"vpc"` | no |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | VPC Private Subnets | `list(string)` | <pre>[<br>  "10.0.10.0/24",<br>  "10.0.11.0/24"<br>]</pre> | no |
| <a name="input_vpc_private_subnets_names"></a> [vpc\_private\_subnets\_names](#input\_vpc\_private\_subnets\_names) | VPC Private Subnets | `list(string)` | <pre>[<br>  "dev-pri-1a",<br>  "dev-pri-1c"<br>]</pre> | no |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | VPC Public Subnets | `list(string)` | <pre>[<br>  "10.0.0.0/24",<br>  "10.0.1.0/24"<br>]</pre> | no |
| <a name="input_vpc_public_subnets_names"></a> [vpc\_public\_subnets\_names](#input\_vpc\_public\_subnets\_names) | VPC Public Subnets | `list(string)` | <pre>[<br>  "dev-pub-1a",<br>  "dev-pub-1c"<br>]</pre> | no |
| <a name="input_vpc_single_nat_gateway"></a> [vpc\_single\_nat\_gateway](#input\_vpc\_single\_nat\_gateway) | Enable only single NAT Gateway in one Availability Zone to save costs during our demos | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | A list of availability zones spefified as argument to this module |
| <a name="output_database_subnet_arns"></a> [database\_subnet\_arns](#output\_database\_subnet\_arns) | List of ARNs of database subnets |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of cidr\_blocks of database subnets |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_secondary_cidr_blocks"></a> [vpc\_secondary\_cidr\_blocks](#output\_vpc\_secondary\_cidr\_blocks) | List of secondary CIDR blocks of the VPC |
<!-- END_TF_DOCS -->
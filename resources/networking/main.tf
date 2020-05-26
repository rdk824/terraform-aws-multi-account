module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 2.24.0"

 
  # VPC
  create_vpc = lookup(var.network_params, "create_vpc", var.create_vpc)
  name       = lookup(var.network_params, "vpc_name", var.vpc_name)
  cidr       = lookup(var.network_params, "vpc_cidr", var.vpc_cidr)

  # DNS
  enable_dns_hostnames = lookup(var.network_params, "enable_dns_hostnames", var.enable_dns_hostnames)
  enable_dns_support   = lookup(var.network_params, "enable_dns_support", var.enable_dns_support)

  # ClassicLink
  enable_classiclink             = lookup(var.network_params, "enable_classiclink", var.enable_classiclink)
  enable_classiclink_dns_support = lookup(var.network_params, "enable_classiclink_dns_support", var.enable_classiclink_dns_support)

  # DHCP
  enable_dhcp_options              = lookup(var.network_params, "enable_dhcp_options", var.enable_dhcp_options)
  dhcp_options_domain_name         = lookup(var.network_params, "dhcp_options_domain_name", var.dhcp_options_domain_name)
  dhcp_options_domain_name_servers = lookup(var.network_params, "dhcp_options_domain_name_servers", var.dhcp_options_domain_name_servers)

  # Subnets
  azs                 = lookup(var.network_params, "azs", var.azs)
  private_subnets     = lookup(var.network_params, "private_subnets", var.private_subnets)
  public_subnets      = lookup(var.network_params, "public_subnets", var.public_subnets)
  database_subnets    = lookup(var.network_params, "database_subnets", var.database_subnets)
  elasticache_subnets = lookup(var.network_params, "elasticache_subnets", var.elasticache_subnets)
  redshift_subnets    = lookup(var.network_params, "redshift_subnets", var.redshift_subnets)
  intra_subnets       = lookup(var.network_params, "intra_subnets", var.intra_subnets)

  create_database_subnet_group = lookup(var.network_params, "create_database_subnet_group", var.create_database_subnet_group)

  # Gateways
  enable_nat_gateway  = lookup(var.network_params, "enable_nat_gateway", var.enable_nat_gateway)
  single_nat_gateway  = lookup(var.network_params, "single_nat_gateway", var.single_nat_gateway)
  customer_gateways   = lookup(var.network_params, "customer_gateways", var.customer_gateways)
  enable_vpn_gateway  = lookup(var.network_params, "enable_vpn_gateway", var.enable_vpn_gateway)


  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Name        = lookup(var.network_params, "vpc_name", var.vpc_name)
    }
  )

}
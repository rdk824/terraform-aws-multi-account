locals {
  workspace = local.accounts[terraform.workspace]
  accounts = {
    production = {
      app1_network          = {
        create_vpc        = true

        # VPC
        vpc_name           = "app1-vpc-${terraform.workspace}"
        vpc_cidr           = "10.100.0.0/16"

        # VPC Flow Logs
        enable_flow_logs   = true

        # DHCP
        dhcp_options_domain_name         = "app2-${terraform.workspace}.local"

        # Subnets
        azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
        public_subnets      = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
        database_subnets    = ["10.100.7.0/24", "10.100.8.0/24", "10.100.9.0/24"]
        elasticache_subnets = ["10.100.10.0/24", "10.100.11.0/24", "10.100.12.0/24"]

        # Gateways
        enable_nat_gateway  = true
        single_nat_gateway  = false
      }
      app2_network          = {
        create_vpc = true

        # VPC
        vpc_name           = "app2-vpc-${terraform.workspace}"
        vpc_cidr           = "10.110.0.0/16"

        # VPC Flow Logs
        enable_flow_logs   = true

        # DHCP
        dhcp_options_domain_name         = "app2-${terraform.workspace}.local"

        # Subnets
        azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets     = ["10.110.1.0/24", "10.110.2.0/24", "10.110.3.0/24"]
        public_subnets      = ["10.110.4.0/24", "10.110.5.0/24", "10.110.6.0/24"]
        database_subnets    = ["10.110.7.0/24", "10.110.8.0/24", "10.110.9.0/24"]
        elasticache_subnets = ["10.110.10.0/24", "10.110.11.0/24", "10.110.12.0/24"]

        # Gateways
        enable_nat_gateway  = true
        single_nat_gateway  = false
      }
    }

    development = {
      app1_network          = {
        create_vpc        = true

        # VPC
        vpc_name           = "app1-vpc-${terraform.workspace}"
        vpc_cidr           = "10.200.0.0/16"

        # VPC Flow Logs
        enable_flow_logs   = true

        # DHCP
        dhcp_options_domain_name         = "app2-${terraform.workspace}.local"

        # Subnets
        azs                 = ["us-east-1a"]
        private_subnets     = ["10.200.1.0/24"]
        public_subnets      = ["10.200.2.0/24"]
        database_subnets    = ["10.200.3.0/24"]
        elasticache_subnets = ["10.200.4.0/24"]

        # Gateways
        enable_nat_gateway  = true
        single_nat_gateway  = true
      }
      app2_network          = {
        create_vpc = false
      }
    }
  }
}


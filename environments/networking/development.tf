locals {
    development_params = {
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



variable "environment" {
  description = "Environment name"
  type        = string
}

variable "network_params" {
  description = "Network parameters"
  type        = any
  default     = {}
}


# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = false
}

variable "vpc_name" {
  description = "Name to be used on the VPC"
  type        = string
  default     = "vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "1.1.1.1/1"
}


variable "tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# VPC Flowlogs
# ---------------------------------------------------------------------------
variable "enable_flow_logs" {
  description = "Set to true to create VPC Flow Logs"
  type        = bool
  default     = true
}

variable "retention_in_days" {
  description = "Number of days you want to retain log events in the log group"
  type        = string
  default     = "30"
}

variable "traffic_type" {
  description = "Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# DNS
# ---------------------------------------------------------------------------
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}


# ---------------------------------------------------------------------------
# ClassicLink
# ---------------------------------------------------------------------------
variable "enable_classiclink" {
  description = "Should be true to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Should be true to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."
  type        = bool
  default     = false
}


# ---------------------------------------------------------------------------
# DHCP
# ---------------------------------------------------------------------------
variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = true
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------
# Subnets
# ---------------------------------------------------------------------------

variable "azs" {
  description = "A list of availability zones for the VPC"
  type        = list
  default     = []
}

variable "public_subnets" {
  description = "Set to true to prevent the module from creating a public subnet"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}

variable "elasticache_subnets" {
  description = "A list of elasticache subnets"
  type        = list(string)
  default     = []
}

variable "redshift_subnets" {
  description = "A list of redshift subnets"
  type        = list(string)
  default     = []
}

variable "intra_subnets" {
  description = "A list of intra subnets"
  type        = list(string)
  default     = []
}

variable "create_database_subnet_group" {
  description = "Controls if database subnet group should be created"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# Gateways
# ---------------------------------------------------------------------------

# NAT Gateway
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

# Customer Gateways
variable "customer_gateways" {
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}

# VPN Gateway
variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------
# VPC Endpoints
# ---------------------------------------------------------------------------

# VPC endpoint for S3
variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for DynamoDB
variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for SSM
variable "enable_ssm_endpoint" {
  description = "Should be true if you want to provision a SSM endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for SSMMESSAGES
variable "enable_ssm_messages_endpoint" {
  description = "Should be true if you want to provision a SSMMESSAGES endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC Endpoint for EC2
variable "enable_ec2_endpoint" {
  description = "Should be true if you want to provision an EC2 endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC Endpoint for EC2MESSAGES
variable "enable_ec2_messages_endpoint" {
  description = "Should be true if you want to provision an EC2MESSAGES endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC Endpoint for ECR API
variable "enable_ecr_api_endpoint" {
  description = "Should be true if you want to provision an ECR API endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC Endpoint for ECR DKR
variable "enable_ecr_dkr_endpoint" {
  description = "Should be true if you want to provision an ECR DKR endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for KMS
variable "enable_kms_endpoint" {
  description = "Should be true if you want to provision a KMS endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for ECS
variable "enable_ecs_endpoint" {
  description = "Should be true if you want to provision an ECS endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for ECS telemetry
variable "enable_ecs_telemetry_endpoint" {
  description = "Should be true if you want to provision an ECS telemetry endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint for SQS
variable "enable_sqs_endpoint" {
  description = "Should be true if you want to provision a SQS endpoint to the VPC"
  type        = bool
  default     = false
}

# VPC endpoint tags
variable "vpc_endpoint_tags" {
  description = "Additional tags for the VPC Endpoints"
  type        = map(string)
  default     = {}
}


module "flow_logs" {
  source               = "git::https://github.com/rdansou/terraform-aws-vpc-flow-logs?ref=master"

  enable_flow_logs     = lookup(var.network_params, "enable_flow_logs", var.enable_flow_logs) ? var.create_vpc : false
  vpc_id               = module.vpc.vpc_id
  traffic_type         = lookup(var.network_params, "traffic_type", var.traffic_type)
  kms_key_id           = lookup(var.network_params, "kms_key_id", "")
}
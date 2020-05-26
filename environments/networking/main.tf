
#---------------------------------------------------#
# Networking module                                 #
#---------------------------------------------------#


module "app1-network" {
  source           = "../../resources/networking"

  network_params = local.workspace["app1_network"]
  environment    = terraform.workspace
}

module "app2-network" {
  source           = "../../resources/networking"

  network_params = local.workspace["app2_network"]
  environment    = terraform.workspace
}

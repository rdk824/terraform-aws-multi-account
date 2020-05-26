locals {
  workspace = local.accounts[terraform.workspace]
  accounts = {
    production = local.production_params

    development = local.development_params
  }
}


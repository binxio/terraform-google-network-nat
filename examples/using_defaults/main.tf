locals {
  owner       = "myself"
  project     = "demo"
  environment = "dev"

  router_nats = {
    # Your example resource defintion with overrides
    # eg:
    #
    #    "set1" = {
    #      friendly_name = "demo set1"
    #      description   = "demo the router_nat module"
    #    }
  }
}

module "router_nat" {
  source  = "binxio/network-nat/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  router_nats = local.router_nats
}

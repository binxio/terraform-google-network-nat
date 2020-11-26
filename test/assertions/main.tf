locals {
  owner       = var.owner
  project     = "testapp"
  environment = var.environment

  router_nats = {
    "Way too long resource name. With invalid character so this should most definately fail!" = {
      not_existing = "should-fail"
    }
  }
}

module "router_nat" {
  source = "../../"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  router_nats = local.router_nats
}


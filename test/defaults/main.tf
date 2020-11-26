locals {
  owner       = var.owner
  project     = "testapp"
  environment = var.environment

  router_nats = {
    "set1" = {
      network = var.network
      subnetwork = {
        (var.subnetwork) = {
          source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
        }
      }
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

output "router_nats" {
  value = module.router_nat.map
}

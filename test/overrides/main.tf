locals {
  owner       = var.owner
  project     = "testapp"
  environment = var.environment

  router_nats = {
    "set1" = {
      network = var.network
      subnetwork = {
        (var.subnetwork) = {
          source_ip_ranges_to_nat  = ["LIST_OF_SECONDARY_IP_RANGES"]
          secondary_ip_range_names = ["k8pods-terratest"]
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

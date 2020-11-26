locals {
  owner       = "myself"
  project     = "testapp"
  region      = "global"
  environment = var.environment

  # VPC settings
  vpc = {
    network_name = "private-router-nat"
    subnets = {
      "router-nat-asserts" = {
        ip_cidr_range = "10.20.0.0/25"
        region        = "europe-west1"
      }
      "router-nat-k8nodes" = {
        ip_cidr_range = "10.10.0.0/25"
        region        = "europe-west4"
        secondary_ip_ranges = [
          {
            range_name    = "k8services-terratest"
            ip_cidr_range = "10.10.0.128/27"
          },
          {
            range_name    = "k8pods-terratest"
            ip_cidr_range = "172.16.0.0/17"
          }
        ]
      }
    }
    routes = {
      "default-gateway-router-nat" = {
        dest_range       = "0.0.0.0/0"
        next_hop_gateway = "default-internet-gateway"
        description      = "Allow GKE nodes to bootstrap"
      }
    }
  }
}

##########################################
#
# Create resources which are not part of 
# the module test but are prerequisits for
# the module to work.
#
##########################################

module "vpc" {
  source  = "binxio/network-vpc/google"
  version = "~> 1.0.0"

  owner       = local.owner
  project     = local.project
  environment = local.environment

  network_name = local.vpc.network_name
  subnets      = local.vpc.subnets
  routes       = local.vpc.routes
}

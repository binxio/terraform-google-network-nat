#---------------------------------------------------------------------------------------------
# Define our locals for increased readability
#---------------------------------------------------------------------------------------------

locals {
  owner       = var.owner
  project     = var.project
  environment = var.environment

  # Startpoint for our router_nat defaults
  module_router_nat_defaults = {
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    router                             = null
    nat_ips                            = null
    drain_nat_ips                      = null
    network                            = null
    subnetwork                         = {}
    min_ports_per_vm                   = null
    udp_idle_timeout_sec               = 30
    icmp_idle_timeout_sec              = 30
    tcp_established_idle_timeout_sec   = 1200
    tcp_transitory_idle_timeout_sec    = 30
    log_config = {
      enable = true
      filter = "ALL"
    }
    region = "europe-west4"
    owner  = var.owner
  }
  module_router_nat_subnetwork_defaults = {
    source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"]
    secondary_ip_range_names = null
  }
  # Merge defaults with module defaults and user provided variables
  router_nat_defaults            = var.router_nat_defaults == null ? local.module_router_nat_defaults : merge(local.module_router_nat_defaults, var.router_nat_defaults)
  router_nat_subnetwork_defaults = var.router_nat_subnetwork_defaults == null ? local.module_router_nat_subnetwork_defaults : merge(local.module_router_nat_subnetwork_defaults, var.router_nat_subnetwork_defaults)

  # Another product that does not support labels yet.
  #labels = {
  #  "project" = substr(replace(lower(local.project), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  #  "env"     = substr(replace(lower(local.environment), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  #  "owner"   = substr(replace(lower(local.owner), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  #  "creator" = "terraform"
  #}

  # Merge router_nat global default settings with router_nat specific settings
  router_nats = {
    for router_nat, settings in var.router_nats :
    router_nat => merge(
      local.router_nat_defaults, settings
    )
  }
}

#---------------------------------------------------------------------------------------------
# GCP Resources
#---------------------------------------------------------------------------------------------

resource "google_compute_router_nat" "map" {
  provider = google

  for_each = local.router_nats

  name                               = each.value.region
  nat_ip_allocate_option             = each.value.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat
  router                             = coalesce(each.value.router, format("nat-%s", each.value.region))
  nat_ips                            = each.value.nat_ips
  drain_nat_ips                      = each.value.drain_nat_ips

  dynamic "subnetwork" {
    for_each = { for subnetwork, settings in each.value.subnetwork : subnetwork => merge(local.router_nat_subnetwork_defaults, settings) }

    content {
      name                     = subnetwork.key
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = try(subnetwork.value.secondary_ip_range_names, null)
    }
  }

  min_ports_per_vm                 = each.value.min_ports_per_vm
  udp_idle_timeout_sec             = each.value.udp_idle_timeout_sec
  icmp_idle_timeout_sec            = each.value.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = each.value.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = each.value.tcp_transitory_idle_timeout_sec

  log_config {
    enable = each.value.log_config.enable
    filter = each.value.log_config.filter
  }
  region = each.value.region

  # Labels are not yet supported
  #labels = merge(
  #  local.labels,
  #  {
  #    purpose = substr(replace(lower(each.key), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  #    owner   = substr(replace(lower(each.value.owner), "/[^\\p{Ll}\\p{Lo}\\p{N}_-]+/", "_"), 0, 63)
  #  }
  #)

  depends_on = [google_compute_router.map]
}

resource "google_compute_router" "map" {
  for_each = { for nat, settings in local.router_nats : nat => settings if ! can(settings.router) || try(settings.router, null) == null }

  name    = format("nat-%s", each.value.region)
  network = each.value.network
  region  = each.value.region
}

#------------------------------------------------------------------------------------------------------------------------
#
# Generic variables
#
#------------------------------------------------------------------------------------------------------------------------
variable "owner" {
  description = "Owner of the resource. This variable is used to set the 'owner' label. Will be used as default for each subnet, but can be overridden using the subnet settings."
  type        = string
}

variable "project" {
  description = "Company project name."
  type        = string
}

variable "environment" {
  description = "Company environment for which the resources are created (e.g. dev, tst, acc, prd, all)."
  type        = string
}

#------------------------------------------------------------------------------------------------------------------------
#
# router_nat variables
#
#------------------------------------------------------------------------------------------------------------------------

variable "router_nats" {
  description = <<EOF
Map of router_nats to be created. The key will be used for the router_nat name so it should describe the router_nat purpose. The value can be a map with the following keys to override default settings:
  * nat_ip_allocate_option
  * source_subnetwork_ip_ranges_to_nat
  * router
  * nat_ips
  * drain_nat_ips
  * network
  * subnetwork
  * min_ports_per_vm
  * udp_idle_timeout_sec
  * icmp_idle_timeout_sec
  * tcp_established_idle_timeout_sec
  * tcp_transitory_idle_timeout_sec
  * log_config
  * region
  * project
EOF

  type = map(any)
}

variable "router_nat_defaults" {
  type = object({
    nat_ip_allocate_option             = string # AUTO_ONLY, MANUAL_ONLY
    source_subnetwork_ip_ranges_to_nat = string # ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS.
    router                             = string
    nat_ips                            = list(string) #  Only valid if natIpAllocateOption is set to MANUAL_ONLY.
    drain_nat_ips                      = list(string)
    network                            = string
    subnetwork = map(object({
      name                     = string
      source_ip_ranges_to_nat  = list(string) # ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.
      secondary_ip_range_names = list(string) # Only valid if LIST_OF_SECONDARY_IP_RANGES is chosen
    }))
    min_ports_per_vm                 = number
    udp_idle_timeout_sec             = number
    icmp_idle_timeout_sec            = number
    tcp_established_idle_timeout_sec = number
    tcp_transitory_idle_timeout_sec  = number
    log_config = object({
      enable = bool
      filter = string # ERRORS_ONLY, TRANSLATIONS_ONLY, ALL.
    })
    region = string
  })

  default = null
}

variable "router_nat_subnetwork_defaults" {
  type = object({
    source_ip_ranges_to_nat  = list(string) # ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE.
    secondary_ip_range_names = list(string) # Only valid if LIST_OF_SECONDARY_IP_RANGES is chosen
  })

  default = null
}

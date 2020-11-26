output "router_nat_defaults" {
  description = "The generic defaults used for router_nat settings"
  value       = local.module_router_nat_defaults
}

output "router_nat_subnetwork_defaults" {
  description = "The generic defaults used for router_nat subnetwork settings"
  value       = local.module_router_nat_subnetwork_defaults
}

output "map" {
  description = "outputs for all router_nats created"
  value       = google_compute_router_nat.map
}

output "router_map" {
  description = "outputs for all router created"
  value       = google_compute_router.map
}

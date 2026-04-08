output "entitlement_policy_id" {
  description = "Entitlement management policy ID"
  value       = local.effective.enable_entitlement_discovery ? okta_policy.entitlement_management[0].id : null
}

output "entitlement_bundle_group_ids" {
  description = "Map of bundle names to Okta group IDs"
  value = {
    for name, group in okta_group.entitlement_bundle : name => group.id
  }
}

output "effective_sync_interval_hours" {
  description = "Resolved entitlement sync interval in hours"
  value       = local.effective.entitlement_sync_interval_hours
}

output "bundles_enabled" {
  description = "Whether entitlement bundles are enabled"
  value       = local.effective.enable_entitlement_bundles
}

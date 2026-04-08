output "resource_catalog_policy_id" {
  description = "Resource catalog policy ID"
  value       = local.effective.enable_resource_catalog ? okta_policy.resource_catalog[0].id : null
}

output "catalog_enabled" {
  description = "Whether the resource catalog is enabled"
  value       = local.effective.enable_resource_catalog
}

output "effective_catalog_visibility" {
  description = "Resolved catalog visibility mode"
  value       = local.effective.catalog_visibility
}

output "catalog_viewers_group_id" {
  description = "Catalog viewers group ID (null if visibility is all_users)"
  value       = local.effective.enable_resource_catalog && local.effective.catalog_visibility != "all_users" ? okta_group.catalog_viewers[0].id : null
}

output "catalog_item_owner_group_ids" {
  description = "Map of catalog item names to owner group IDs"
  value = {
    for name, group in okta_group.catalog_item_owners : name => group.id
  }
}

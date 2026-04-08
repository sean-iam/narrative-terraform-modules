# =============================================================================
# [Narrative] Apps Module — Outputs
# =============================================================================

output "app_management_ou_path" {
  description = "OU path for app management policy"
  value       = googleworkspace_org_unit.app_management.org_unit_path
}

output "saml_app_ou_paths" {
  description = "Map of SAML app name to documentation OU path"
  value       = { for k, v in googleworkspace_org_unit.saml_apps : k => v.org_unit_path }
}

output "saml_app_count" {
  description = "Number of SAML apps configured"
  value       = length(var.saml_apps)
}

output "blocked_app_count" {
  description = "Number of blocked OAuth app client IDs"
  value       = length(var.blocked_apps)
}
